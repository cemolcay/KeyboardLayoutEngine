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
  optional func customKeyboard(customKeyboard: CustomKeyboard, keyboardButtonPressed keyboardButton: KeyboardButton)
  optional func customKeyboard(customKeyboard: CustomKeyboard, keyButtonPressed key: String)
  optional func customKeyboardSpaceButtonPressed(customKeyboard: CustomKeyboard)
  optional func customKeyboardBackspaceButtonPressed(customKeyboard: CustomKeyboard)
  optional func customKeyboardGlobeButtonPressed(customKeyboard: CustomKeyboard)
  optional func customKeyboardReturnButtonPressed(customKeyboard: CustomKeyboard)
}

// MARK: - CustomKeyboard
public class CustomKeyboard: UIView, KeyboardLayoutDelegate {
  public var keyboardLayout = CustomKeyboardLayout()
  public weak var delegate: CustomKeyboardDelegate?

  // MARK: CustomKeyobardShiftState
  public enum CustomKeyboardShiftState {
    case Once
    case Off
    case On
  }

  // MARK: CustomKeyboardLayoutState
  public enum CustomKeyboardLayoutState {
    case Letters(shiftState: CustomKeyboardShiftState)
    case Numbers
    case Symbols
  }

  private(set) var keyboardLayoutState: CustomKeyboardLayoutState = .Letters(shiftState: CustomKeyboardShiftState.Once) {
    didSet {
      keyboardLayoutStateDidChange(oldState: oldValue, newState: keyboardLayoutState)
    }
  }

  // MARK: Shift
  public var shiftToggleInterval: NSTimeInterval = 0.5
  private var shiftToggleTimer: NSTimer?

  // MARK: Backspace
  public var backspaceDeleteInterval: NSTimeInterval = 0.1
  public var backspaceAutoDeleteModeInterval: NSTimeInterval = 0.5
  private var backspaceDeleteTimer: NSTimer?
  private var backspaceAutoDeleteModeTimer: NSTimer?

