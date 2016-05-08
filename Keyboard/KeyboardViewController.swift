//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

let layoutStyle = KeyboardLayoutStyle(topPadding: 10, bottomPadding: 5, rowPadding: 13, backgroundColor: UIColor(red: 208.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1))
let rowStyle = KeyboardRowStyle(leadingPadding: 5, trailingPadding: 5, buttonsPadding: 6)
let secondRowStyle = KeyboardRowStyle(leadingPadding: 20, trailingPadding: 20, buttonsPadding: 6)
let shiftRowStyle = KeyboardRowStyle(leadingPadding: 10, trailingPadding: 10, buttonsPadding: 6)
let defaultButtonStyle = KeyboardButtonStyle(showsPopup: true)
let spaceButtonStyle = KeyboardButtonStyle(font: UIFont.systemFontOfSize(15), showsPopup: false)
let globeButtonStyle = KeyboardButtonStyle(backgroundColor: UIColor(red: 180.0/255.0, green: 188.0/255.0, blue: 201.0/255.0, alpha: 1), imageSize: 20)
let darkImageButtonStyle = KeyboardButtonStyle(backgroundColor: UIColor(red: 180.0/255.0, green: 188.0/255.0, blue: 201.0/255.0, alpha: 1), imageSize: 18)
let darkButtonStyle = KeyboardButtonStyle(backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 201.0/255.0, alpha: 1))
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
        KeyboardButton(type: .Image(UIImage(named: "shift")), style: darkImageButtonStyle, width: .Relative(percent: 0.13), identifier: "shift"),
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
        KeyboardButton(type: .Image(UIImage(named: "backspace")), style: darkImageButtonStyle, width: .Relative(percent: 0.13), identifier: "backspace"),
      ],
      style: rowStyle
    ),
    KeyboardRow(
      characters: [
        KeyboardButton(type: .Text("123"), style: nunmbersButtonStyle, width: .Relative(percent: 0.13)),
        KeyboardButton(type: .Image(UIImage(named: "globe")), style: globeButtonStyle, width: .Static(width: 40), identifier: "globe"),
        KeyboardButton(type: .Key("space"), style: spaceButtonStyle, identifier: "space"),
        KeyboardButton(type: .Key("return"), style: darkButtonStyle, width: .Relative(percent: 0.2), identifier: "return"),
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
        if identifier == "globe" {
          advanceToNextInputMode()
        } else if identifier == "space" {
          textDocumentProxy.insertText(" ")
        } else if identifier == "backspace" {
          textDocumentProxy.deleteBackward()
        } else if identifier == "shift" {
          shiftPressed()
        }
      }
      switch keyboardButton.type {
      case .Key(let key):
        textDocumentProxy.insertText(key)
      default:
        return
      }
    }
  }

  func shiftPressed() {
    print("shift pressed")
  }
}
