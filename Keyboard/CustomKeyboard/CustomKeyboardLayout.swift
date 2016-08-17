//
//  CustomKeyboardLayout.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 11/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

// MARK: - Layout Style
public var CustomKeyboardLayoutStyle = KeyboardLayoutStyle()

// MARK: - Row Style
public var CustomKeyboardRowStyle = KeyboardRowStyle()
public var CustomKeyboardFirstRowStyle = KeyboardRowStyle(topPadding: 10, topPaddingLandscape: 6)

public var CustomKeyboardSecondRowStyle = KeyboardRowStyle(
  leadingPadding: 22,
  leadingPaddingLandscape: 30,
  trailingPadding: 22,
  trailingPaddingLandscape: 30)

public var CustomKeyboardThirdRowStyle = KeyboardRowStyle(
  bottomPadding: 5,
  bottomPaddingLandscape: 4,
  buttonsPadding: 15)

public var CustomKeyboardChildRowStyle = KeyboardRowStyle(
  leadingPadding: 0,
  trailingPadding: 0)

public var CustomKeyboardFourthRowStyle = KeyboardRowStyle(
  topPadding: 5,
  topPaddingLandscape: 4,
  bottomPadding: 4,
  bottomPaddingLandscape: 4)

// MARK: - Button Style
public var CustomKeyboardKeyButtonStyle = KeyboardButtonStyle(keyPopType: .normal)
public var CustomKeyboardLeftKeyButtonStyle = KeyboardButtonStyle(keyPopType: .left)
public var CustomKeyboardRightKeyButtonStyle = KeyboardButtonStyle(keyPopType: .right)

public var CustomKeyboardLowercaseKeyButtonStyle = KeyboardButtonStyle(textOffsetY: -2, keyPopType: .normal)
public var CustomKeyboardLowercaseLeftKeyButtonStyle = KeyboardButtonStyle(textOffsetY: -2, keyPopType: .left)
public var CustomKeyboardLowercaseRightKeyButtonStyle = KeyboardButtonStyle(textOffsetY: -2, keyPopType: .right)

public var CustomKeyboardSpaceButtonStyle = KeyboardButtonStyle(font: UIFont.systemFont(ofSize: 15))
public var CustomKeyboardBackspaceButtonStyle = KeyboardButtonStyle(
  backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
  imageSize: 20)

public var CustomKeyboardShiftButtonStyle = KeyboardButtonStyle(
  backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
  imageSize: 20)

public var CustomKeyboardGlobeButtonStyle = KeyboardButtonStyle(
  backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
  imageSize: 20)

public var CustomKeyboardReturnButtonStyle = KeyboardButtonStyle(
  backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
  font: UIFont.systemFont(ofSize: 15))

public var CustomKeyboardNumbersButtonStyle = KeyboardButtonStyle(
  backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
  font: UIFont.systemFont(ofSize: 15))

// MARK: - Identifier
public enum CustomKeyboardIdentifier: String {
  case Space = "Space"
  case Backspace = "Backspace"
  case Globe = "Globe"
  case Return = "Return"
  case Numbers = "Numbers"
  case Letters = "Letters"
  case Symbols = "Symbols"
  case ShiftOff = "ShiftOff"
  case ShiftOn = "ShiftOn"
  case ShiftOnce = "ShiftOnce"
}

// MARK: - CustomKeyboardLayout
open class CustomKeyboardLayout {
  open var uppercase: KeyboardLayout
  open var uppercaseToggled: KeyboardLayout
  open var lowercase: KeyboardLayout
  open var numbers: KeyboardLayout
  open var symbols: KeyboardLayout

