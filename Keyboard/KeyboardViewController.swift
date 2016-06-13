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
    setupKeyboard()
  }

  private func setupKeyboard() {
    customKeyboard = CustomKeyboard()
    customKeyboard.delegate = self
    customKeyboard.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(customKeyboard)

    // Autolayout
    customKeyboard.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
    customKeyboard.rightAnchor.constraintEqualToAnchor(view.rightAnchor).active = true
    customKeyboard.topAnchor.constraintEqualToAnchor(view.topAnchor).active = true
    customKeyboard.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true

    // This is how you add extra buttons to layouts for customising CustomKeyboard without even subclass it!
    let customButton = KeyboardButton(
      type: .Text("🕶"),
      style: customKeyboard.keyboardStyle.keyButtonStyle,
      width: .Static(width: 40),
      identifier: "customButton")
    customKeyboard.keyboardLayout.symbols.addKeyboardButton(
      keyboardButton: customButton,
      rowAtIndex: 3,
      buttonIndex: 2)

    // This is how you add a menu 
    let globeButtons = [
      customKeyboard.keyboardLayout.uppercase.getKeyboardButton(atRowIndex: 3, buttonIndex: 1),
      customKeyboard.keyboardLayout.uppercaseToggled.getKeyboardButton(atRowIndex: 3, buttonIndex: 1),
      customKeyboard.keyboardLayout.lowercase.getKeyboardButton(atRowIndex: 3, buttonIndex: 1),
      customKeyboard.keyboardLayout.numbers.getKeyboardButton(atRowIndex: 3, buttonIndex: 1),
      customKeyboard.keyboardLayout.symbols.getKeyboardButton(atRowIndex: 3, buttonIndex: 1),
    ]

    let menuItemStyle =  KeyMenuItemStyle(
      separatorColor: UIColor(red: 210.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1),
      separatorWidth: 0.5)

    for globeButton in globeButtons {
      let menu = KeyMenu(
        items: [
          KeyMenuItem(title: "Switch Keyboard", style: menuItemStyle, action: { _ in self.advanceToNextInputMode() }),
          KeyMenuItem(title: "Settings", style: menuItemStyle, action: { _ in print("settings pressed") }),
          KeyMenuItem(title: "About Us", style: menuItemStyle, action: { _ in print("about pressed") }),
        ],
        style: KeyMenuStyle(itemSize: CGSize(width: 150, height: 40)),
        type: .Vertical)
      globeButton?.keyMenu = menu
    }
  }

  // MARK: CustomKeyboardDelegate
  func customKeyboard(customKeyboard: CustomKeyboard, keyboardButtonPressed keyboardButton: KeyboardButton) {
    if customKeyboard == self.customKeyboard {
      if keyboardButton.identifier == "customButton" {
        print("custom button pressed")
      }
    }
  }

  func customKeyboard(customKeyboard: CustomKeyboard, keyButtonPressed key: String) {
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
}
