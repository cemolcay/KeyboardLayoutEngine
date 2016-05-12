//
//  DefaultKeyboard.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 11/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

// MARK: - DefaultKeyboardDelegate
@objc public protocol DefaultKeyboardDelegate {
  optional func defaultKeyboardDidPressKeyButton(defaultKeyboard: DefaultKeyboard, key: String)
  optional func defaultKeyboardDidPressSpaceButton(defaultKeyboard: DefaultKeyboard)
  optional func defaultKeyboardDidPressBackspaceButton(defaultKeyboard: DefaultKeyboard)
  optional func defaultKeyboardDidPressGlobeButton(defaultKeyboard: DefaultKeyboard)
  optional func defaultKeyboardDidPressReturnButton(defaultKeyboard: DefaultKeyboard)
  optional func defaultKeyboardDidPressKeyboardButton(defaultKeyboard: DefaultKeyboard, keyboardButton: KeyboardButton)
}

// MARK: - DefaultKeyboard
public class DefaultKeyboard: UIView, KeyboardLayoutDelegate {
  public var uppercaseToggledLayout: KeyboardLayout!
  public var uppercaseLayout: KeyboardLayout!
  public var lowercaseLayout: KeyboardLayout!
  public var numbersLayout: KeyboardLayout!
  public var symbolsLayout: KeyboardLayout!

  public var shiftToggleInterval: NSTimeInterval = 0.5
  private var shiftToggleTimer: NSTimer?
  private var shiftCanBeToggled: Bool = false
  private var uppercaseOnce: Bool = true

  public var backspaceDeleteInterval: NSTimeInterval = 0.1
  public var backspaceAutoDeleteModeInterval: NSTimeInterval = 0.5
  private var backspaceDeleteTimer: NSTimer?
  private var backspaceAutoDeleteModeTimer: NSTimer?

  private var lastLetterLayout: KeyboardLayout?
  private(set) var currentLayout: KeyboardLayout! {
    didSet {
      oldValue?.delegate = nil
      oldValue?.removeFromSuperview()
      currentLayout.delegate = self
      addSubview(currentLayout)
    }
  }

  public override var frame: CGRect {
    didSet {
      currentLayout?.frame = frame
    }
  }

  public weak var delegate: DefaultKeyboardDelegate?

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
    uppercaseToggledLayout = DefaultKeyboardLayout.UppercaseToggled.keyboardLayout
    uppercaseLayout = DefaultKeyboardLayout.Uppercase.keyboardLayout
    lowercaseLayout = DefaultKeyboardLayout.Lowercase.keyboardLayout
    numbersLayout = DefaultKeyboardLayout.Numbers.keyboardLayout
    symbolsLayout = DefaultKeyboardLayout.Symbols.keyboardLayout
    
    currentLayout = uppercaseLayout
    addSubview(currentLayout)
  }

  // MARK: Backspace Auto Delete
  private func startBackspaceAutoDeleteModeTimer() {
    backspaceAutoDeleteModeTimer = NSTimer.scheduledTimerWithTimeInterval(
      backspaceAutoDeleteModeInterval,
      target: self,
      selector: #selector(DefaultKeyboard.startBackspaceAutoDeleteMode),
      userInfo: nil,
      repeats: false)
  }

  private func startBackspaceDeleteTimer() {
    backspaceDeleteTimer = NSTimer.scheduledTimerWithTimeInterval(
      backspaceDeleteInterval,
      target: self,
      selector: #selector(DefaultKeyboard.autoDelete),
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
    delegate?.defaultKeyboardDidPressBackspaceButton?(self)
  }

  // MARK: Shift Toggle
  private func startShiftToggleTimer() {
    shiftCanBeToggled = true
    shiftToggleTimer = NSTimer.scheduledTimerWithTimeInterval(
      shiftToggleInterval,
      target: self,
      selector: #selector(DefaultKeyboard.invalidateShiftToggleTimer),
      userInfo: nil,
      repeats: false)
  }

  public func invalidateShiftToggleTimer() {
    shiftToggleTimer?.invalidate()
    shiftToggleTimer = nil
    shiftCanBeToggled = false
  }

  // MARK: KeyboardLayoutDelegate
  public func keyboardLayoutDidPressButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton) {
    delegate?.defaultKeyboardDidPressKeyboardButton?(self, keyboardButton: keyboardButton)
    invalidateBackspaceAutoDeleteModeTimer()
    invalidateBackspaceDeleteTimer()
    if keyboardLayout == currentLayout {
      switch keyboardButton.type {
      case .Key(let key):
        delegate?.defaultKeyboardDidPressKeyButton?(self, key: key)
        if uppercaseOnce {
          uppercaseOnce = false
          currentLayout = lowercaseLayout
        }
      default:
        if let id = keyboardButton.identifier,
          let identifier = DefaultKeyboardIdentifier(rawValue: id) {
          switch identifier {
          case .Space:
            delegate?.defaultKeyboardDidPressSpaceButton?(self)
            uppercaseOnce = false
          case .Backspace:
            delegate?.defaultKeyboardDidPressBackspaceButton?(self)
            uppercaseOnce = false
          case .Globe:
            delegate?.defaultKeyboardDidPressGlobeButton?(self)
          case .Return:
            delegate?.defaultKeyboardDidPressReturnButton?(self)
          case .Letters:
            currentLayout = uppercaseLayout
            uppercaseOnce = true
          case .Numbers:
            currentLayout = numbersLayout
          case .Symbols:
            currentLayout = symbolsLayout
          case .Shift:
            currentLayout = uppercaseLayout
            uppercaseOnce = true
            startShiftToggleTimer()
          case .ShiftToggled:
            currentLayout = lowercaseLayout
            uppercaseOnce = false
          case .ShiftToggledOnce:
            if shiftCanBeToggled {
              currentLayout = uppercaseToggledLayout
              uppercaseOnce = false
              invalidateShiftToggleTimer()
            } else {
              currentLayout = lowercaseLayout
              uppercaseOnce = false
            }
          }
        }
        break
      }
    }
  }

  public func keyboardLayoutDidStartPressingButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton) {
    invalidateBackspaceAutoDeleteModeTimer()
    invalidateBackspaceDeleteTimer()
    if keyboardLayout == currentLayout {
      if keyboardButton.identifier == DefaultKeyboardIdentifier.Backspace.rawValue {
        startBackspaceAutoDeleteModeTimer()
      }
    }
  }
}
