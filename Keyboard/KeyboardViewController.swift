//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

let layoutStyle = KeyboardLayoutStyle(topPadding: 5, bottomPadding: 5, rowPadding: 10, backgroundColor: UIColor(red: 208.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1))
let rowStyle = KeyboardRowStyle(leadingPadding: 5, trailingPadding: 5, buttonsPadding: 6)
let secondRowStyle = KeyboardRowStyle(leadingPadding: 20, trailingPadding: 20, buttonsPadding: 6)
let shiftRowStyle = KeyboardRowStyle(leadingPadding: 10, trailingPadding: 10, buttonsPadding: 6)
let defaultButtonStyle = KeyboardButtonStyle()
let spaceButtonStyle = KeyboardButtonStyle(font: UIFont.systemFontOfSize(15))
let globeButtonStyle = KeyboardButtonStyle(backgroundColor: UIColor(red: 180.0/255.0, green: 188.0/255.0, blue: 201.0/255.0, alpha: 1), imageSize: 20)
let shiftButtonStyle = KeyboardButtonStyle(imageSize: 18)
let backspaceButtonStyle = KeyboardButtonStyle(backgroundColor: UIColor(red: 180.0/255.0, green: 188.0/255.0, blue: 201.0/255.0, alpha: 1), imageSize: 18)
let darkButtonStyle = KeyboardButtonStyle(backgroundColor: UIColor(red: 180.0/255.0, green: 188.0/255.0, blue: 201.0/255.0, alpha: 1))
let nunmbersButtonStyle = KeyboardButtonStyle(backgroundColor: UIColor(red: 180.0/255.0, green: 188.0/255.0, blue: 201.0/255.0, alpha: 1), font: UIFont.systemFontOfSize(15))
let capitalLayout = KeyboardLayout(
  rows: [
    KeyboardRow(
      characters: [
        KeyboardButton(type: .Key("Q"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("W"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("E"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("R"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("T"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("Y"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("U"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("I"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("O"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("P"), style: defaultButtonStyle),
      ],
      style: rowStyle
    ),
    KeyboardRow(
      characters: [
        KeyboardButton(type: .Key("A"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("S"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("D"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("F"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("G"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("H"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("J"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("K"), style: defaultButtonStyle),
        KeyboardButton(type: .Key("L"), style: defaultButtonStyle),
      ],
      style: secondRowStyle
    ),
    KeyboardRow(
      characters: [
        KeyboardButton(type: .Image(UIImage(named: "shift")), style: shiftButtonStyle, width: .Relative(percent: 0.13), identifier: "shift"),
        KeyboardRow(
          characters: [
            KeyboardButton(type: .Key("Z"), style: defaultButtonStyle),
            KeyboardButton(type: .Key("X"), style: defaultButtonStyle),
            KeyboardButton(type: .Key("C"), style: defaultButtonStyle),
            KeyboardButton(type: .Key("V"), style: defaultButtonStyle),
            KeyboardButton(type: .Key("B"), style: defaultButtonStyle),
            KeyboardButton(type: .Key("N"), style: defaultButtonStyle),
            KeyboardButton(type: .Key("M"), style: defaultButtonStyle),
          ],
          style: shiftRowStyle
        ),
        KeyboardButton(type: .Image(UIImage(named: "backspace")), style: backspaceButtonStyle, width: .Relative(percent: 0.13), identifier: "backspace"),
      ],
      style: rowStyle
    ),
    KeyboardRow(
      characters: [
        KeyboardButton(type: .Text("123"), style: nunmbersButtonStyle, width: .Relative(percent: 0.13)),
        KeyboardButton(type: .Image(UIImage(named: "globe")), style: globeButtonStyle, width: .Static(width: 40), identifier: "globe"),
        KeyboardButton(type: .Key("space"), style: spaceButtonStyle, identifier: "space"),
        KeyboardButton(type: .Key("return"), style: spaceButtonStyle, width: .Relative(percent: 0.2), identifier: "return"),
      ],
      style: rowStyle
    ),
  ],
  style: layoutStyle
)

class KeyboardViewController: UIInputViewController, KeyboardLayuotDelegate {

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(capitalLayout)
    capitalLayout.delegate = self
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    capitalLayout.setNeedsLayout()
  }

  func keyboardLayoutDidPressButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton) {
    if keyboardLayout == capitalLayout {
      if let identifier = keyboardButton.identifier {
        print("\(identifier) pressed")
        return
      }
      switch keyboardButton.type {
      case .Key(let key):
        print("\(key) pressed")
      default:
        return
      }
    }
  }
}
