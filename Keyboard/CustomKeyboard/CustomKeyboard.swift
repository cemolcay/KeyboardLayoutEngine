//
//  CustomKeyboard.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 11/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

// MARK: - CustomKeyboardDelegate
@objc public protocol CustomKeyboardDelegate {
  @objc optional func customKeyboard(_ customKeyboard: CustomKeyboard, keyboardButtonPressed keyboardButton: KeyboardButton)
  @objc optional func customKeyboard(_ customKeyboard: CustomKeyboard, keyButtonPressed key: String)
  @objc optional func customKeyboardSpaceButtonPressed(_ customKeyboard: CustomKeyboard)
  @objc optional func customKeyboardBackspaceButtonPressed(_ customKeyboard: CustomKeyboard)
  @objc optional func customKeyboardGlobeButtonPressed(_ customKeyboard: CustomKeyboard)
  @objc optional func customKeyboardReturnButtonPressed(_ customKeyboard: CustomKeyboard)
}

// MARK: - CustomKeyboard
open class CustomKeyboard: UIView, KeyboardLayoutDelegate {
  open var keyboardLayout = CustomKeyboardLayout()
  open weak var delegate: CustomKeyboardDelegate?

  // MARK: CustomKeyobardShiftState
  public enum CustomKeyboardShiftState {
    case once
    case off
    case on
  }

  // MARK: CustomKeyboardLayoutState
  public enum CustomKeyboardLayoutState {
    case letters(shiftState: CustomKeyboardShiftState)
    case numbers
    case symbols
  }

  open fileprivate(set) var keyboardLayoutState: CustomKeyboardLayoutState = .letters(shiftState: CustomKeyboardShiftState.once) {
    didSet {
      keyboardLayoutStateDidChange(oldState: oldValue, newState: keyboardLayoutState)
    }
  }

  // MARK: Shift
  open var shiftToggleInterval: TimeInterval = 0.5
  fileprivate var shiftToggleTimer: Timer?

  // MARK: Backspace
  open var backspaceDeleteInterval: TimeInterval = 0.1
  open var backspaceAutoDeleteModeInterval: TimeInterval = 0.5
  fileprivate var backspaceDeleteTimer: Timer?
  fileprivate var backspaceAutoDeleteModeTimer: Timer?

