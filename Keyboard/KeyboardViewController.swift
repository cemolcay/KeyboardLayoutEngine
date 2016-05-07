//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

let layoutStyle = KeyboardLayoutStyle(topPadding: 5, bottomPadding: 5, rowPadding: 10, backgroundColor: UIColor.grayColor())
let rowStyle = KeyboardRowStyle(leadingPadding: 5, trailingPadding: 5, buttonsPadding: 10)
let shiftRowStyle = KeyboardRowStyle(leadingPadding: 10, trailingPadding: 10, buttonsPadding: 10)
let defaultButtonStyle = KeyboardButtonStyle()
let darkButtonStyle = KeyboardButtonStyle(backgroundColor: UIColor.darkGrayColor())
let capitalLayout = KeyboardLayout(
  rows: [
    KeyboardRow(
      characters: [
        KeyboardButton(text: "Q", style: defaultButtonStyle),
        KeyboardButton(text: "W", style: defaultButtonStyle),
        KeyboardButton(text: "E", style: defaultButtonStyle),
        KeyboardButton(text: "R", style: defaultButtonStyle),
        KeyboardButton(text: "T", style: defaultButtonStyle),
        KeyboardButton(text: "Y", style: defaultButtonStyle),
        KeyboardButton(text: "U", style: defaultButtonStyle),
        KeyboardButton(text: "I", style: defaultButtonStyle),
        KeyboardButton(text: "O", style: defaultButtonStyle),
        KeyboardButton(text: "P", style: defaultButtonStyle),
      ],
      style: rowStyle
    ),
    KeyboardRow(
      characters: [
        KeyboardButton(text: "A", style: defaultButtonStyle),
        KeyboardButton(text: "S", style: defaultButtonStyle),
        KeyboardButton(text: "D", style: defaultButtonStyle),
        KeyboardButton(text: "F", style: defaultButtonStyle),
        KeyboardButton(text: "G", style: defaultButtonStyle),
        KeyboardButton(text: "H", style: defaultButtonStyle),
        KeyboardButton(text: "J", style: defaultButtonStyle),
        KeyboardButton(text: "K", style: defaultButtonStyle),
        KeyboardButton(text: "L", style: defaultButtonStyle),
      ],
      style: rowStyle
    ),
    KeyboardRow(
      characters: [
        KeyboardButton(imageNamed: "shift", style: defaultButtonStyle, width: 30),
        KeyboardRow(
          characters: [
            KeyboardButton(text: "Z", style: defaultButtonStyle),
            KeyboardButton(text: "X", style: defaultButtonStyle),
            KeyboardButton(text: "C", style: defaultButtonStyle),
            KeyboardButton(text: "V", style: defaultButtonStyle),
            KeyboardButton(text: "B", style: defaultButtonStyle),
            KeyboardButton(text: "N", style: defaultButtonStyle),
            KeyboardButton(text: "M", style: defaultButtonStyle),
          ],
          style: shiftRowStyle
        ),
        KeyboardButton(imageNamed: "backspace", style: darkButtonStyle, width: 30),
      ],
      style: rowStyle
    ),
    KeyboardRow(
      characters: [
        KeyboardButton(text: "123", style: darkButtonStyle, width: 30),
        KeyboardButton(imageNamed: "globe", style: darkButtonStyle, width: 30),
        KeyboardButton(text: "space", style: defaultButtonStyle),
        KeyboardButton(text: "return", style: darkButtonStyle, width: 40),
      ],
      style: rowStyle
    ),
  ],
  style: layoutStyle
)

class KeyboardViewController: UIInputViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    capitalLayout.apply(onView: view)
  }

  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    super.didRotateFromInterfaceOrientation(fromInterfaceOrientation)
  }
}