  public init() {
    uppercase = KeyboardLayout(
      style: CustomKeyboardLayoutStyle,
      rows: [
        KeyboardRow(
          style: CustomKeyboardFirstRowStyle,
          characters: [
            KeyboardButton(type: .key("Q"), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .key("W"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("E"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("R"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("T"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("Y"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("U"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("I"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("O"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("P"), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardSecondRowStyle,
          characters: [
            KeyboardButton(type: .key("A"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("S"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("D"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("F"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("G"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("H"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("J"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("K"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("L"), style: CustomKeyboardKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardThirdRowStyle,
          characters: [
            KeyboardButton(
              type: .image(UIImage(
                named: "ShiftOnce",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardShiftButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.ShiftOnce.rawValue),
            KeyboardRow(
              style: CustomKeyboardChildRowStyle,
              characters: [
                KeyboardButton(type: .key("Z"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("X"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("C"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("V"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("B"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("N"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("M"), style: CustomKeyboardKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .image(UIImage(
                named: "Backspace",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardBackspaceButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardFourthRowStyle,
          characters: [
            KeyboardButton(
              type: .text("123"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardButton(
              type: .image(UIImage(
                named: "Globe",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardGlobeButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .text("space"),
              style: CustomKeyboardSpaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .text("return"),
              style: CustomKeyboardReturnButtonStyle,
              width: .relative(percent: 0.18),
              identifier: CustomKeyboardIdentifier.Return.rawValue),
          ]
        ),
      ]
    )

    uppercaseToggled = KeyboardLayout(
      style: CustomKeyboardLayoutStyle,
      rows: [
        KeyboardRow(
          style: CustomKeyboardFirstRowStyle,
          characters: [
            KeyboardButton(type: .key("Q"), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .key("W"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("E"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("R"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("T"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("Y"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("U"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("I"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("O"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("P"), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardSecondRowStyle,
          characters: [
            KeyboardButton(type: .key("A"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("S"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("D"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("F"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("G"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("H"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("J"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("K"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("L"), style: CustomKeyboardKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardThirdRowStyle,
          characters: [
            KeyboardButton(
              type: .image(UIImage(
                named: "ShiftOn",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardShiftButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.ShiftOn.rawValue),
            KeyboardRow(
              style: CustomKeyboardChildRowStyle,
              characters: [
                KeyboardButton(type: .key("Z"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("X"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("C"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("V"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("B"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("N"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("M"), style: CustomKeyboardKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .image(UIImage(
                named: "Backspace",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardBackspaceButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardFourthRowStyle,
          characters: [
            KeyboardButton(
              type: .text("123"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardButton(
              type: .image(UIImage(
                named: "Globe",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardGlobeButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .text("space"),
              style: CustomKeyboardSpaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .text("return"),
              style: CustomKeyboardReturnButtonStyle,
              width: .relative(percent: 0.18),
              identifier: CustomKeyboardIdentifier.Return.rawValue),
          ]
        ),
      ]
    )

    lowercase = KeyboardLayout(
      style: CustomKeyboardLayoutStyle,
      rows: [
        KeyboardRow(
          style: CustomKeyboardFirstRowStyle,
          characters: [
            KeyboardButton(type: .key("q"), style: CustomKeyboardLowercaseLeftKeyButtonStyle),
            KeyboardButton(type: .key("w"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("e"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("r"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("t"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("y"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("u"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("i"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("o"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("p"), style: CustomKeyboardLowercaseRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardSecondRowStyle,
          characters: [
            KeyboardButton(type: .key("a"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("s"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("d"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("f"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("g"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("h"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("j"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("k"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .key("l"), style: CustomKeyboardLowercaseKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardThirdRowStyle,
          characters: [
            KeyboardButton(
              type: .image(UIImage(
                named: "ShiftOff",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardShiftButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.ShiftOff.rawValue),
            KeyboardRow(
              style: CustomKeyboardChildRowStyle,
              characters: [
                KeyboardButton(type: .key("z"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .key("x"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .key("c"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .key("v"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .key("b"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .key("n"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .key("m"), style: CustomKeyboardLowercaseKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .image(UIImage(
                named: "Backspace",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardBackspaceButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardFourthRowStyle,
          characters: [
            KeyboardButton(
              type: .text("123"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardButton(
              type: .image(UIImage(
                named: "Globe",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardGlobeButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .text("space"),
              style: CustomKeyboardSpaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .text("return"),
              style: CustomKeyboardReturnButtonStyle,
              width: .relative(percent: 0.18),
              identifier: CustomKeyboardIdentifier.Return.rawValue),
          ]
        ),
      ]
    )

    numbers = KeyboardLayout(
      style: CustomKeyboardLayoutStyle,
      rows: [
        KeyboardRow(
          style: CustomKeyboardFirstRowStyle,
          characters: [
            KeyboardButton(type: .key("1"), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .key("2"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("3"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("4"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("5"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("6"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("7"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("8"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("9"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("0"), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardRowStyle,
          characters: [
            KeyboardButton(type: .key("-"), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .key("/"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key(":"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key(";"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("("), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key(")"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("$"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("&"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("@"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("\""), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardThirdRowStyle,
          characters: [
            KeyboardButton(
              type: .text("#+="),
              style: CustomKeyboardNumbersButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Symbols.rawValue),
            KeyboardRow(
              style: CustomKeyboardChildRowStyle,
              characters: [
                KeyboardButton(type: .key("."), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key(","), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("?"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("!"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("'"), style: CustomKeyboardKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .image(UIImage(
                named: "Backspace",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardBackspaceButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardFourthRowStyle,
          characters: [
            KeyboardButton(
              type: .text("ABC"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Letters.rawValue),
            KeyboardButton(
              type: .image(UIImage(
                named: "Globe",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardGlobeButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .text("space"),
              style: CustomKeyboardSpaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .text("return"),
              style: CustomKeyboardReturnButtonStyle,
              width: .relative(percent: 0.18),
              identifier: CustomKeyboardIdentifier.Return.rawValue),
          ]
        ),
      ]
    )

    symbols = KeyboardLayout(
      style: CustomKeyboardLayoutStyle,
      rows: [
        KeyboardRow(
          style: CustomKeyboardFirstRowStyle,
          characters: [
            KeyboardButton(type: .key("["), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .key("]"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("{"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("}"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("#"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("%"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("^"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("*"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("+"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("="), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardRowStyle,
          characters: [
            KeyboardButton(type: .key("_"), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .key("\\"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("|"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("~"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("<"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key(">"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("€"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("£"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("¥"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .key("•"), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardThirdRowStyle,
          characters: [
            KeyboardButton(
              type: .text("123"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardRow(
              style: CustomKeyboardChildRowStyle,
              characters: [
                KeyboardButton(type: .key("."), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key(","), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("?"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("!"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .key("'"), style: CustomKeyboardKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .image(UIImage(
                named: "Backspace",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardBackspaceButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardFourthRowStyle,
          characters: [
            KeyboardButton(
              type: .text("ABC"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Letters.rawValue),
            KeyboardButton(
              type: .image(UIImage(
                named: "Globe",
                in: Bundle(for: CustomKeyboard.self),
                compatibleWith: nil)),
              style: CustomKeyboardGlobeButtonStyle,
              width: .relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .text("space"),
              style: CustomKeyboardSpaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .text("return"),
              style: CustomKeyboardReturnButtonStyle,
              width: .relative(percent: 0.18),
              identifier: CustomKeyboardIdentifier.Return.rawValue),
          ]
        ),
      ]
    )
  }
}
