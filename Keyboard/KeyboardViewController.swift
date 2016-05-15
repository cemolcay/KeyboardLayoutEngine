//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController, CustomKeyboardDelegate {
  var customKeyboard: CustomKeyboard!

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    customKeyboard = CustomKeyboard()
    customKeyboard.delegate = self
    view.addSubview(customKeyboard)

    // This is how you add extra buttons to layouts for customising CustomKeyboard without even subclass it!
    let customButton = KeyboardButton(
      type: .Text("🕶"),
      style: CustomKeyboardKeyButtonStyle,
      width: .Static(width: 40),
      identifier: "customButton")
    customKeyboard.numbersLayout.addKeyboardButton(
      keyboardButton: customButton,
      rowAtIndex: 3,
      buttonIndex: 2)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    customKeyboard?.frame = view.frame
  }

  // MARK: CustomKeyboardDelegate
  func customKeyboardKeyButtonPressed(customKeyboard: CustomKeyboard, key: String) {
    if customKeyboard == self.customKeyboard {
      textDocumentProxy.insertText(key)
    }
  }

  func customKeyboardSpaceButtonPressed(customKeyboard: CustomKeyboard) {
    if customKeyboard == self.customKeyboard {
      textDocumentProxy.insertText(" ")
    }
  }

  func customKeyboardBackspaceButtonPressed(customKeyboard: CustomKeyboard) {
    if customKeyboard == self.customKeyboard {
      textDocumentProxy.deleteBackward()
    }
  }

  func customKeyboardReturnButtonPressed(customKeyboard: CustomKeyboard) {
    if customKeyboard == self.customKeyboard {
      textDocumentProxy.insertText("\n")
    }
  }

  func customKeyboardGlobeButtonPressed(customKeyboard: CustomKeyboard) {
    if customKeyboard == self.customKeyboard {
      advanceToNextInputMode()
    }
  }

  func customKeyboardButtonPressed(customKeyboard: CustomKeyboard, keyboardButton: KeyboardButton) {
    if customKeyboard == self.customKeyboard {
      if keyboardButton.identifier == "customButton" {
        print("custom button pressed")
      }
    }
  }
}
