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
}

// MARK: - DefaultKeyboard
public class DefaultKeyboard: UIView, KeyboardLayoutDelegate {
  public weak var delegate: DefaultKeyboardDelegate?
  private var uppercaseOnce: Bool = true

  public var uppercaseToggledLayout: KeyboardLayout!
  public var uppercaseLayout: KeyboardLayout!
  public var lowercaseLayout: KeyboardLayout!
  public var numbersLayout: KeyboardLayout!
  public var symbolsLayout: KeyboardLayout!

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

  // MARK: KeyboardLayoutDelegate
  public func keyboardLayoutDidPressButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton) {
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
          case .ShiftToggled:
            currentLayout = lowercaseLayout
            uppercaseOnce = false
          case .ShiftToggledOnce:
            currentLayout = lowercaseLayout
            uppercaseOnce = false
          }
        }
        break
      }
    }
  }
}
