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
  optional func customKeyboardKeyButtonPressed(customKeyboard: CustomKeyboard, key: String)
  optional func customKeyboardSpaceButtonPressed(customKeyboard: CustomKeyboard)
  optional func customKeyboardBackspaceButtonPressed(customKeyboard: CustomKeyboard)
  optional func customKeyboardGlobeButtonPressed(customKeyboard: CustomKeyboard)
  optional func customKeyboardReturnButtonPressed(customKeyboard: CustomKeyboard)
  optional func customKeyboardButtonPressed(customKeyboard: CustomKeyboard, keyboardButton: KeyboardButton)
}

// MARK: - CustomKeyboard
public class CustomKeyboard: UIView, KeyboardLayoutDelegate {
  public var shiftToggleInterval: NSTimeInterval = 0.5
  private var shiftToggleTimer: NSTimer?
  private var shiftCanBeToggled: Bool = false
  private var uppercaseOnce: Bool = true

  public var backspaceDeleteInterval: NSTimeInterval = 0.1
  public var backspaceAutoDeleteModeInterval: NSTimeInterval = 0.5
  private var backspaceDeleteTimer: NSTimer?
  private var backspaceAutoDeleteModeTimer: NSTimer?

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

  private var lastLetterLayout: KeyboardLayout?
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

  public func invalidateShiftToggleTimer() {
    shiftToggleTimer?.invalidate()
    shiftToggleTimer = nil
    shiftCanBeToggled = false
  }

  // MARK: KeyboardLayoutDelegate
  public func keyboardLayoutDidPressButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton) {
    delegate?.customKeyboardButtonPressed?(self, keyboardButton: keyboardButton)
    invalidateBackspaceAutoDeleteModeTimer()
    invalidateBackspaceDeleteTimer()
    if keyboardLayout == currentLayout {
      switch keyboardButton.type {
      case .Key(let key):
        delegate?.customKeyboardKeyButtonPressed?(self, key: key)
        if uppercaseOnce {
          uppercaseOnce = false
          currentLayout = lowercaseLayout
        }
      default:
        if let id = keyboardButton.identifier,
          let identifier = CustomKeyboardIdentifier(rawValue: id) {
          switch identifier {
          case .Space:
            delegate?.customKeyboardSpaceButtonPressed?(self)
            uppercaseOnce = false
          case .Backspace:
            delegate?.customKeyboardBackspaceButtonPressed?(self)
            uppercaseOnce = false
          case .Globe:
            delegate?.customKeyboardGlobeButtonPressed?(self)
          case .Return:
            delegate?.customKeyboardReturnButtonPressed?(self)
          case .Letters:
            currentLayout = uppercaseLayout
            uppercaseOnce = true
          case .Numbers:
            currentLayout = numbersLayout
          case .Symbols:
            currentLayout = symbolsLayout
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
          case .ShiftToggled:
            currentLayout = lowercaseLayout
            uppercaseOnce = false
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
      if keyboardButton.identifier == CustomKeyboardIdentifier.Backspace.rawValue {
        startBackspaceAutoDeleteModeTimer()
      }
    }
  }
}