  // MARK: KeyMenu
  open var keyMenuLocked: Bool = false
  open var keyMenuOpenTimer: Timer?
  open var keyMenuOpenTimeInterval: TimeInterval = 1
  open var keyMenuShowingKeyboardButton: KeyboardButton? {
    didSet {
      oldValue?.showKeyPop(show: false)
      oldValue?.showKeyMenu(show: false)
      keyMenuShowingKeyboardButton?.showKeyPop(show: false)
      keyMenuShowingKeyboardButton?.showKeyMenu(show: true)
      DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(0.1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { [weak self] in
          self?.getCurrentKeyboardLayout().typingEnabled = self!.keyMenuShowingKeyboardButton == nil && self!.keyMenuLocked == false
      }
    }
  }

  // MARK: Init
  public init() {
    super.init(frame: CGRect.zero)
    defaultInit()
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    defaultInit()
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    defaultInit()
  }

  fileprivate func defaultInit() {
    keyboardLayout = CustomKeyboardLayout()
    keyboardLayoutStateDidChange(oldState: nil, newState: keyboardLayoutState)
  }

  // MARK: Layout
  open override func layoutSubviews() {
    super.layoutSubviews()

    getCurrentKeyboardLayout().frame = CGRect(
      x: 0,
      y: 0,
      width: frame.size.width,
      height: frame.size.height)
  }

  // MARK: KeyboardLayout
  open func getKeyboardLayout(ofState state: CustomKeyboardLayoutState) -> KeyboardLayout {
    switch state {
    case .letters(let shiftState):
      switch shiftState {
      case .once:
        return keyboardLayout.uppercase
      case .on:
        return keyboardLayout.uppercaseToggled
      case .off:
        return keyboardLayout.lowercase
      }
    case .numbers:
      return keyboardLayout.numbers
    case .symbols:
      return keyboardLayout.symbols
    }
  }

  open func getCurrentKeyboardLayout() -> KeyboardLayout {
    return getKeyboardLayout(ofState: keyboardLayoutState)
  }

  open func enumerateKeyboardLayouts(_ enumerate: (KeyboardLayout) -> Void) {
    let layouts = [
      keyboardLayout.uppercase,
      keyboardLayout.uppercaseToggled,
      keyboardLayout.lowercase,
      keyboardLayout.numbers,
      keyboardLayout.symbols,
    ]

    for layout in layouts {
      enumerate(layout)
    }
  }

  open func keyboardLayoutStateDidChange(oldState: CustomKeyboardLayoutState?, newState: CustomKeyboardLayoutState) {
    // Remove old keyboard layout
    if let oldState = oldState {
      let oldKeyboardLayout = getKeyboardLayout(ofState: oldState)
      oldKeyboardLayout.delegate = nil
      oldKeyboardLayout.removeFromSuperview()
    }

    // Add new keyboard layout
    let newKeyboardLayout = getKeyboardLayout(ofState: newState)
    newKeyboardLayout.delegate = self
    addSubview(newKeyboardLayout)
    setNeedsLayout()
  }

  open func reload() {
    // Remove current
    let currentLayout = getCurrentKeyboardLayout()
    currentLayout.delegate = nil
    currentLayout.removeFromSuperview()
    // Reload layout
    keyboardLayout = CustomKeyboardLayout()
    keyboardLayoutStateDidChange(oldState: nil, newState: keyboardLayoutState)
  }

  // MARK: Capitalize
  open func switchToLetters(shiftState shift: CustomKeyboardShiftState) {
    keyboardLayoutState = .letters(shiftState: shift)
  }

  open func capitalize() {
    switchToLetters(shiftState: .once)
  }

  // MARK: Backspace Auto Delete
  fileprivate func startBackspaceAutoDeleteModeTimer() {
    backspaceAutoDeleteModeTimer = Timer.scheduledTimer(
      timeInterval: backspaceAutoDeleteModeInterval,
      target: self,
      selector: #selector(CustomKeyboard.startBackspaceAutoDeleteMode),
      userInfo: nil,
      repeats: false)
  }

  fileprivate func startBackspaceDeleteTimer() {
    backspaceDeleteTimer = Timer.scheduledTimer(
      timeInterval: backspaceDeleteInterval,
      target: self,
      selector: #selector(CustomKeyboard.autoDelete),
      userInfo: nil,
      repeats: true)
  }

  fileprivate func invalidateBackspaceAutoDeleteModeTimer() {
    backspaceAutoDeleteModeTimer?.invalidate()
    backspaceAutoDeleteModeTimer = nil
  }

  fileprivate func invalidateBackspaceDeleteTimer() {
    backspaceDeleteTimer?.invalidate()
    backspaceDeleteTimer = nil
  }

  internal func startBackspaceAutoDeleteMode() {
    invalidateBackspaceDeleteTimer()
    startBackspaceDeleteTimer()
  }

  internal func autoDelete() {
    delegate?.customKeyboardBackspaceButtonPressed?(self)
  }

  // MARK: Shift Toggle
  fileprivate func startShiftToggleTimer() {
    shiftToggleTimer = Timer.scheduledTimer(
      timeInterval: shiftToggleInterval,
      target: self,
      selector: #selector(CustomKeyboard.invalidateShiftToggleTimer),
      userInfo: nil,
      repeats: false)
  }

  internal func invalidateShiftToggleTimer() {
    shiftToggleTimer?.invalidate()
    shiftToggleTimer = nil
  }

  // MARK: KeyMenu Toggle
  fileprivate func startKeyMenuOpenTimer(forKeyboardButton keyboardButton: KeyboardButton) {
    keyMenuOpenTimer = Timer.scheduledTimer(
      timeInterval: keyMenuOpenTimeInterval,
      target: self,
      selector: #selector(CustomKeyboard.openKeyMenu(_:)),
      userInfo: keyboardButton,
      repeats: false)
  }

  fileprivate func invalidateKeyMenuOpenTimer() {
    keyMenuOpenTimer?.invalidate()
    keyMenuOpenTimer = nil
  }

  open func openKeyMenu(_ timer: Timer) {
    if let userInfo = timer.userInfo, let keyboardButton = userInfo as? KeyboardButton {
      keyMenuShowingKeyboardButton = keyboardButton
    }
  }

  // MARK: KeyboardLayoutDelegate
  open func keyboardLayout(_ keyboardLayout: KeyboardLayout, didKeyPressStart keyboardButton: KeyboardButton) {
    invalidateBackspaceAutoDeleteModeTimer()
    invalidateBackspaceDeleteTimer()
    invalidateKeyMenuOpenTimer()

    // Backspace
    if keyboardButton.identifier == CustomKeyboardIdentifier.Backspace.rawValue {
      startBackspaceAutoDeleteModeTimer()
    }

    // KeyPop and KeyMenu
    if keyboardButton.style.keyPopType != nil {
      keyboardButton.showKeyPop(show: true)
      if keyboardButton.keyMenu != nil {
        startKeyMenuOpenTimer(forKeyboardButton: keyboardButton)
      }
    } else if keyboardButton.keyMenu != nil {
      keyMenuShowingKeyboardButton = keyboardButton
      keyMenuLocked = false
    }
  }

  open func keyboardLayout(_ keyboardLayout: KeyboardLayout, didKeyPressEnd keyboardButton: KeyboardButton) {
    delegate?.customKeyboard?(self, keyboardButtonPressed: keyboardButton)

    // If keyboard key is pressed notify no questions asked
    if case KeyboardButtonType.key(let text) = keyboardButton.type {
      delegate?.customKeyboard?(self, keyButtonPressed: text)

      // If shift state was CustomKeyboardShiftState.Once then make keyboard layout lowercase
      if case CustomKeyboardLayoutState.letters(let shiftState) = keyboardLayoutState , shiftState == CustomKeyboardShiftState.once {
        keyboardLayoutState = CustomKeyboardLayoutState.letters(shiftState: .off)
        return
      }
    }

    // Chcek special keyboard buttons
    if let keyId = keyboardButton.identifier, let identifier = CustomKeyboardIdentifier(rawValue: keyId) {
      switch identifier {

      // Notify special keys
      case .Backspace:
        delegate?.customKeyboardBackspaceButtonPressed?(self)
      case .Space:
        delegate?.customKeyboardSpaceButtonPressed?(self)
      case .Globe:
        delegate?.customKeyboardGlobeButtonPressed?(self)
      case .Return:
        delegate?.customKeyboardReturnButtonPressed?(self)

      // Update keyboard layout state
      case .Letters:
        keyboardLayoutState = .letters(shiftState: .off)
      case .Numbers:
        keyboardLayoutState = .numbers
      case .Symbols:
        keyboardLayoutState = .symbols

      // Update shift state
      case .ShiftOff:
        if shiftToggleTimer == nil {
          keyboardLayoutState = .letters(shiftState: .once)
          startShiftToggleTimer()
        } else {
          keyboardLayoutState = .letters(shiftState: .on)
          invalidateShiftToggleTimer()
        }
      case .ShiftOnce:
        if shiftToggleTimer == nil {
          keyboardLayoutState = .letters(shiftState: .off)
          startShiftToggleTimer()
        } else {
          keyboardLayoutState = .letters(shiftState: .on)
          invalidateShiftToggleTimer()
        }
      case .ShiftOn:
        if shiftToggleTimer == nil {
          keyboardLayoutState = .letters(shiftState: .off)
        }
      }
    }
  }

  open func keyboardLayout(_ keyboardLayout: KeyboardLayout, didTouchesBegin touches: Set<UITouch>) {
    // KeyMenu
    if let menu = keyMenuShowingKeyboardButton?.keyMenu, let touch = touches.first {
      menu.updateSelection(touchLocation: touch.location(in: self), inView: self)
    }
  }

  open func keyboardLayout(_ keyboardLayout: KeyboardLayout, didTouchesMove touches: Set<UITouch>) {
    // KeyMenu
    if let menu = keyMenuShowingKeyboardButton?.keyMenu, let touch = touches.first {
      menu.updateSelection(touchLocation: touch.location(in: self), inView: self)
    }
  }

  open func keyboardLayout(_ keyboardLayout: KeyboardLayout, didTouchesEnd touches: Set<UITouch>?)  {
    invalidateBackspaceAutoDeleteModeTimer()
    invalidateBackspaceDeleteTimer()
    invalidateKeyMenuOpenTimer()

    // KeyMenu
    if let menu = keyMenuShowingKeyboardButton?.keyMenu, let touch = touches?.first {
      menu.updateSelection(touchLocation: touch.location(in: self), inView: self)
      // select item
      if menu.selectedIndex >= 0 {
        if let item = menu.items[safe: menu.selectedIndex] {
          item.action?(item)
        }
        keyMenuShowingKeyboardButton = nil
        keyMenuLocked = false
      } else {
        if keyMenuLocked {
          keyMenuShowingKeyboardButton = nil
          keyMenuLocked = false
          return
        }
        keyMenuLocked = true
      }
    }
  }

  open func keyboardLayout(_ keyboardLayout: KeyboardLayout, didTouchesCancel touches: Set<UITouch>?) {
    invalidateBackspaceAutoDeleteModeTimer()
    invalidateBackspaceDeleteTimer()
    invalidateKeyMenuOpenTimer()

    // KeyMenu
    if let menu = keyMenuShowingKeyboardButton?.keyMenu, let touch = touches?.first {
      menu.updateSelection(touchLocation: touch.location(in: self), inView: self)
      // select item
      if menu.selectedIndex >= 0 {
        if let item = menu.items[safe: menu.selectedIndex] {
          item.action?(item)
        }
        keyMenuShowingKeyboardButton = nil
        keyMenuLocked = false
      } else {
        if keyMenuLocked {
          keyMenuShowingKeyboardButton = nil
          keyMenuLocked = false
          getCurrentKeyboardLayout().typingEnabled = true
          return
        }
        keyMenuLocked = true
      }
    }
  }
}
