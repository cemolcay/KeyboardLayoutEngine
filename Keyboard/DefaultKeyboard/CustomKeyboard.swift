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
  public var keyButtonPopupContainer: UIView?

  public var shiftToggleInterval: NSTimeInterval = 0.5
  private var shiftToggleTimer: NSTimer?
  private var shiftCanBeToggled: Bool = false
  private var uppercaseOnce: Bool = true

  public var backspaceDeleteInterval: NSTimeInterval = 0.1
  public var backspaceAutoDeleteModeInterval: NSTimeInterval = 0.5
  private var backspaceDeleteTimer: NSTimer?
  private var backspaceAutoDeleteModeTimer: NSTimer?

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
          self?.currentLayout.typingEnabled = self!.keyMenuShowingKeyboardButton == nil && self!.keyMenuLocked == false
      }
    }
  }

  public var uppercaseToggledLayout: KeyboardLayout! {
    didSet {
      layoutDidChange(
        oldLayout: oldValue,
        newLayout: uppercaseToggledLayout)
    }
  }

  public var uppercaseLayout: KeyboardLayout! {
    didSet {
      layoutDidChange(
        oldLayout: oldValue,
        newLayout: uppercaseLayout)
    }
  }

  public var lowercaseLayout: KeyboardLayout! {
    didSet {
      layoutDidChange(
        oldLayout: oldValue,
        newLayout: lowercaseLayout)
    }
  }

  public var numbersLayout: KeyboardLayout! {
    didSet {
      layoutDidChange(
        oldLayout: oldValue,
        newLayout: numbersLayout)
    }
  }

  public var symbolsLayout: KeyboardLayout! {
    didSet {
      layoutDidChange(
        oldLayout: oldValue,
        newLayout: symbolsLayout)
    }
  }

  private(set) var currentLayout: KeyboardLayout! {
    didSet {
      oldValue?.delegate = nil
      oldValue?.removeFromSuperview()
      currentLayout.delegate = self
      addSubview(currentLayout)
    }
  }

  public weak var delegate: CustomKeyboardDelegate?

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
    reload()
    currentLayout = uppercaseLayout
    addSubview(currentLayout)
  }

  // MARK: Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
    currentLayout?.frame = CGRect(
      x: 0,
      y: 0,
      width: frame.size.width,
      height: frame.size.height)
  }

  private func layoutDidChange(oldLayout oldLayout: KeyboardLayout?, newLayout: KeyboardLayout) {
    guard currentLayout != nil && oldLayout != nil else { return }
    if currentLayout == oldLayout {
      currentLayout = newLayout
    }
  }

  // MARK: Reload
  public func reload() {
    uppercaseToggledLayout = CustomKeyboardLayout.UppercaseToggled.keyboardLayout
    uppercaseLayout = CustomKeyboardLayout.Uppercase.keyboardLayout
    lowercaseLayout = CustomKeyboardLayout.Lowercase.keyboardLayout
    numbersLayout = CustomKeyboardLayout.Numbers.keyboardLayout
    symbolsLayout = CustomKeyboardLayout.Symbols.keyboardLayout
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
    shiftCanBeToggled = true
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
    shiftCanBeToggled = false
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

    if keyboardLayout == currentLayout {
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
  }

  public func keyboardLayout(keyboardLayout: KeyboardLayout, didKeyPressEnd keyboardButton: KeyboardButton) {
    if keyboardLayout == currentLayout {
      delegate?.customKeyboard?(self, keyboardButtonPressed: keyboardButton)
      switch keyboardButton.type {
      case .Key(let key):
        delegate?.customKeyboard?(self, keyButtonPressed: key)
        if uppercaseOnce {
          uppercaseOnce = false
          currentLayout = lowercaseLayout
        }
      default:
        if let id = keyboardButton.identifier,
          let identifier = CustomKeyboardIdentifier(rawValue: id) {
          switch identifier {
          case .Numbers:
            currentLayout = numbersLayout
          case .Symbols:
            currentLayout = symbolsLayout
          case .Letters:
            currentLayout = uppercaseLayout
            uppercaseOnce = true
          case .Globe:
            delegate?.customKeyboardGlobeButtonPressed?(self)
          case .Return:
            delegate?.customKeyboardReturnButtonPressed?(self)
          case .Space:
            delegate?.customKeyboardSpaceButtonPressed?(self)
            uppercaseOnce = false
          case .Backspace:
            delegate?.customKeyboardBackspaceButtonPressed?(self)
            uppercaseOnce = false
          case .Shift:
            if shiftCanBeToggled {
              currentLayout = uppercaseToggledLayout
              uppercaseOnce = false
              invalidateShiftToggleTimer()
            } else {
              currentLayout = uppercaseLayout
              uppercaseOnce = true
              startShiftToggleTimer()
            }
          case .ShiftToggledOnce:
            if shiftCanBeToggled {
              currentLayout = uppercaseToggledLayout
              uppercaseOnce = false
              invalidateShiftToggleTimer()
            } else {
              uppercaseOnce = false
              currentLayout = lowercaseLayout
              startShiftToggleTimer()
            }
          case .ShiftToggled:
            currentLayout = lowercaseLayout
            uppercaseOnce = false
          }
        }
      }
    }
  }

  public func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesBegin touches: Set<UITouch>) {
    if let menu = keyMenuShowingKeyboardButton?.keyMenu, touch = touches.first {
      menu.updateSelection(touchLocation: touch.locationInView(self), inView: self)
    }
  }

  public func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesMove touches: Set<UITouch>) {
    if let menu = keyMenuShowingKeyboardButton?.keyMenu, touch = touches.first {
      menu.updateSelection(touchLocation: touch.locationInView(self), inView: self)
    }
  }

  public func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesEnd touches: Set<UITouch>?)  {
    invalidateBackspaceAutoDeleteModeTimer()
    invalidateBackspaceDeleteTimer()
    invalidateKeyMenuOpenTimer()

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
          currentLayout.typingEnabled = true
          return
        }
        keyMenuLocked = true
      }
    }
  }
}
