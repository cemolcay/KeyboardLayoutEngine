//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, DefaultKeyboardDelegate {
  var defaultKeyboard: DefaultKeyboard!

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    defaultKeyboard = DefaultKeyboard()
    defaultKeyboard.delegate = self
    view.addSubview(defaultKeyboard)

    // This is how you add extra buttons to layouts for customising DefaultKeyboard without even subclass it!
    let customButton = KeyboardButton(
      type: .Text("🕶"),
      style: DefaultKeyboardKeyButtonStyle,
      width: .Static(width: 40),
      identifier: "customButton")
    defaultKeyboard.numbersLayout.addKeyboardButton(
      keyboardButton: customButton,
      rowAtIndex: 3,
      buttonIndex: 2)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    defaultKeyboard?.frame = view.frame
  }

  // MARK: DefaultKeyboardDelegate
  func defaultKeyboardDidPressKeyButton(defaultKeyboard: DefaultKeyboard, key: String) {
    if defaultKeyboard == self.defaultKeyboard {
      textDocumentProxy.insertText(key)
    }
  }

  func defaultKeyboardDidPressSpaceButton(defaultKeyboard: DefaultKeyboard) {
    if defaultKeyboard == self.defaultKeyboard {
      textDocumentProxy.insertText(" ")
    }
  }

  func defaultKeyboardDidPressBackspaceButton(defaultKeyboard: DefaultKeyboard) {
    if defaultKeyboard == self.defaultKeyboard {
      textDocumentProxy.deleteBackward()
    }
  }

  func defaultKeyboardDidPressReturnButton(defaultKeyboard: DefaultKeyboard) {
    if defaultKeyboard == self.defaultKeyboard {
      textDocumentProxy.insertText("\n")
    }
  }

  func defaultKeyboardDidPressGlobeButton(defaultKeyboard: DefaultKeyboard) {
    if defaultKeyboard == self.defaultKeyboard {
      advanceToNextInputMode()
    }
  }

  func defaultKeyboardDidPressKeyboardButton(defaultKeyboard: DefaultKeyboard, keyboardButton: KeyboardButton) {
    if defaultKeyboard == self.defaultKeyboard {
      if keyboardButton.identifier == "customButton" {
        print("custom button pressed")
      }
    }
  }
}