  // MARK: KeyMenu
  public var keyMenuLocked: Bool = false
  public var keyMenuOpenTimer: NSTimer?
  public var keyMenuOpenTimeInterval: NSTimeInterval = 1
  public var keyMenuShowingKeyboardButton: KeyboardButton? {
    didSet {
      oldValue?.showKeyPop(show: false)
      oldValue?.showKeyMenu(show: false)
      keyMenuShowingKeyboardButton?.showKeyPop(show: false)
      keyMenuShowingKeyboardButton?.showKeyMenu(show: true)

      dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC))),
        dispatch_get_main_queue()) { [weak self] in
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

  private func defaultInit() {
    keyboardLayout = CustomKeyboardLayout()
    keyboardLayoutStateDidChange(oldState: nil, newState: keyboardLayoutState)
  }

  // MARK: Layout
  public override func layoutSubviews() {
    super.layoutSubviews()

    getCurrentKeyboardLayout().frame = CGRect(
      x: 0,
      y: 0,
      width: frame.size.width,
      height: frame.size.height)
  }

  // MARK: KeyboardLayout
  public func getKeyboardLayout(ofState state: CustomKeyboardLayoutState) -> KeyboardLayout {
    switch state {
    case .Letters(let shiftState):
      switch shiftState {
      case .Once:
        return keyboardLayout.uppercase
      case .On:
        return keyboardLayout.uppercaseToggled
      case .Off:
        return keyboardLayout.lowercase
      }
    case .Numbers:
      return keyboardLayout.numbers
    case .Symbols:
      return keyboardLayout.symbols
    }
  }

  public func getCurrentKeyboardLayout() -> KeyboardLayout {
    return getKeyboardLayout(ofState: keyboardLayoutState)
  }

  public func enumerateKeyboardLayouts(enumerate: (KeyboardLayout) -> Void) {
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

  public func keyboardLayoutStateDidChange(oldState oldState: CustomKeyboardLayoutState?, newState: CustomKeyboardLayoutState) {
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
  }

  public func reload() {
    // Remove current
    let currentLayout = getCurrentKeyboardLayout()
    currentLayout.delegate = nil
    currentLayout.removeFromSuperview()
    // Reload layout
    keyboardLayout = CustomKeyboardLayout()
    keyboardLayoutStateDidChange(oldState: nil, newState: keyboardLayoutState)
  }

  // MARK: Capitalize
  public func capitalize() {
    keyboardLayoutState = .Letters(shiftState: .Once)
  }

  // MARK: Backspace Auto Delete
  private func startBackspaceAutoDeleteModeTimer() {
    backspaceAutoDeleteModeTimer = NSTimer.scheduledTimerWithTimeInterval(
      backspaceAutoDeleteModeInterval,
      target: self,
      selector: #selector(CustomKeyboard.startBackspaceAutoDeleteMode),
      userInfo: nil,
      repeats: false)
  }

  private func startBackspaceDeleteTimer() {
    backspaceDeleteTimer = NSTimer.scheduledTimerWithTimeInterval(
      backspaceDeleteInterval,
      target: self,
      selector: #selector(CustomKeyboard.autoDelete),
      userInfo: nil,
      repeats: true)
  }

  private func invalidateBackspaceAutoDeleteModeTimer() {
    backspaceAutoDeleteModeTimer?.invalidate()
    backspaceAutoDeleteModeTimer = nil
  }

  private func invalidateBackspaceDeleteTimer() {
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
  private func startShiftToggleTimer() {
    shiftToggleTimer = NSTimer.scheduledTimerWithTimeInterval(
      shiftToggleInterval,
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
  private func startKeyMenuOpenTimer(forKeyboardButton keyboardButton: KeyboardButton) {
    keyMenuOpenTimer = NSTimer.scheduledTimerWithTimeInterval(
      keyMenuOpenTimeInterval,
      target: self,
      selector: #selector(CustomKeyboard.openKeyMenu(_:)),
      userInfo: keyboardButton,
      repeats: false)
  }

  private func invalidateKeyMenuOpenTimer() {
    keyMenuOpenTimer?.invalidate()
    keyMenuOpenTimer = nil
  }

  public func openKeyMenu(timer: NSTimer) {
    if let userInfo = timer.userInfo, keyboardButton = userInfo as? KeyboardButton {
      keyMenuShowingKeyboardButton = keyboardButton
    }
  }

  // MARK: KeyboardLayoutDelegate
  public func keyboardLayout(keyboardLayout: KeyboardLayout, didKeyPressStart keyboardButton: KeyboardButton) {
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

  public func keyboardLayout(keyboardLayout: KeyboardLayout, didKeyPressEnd keyboardButton: KeyboardButton) {
    delegate?.customKeyboard?(self, keyboardButtonPressed: keyboardButton)

    // If keyboard key is pressed notify no questions asked
    if case KeyboardButtonType.Key(let text) = keyboardButton.type {
      delegate?.customKeyboard?(self, keyButtonPressed: text)

      // If shift state was CustomKeyboardShiftState.Once then make keyboard layout lowercase
      if case CustomKeyboardLayoutState.Letters(let shiftState) = keyboardLayoutState where shiftState == CustomKeyboardShiftState.Once {
        keyboardLayoutState = CustomKeyboardLayoutState.Letters(shiftState: .Off)
        return
      }
    }

    // Chcek special keyboard buttons
    if let keyId = keyboardButton.identifier, identifier = CustomKeyboardIdentifier(rawValue: keyId) {
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
        keyboardLayoutState = .Letters(shiftState: .Off)
      case .Numbers:
        keyboardLayoutState = .Numbers
      case .Symbols:
        keyboardLayoutState = .Symbols

      // Update shift state
      case .Shift:
        if shiftToggleTimer == nil {
          keyboardLayoutState = .Letters(shiftState: .Once)
          startShiftToggleTimer()
        } else {
          keyboardLayoutState = .Letters(shiftState: .On)
          invalidateShiftToggleTimer()
        }
      case .ShiftToggledOnce:
        if shiftToggleTimer == nil {
          keyboardLayoutState = .Letters(shiftState: .Off)
          startShiftToggleTimer()
        } else {
          keyboardLayoutState = .Letters(shiftState: .On)
          invalidateShiftToggleTimer()
        }
      case .ShiftToggled:
        if shiftToggleTimer == nil {
          keyboardLayoutState = .Letters(shiftState: .Off)
        }
      }
    }
  }

  public func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesBegin touches: Set<UITouch>) {
    // KeyMenu
    if let menu = keyMenuShowingKeyboardButton?.keyMenu, touch = touches.first {
      menu.updateSelection(touchLocation: touch.locationInView(self), inView: self)
    }
  }

  public func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesMove touches: Set<UITouch>) {
    // KeyMenu
    if let menu = keyMenuShowingKeyboardButton?.keyMenu, touch = touches.first {
      menu.updateSelection(touchLocation: touch.locationInView(self), inView: self)
    }
  }

  public func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesEnd touches: Set<UITouch>?)  {
    invalidateBackspaceAutoDeleteModeTimer()
    invalidateBackspaceDeleteTimer()
    invalidateKeyMenuOpenTimer()

    // KeyMenu
    if let menu = keyMenuShowingKeyboardButton?.keyMenu, touch = touches?.first {
      menu.updateSelection(touchLocation: touch.locationInView(self), inView: self)
      // select item
      if menu.selectedIndex >= 0 {
        if let item = menu.items[safe: menu.selectedIndex] {
          item.action?(keyMenuItem: item)
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

  public func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesCancel touches: Set<UITouch>?) {
    invalidateBackspaceAutoDeleteModeTimer()
    invalidateBackspaceDeleteTimer()
    invalidateKeyMenuOpenTimer()

    // KeyMenu
    if let menu = keyMenuShowingKeyboardButton?.keyMenu, touch = touches?.first {
      menu.updateSelection(touchLocation: touch.locationInView(self), inView: self)
      // select item
      if menu.selectedIndex >= 0 {
        if let item = menu.items[safe: menu.selectedIndex] {
          item.action?(keyMenuItem: item)
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
