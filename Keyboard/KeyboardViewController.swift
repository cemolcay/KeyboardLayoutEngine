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
  var uppercase: KeyboardLayout!

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    defaultKeyboard = DefaultKeyboard()
    defaultKeyboard.delegate = self
    view.addSubview(defaultKeyboard)
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
}
