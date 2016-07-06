//
//  CustomKeyboardLayout.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 11/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

// MARK: - Layout Style
public var CustomKeyboardLayoutStyle = KeyboardLayoutStyle(
  backgroundColor: UIColor(red: 208.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1))

// MARK: - Row Style
public var CustomKeyboardFirstRowStyle = KeyboardRowStyle(topPadding: 10, topPaddingLandscape: 10)

public var CustomKeyboardSecondRowStyle = KeyboardRowStyle(
  leadingPadding: 22,
  leadingPaddingLandscape: 30,
  trailingPadding: 22,
  trailingPaddingLandscape: 30)

public var CustomKeyboardThirdRowStyle = KeyboardRowStyle(
  bottomPadding: 5,
  bottomPaddingLandscape: 3,
  buttonsPadding: 15)

public var CustomKeyboardChildRowStyle = KeyboardRowStyle(
  leadingPadding: 0,
  trailingPadding: 0)

public var CustomKeyboardFourthRowStyle = KeyboardRowStyle(
  topPadding: 5,
  topPaddingLandscape: 3,
  bottomPadding: 4,
  bottomPaddingLandscape: 4)

// MARK: - Button Style
public var CustomKeyboardKeyButtonStyle = KeyboardButtonStyle(keyPopType: .Default)
public var CustomKeyboardLeftKeyButtonStyle = KeyboardButtonStyle(keyPopType: .Left)
public var CustomKeyboardRightKeyButtonStyle = KeyboardButtonStyle(keyPopType: .Right)

public var CustomKeyboardLowercaseKeyButtonStyle = KeyboardButtonStyle(textOffsetY: -2, keyPopType: .Default)
public var CustomKeyboardLowercaseLeftKeyButtonStyle = KeyboardButtonStyle(textOffsetY: -2, keyPopType: .Left)
public var CustomKeyboardLowercaseRightKeyButtonStyle = KeyboardButtonStyle(textOffsetY: -2, keyPopType: .Right)

public var CustomKeyboardSpaceButtonStyle = KeyboardButtonStyle(font: UIFont.systemFontOfSize(15))
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
  font: UIFont.systemFontOfSize(15))

public var CustomKeyboardNumbersButtonStyle = KeyboardButtonStyle(
  backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
  font: UIFont.systemFontOfSize(15))

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
public class CustomKeyboardLayout {
  public var uppercase: KeyboardLayout
  public var uppercaseToggled: KeyboardLayout
  public var lowercase: KeyboardLayout
  public var numbers: KeyboardLayout
  public var symbols: KeyboardLayout

  public init() {
    uppercase = KeyboardLayout(
      style: CustomKeyboardLayoutStyle,
      rows: [
        KeyboardRow(
          style: CustomKeyboardFirstRowStyle,
          characters: [
            KeyboardButton(type: .Key("Q"), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .Key("W"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("E"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("R"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("T"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("Y"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("U"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("I"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("O"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("P"), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardSecondRowStyle,
          characters: [
            KeyboardButton(type: .Key("A"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("S"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("D"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("F"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("G"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("H"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("J"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("K"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("L"), style: CustomKeyboardKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardThirdRowStyle,
          characters: [
            KeyboardButton(
              type: .Image(UIImage(
                named: "ShiftOnce",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardShiftButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.ShiftOnce.rawValue),
            KeyboardRow(
              style: CustomKeyboardChildRowStyle,
              characters: [
                KeyboardButton(type: .Key("Z"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("X"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("C"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("V"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("B"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("N"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("M"), style: CustomKeyboardKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .Image(UIImage(
                named: "Backspace",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardBackspaceButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardFourthRowStyle,
          characters: [
            KeyboardButton(
              type: .Text("123"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardButton(
              type: .Image(UIImage(
                named: "Globe",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardGlobeButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .Text("space"),
              style: CustomKeyboardSpaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .Text("return"),
              style: CustomKeyboardReturnButtonStyle,
              width: .Relative(percent: 0.18),
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
            KeyboardButton(type: .Key("Q"), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .Key("W"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("E"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("R"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("T"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("Y"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("U"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("I"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("O"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("P"), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardSecondRowStyle,
          characters: [
            KeyboardButton(type: .Key("A"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("S"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("D"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("F"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("G"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("H"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("J"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("K"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("L"), style: CustomKeyboardKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardThirdRowStyle,
          characters: [
            KeyboardButton(
              type: .Image(UIImage(
                named: "ShiftOn",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardShiftButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.ShiftOn.rawValue),
            KeyboardRow(
              style: CustomKeyboardChildRowStyle,
              characters: [
                KeyboardButton(type: .Key("Z"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("X"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("C"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("V"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("B"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("N"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("M"), style: CustomKeyboardKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .Image(UIImage(
                named: "Backspace",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardBackspaceButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardFourthRowStyle,
          characters: [
            KeyboardButton(
              type: .Text("123"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardButton(
              type: .Image(UIImage(
                named: "Globe",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardGlobeButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .Text("space"),
              style: CustomKeyboardSpaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .Text("return"),
              style: CustomKeyboardReturnButtonStyle,
              width: .Relative(percent: 0.18),
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
            KeyboardButton(type: .Key("q"), style: CustomKeyboardLowercaseLeftKeyButtonStyle),
            KeyboardButton(type: .Key("w"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("e"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("r"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("t"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("y"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("u"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("i"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("o"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("p"), style: CustomKeyboardLowercaseRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardSecondRowStyle,
          characters: [
            KeyboardButton(type: .Key("a"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("s"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("d"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("f"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("g"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("h"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("j"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("k"), style: CustomKeyboardLowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("l"), style: CustomKeyboardLowercaseKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardThirdRowStyle,
          characters: [
            KeyboardButton(
              type: .Image(UIImage(
                named: "ShiftOff",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardShiftButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.ShiftOff.rawValue),
            KeyboardRow(
              style: CustomKeyboardChildRowStyle,
              characters: [
                KeyboardButton(type: .Key("z"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("x"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("c"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("v"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("b"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("n"), style: CustomKeyboardLowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("m"), style: CustomKeyboardLowercaseKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .Image(UIImage(
                named: "Backspace",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardBackspaceButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardFourthRowStyle,
          characters: [
            KeyboardButton(
              type: .Text("123"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardButton(
              type: .Image(UIImage(
                named: "Globe",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardGlobeButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .Text("space"),
              style: CustomKeyboardSpaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .Text("return"),
              style: CustomKeyboardReturnButtonStyle,
              width: .Relative(percent: 0.18),
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
            KeyboardButton(type: .Key("1"), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .Key("2"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("3"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("4"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("5"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("6"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("7"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("8"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("9"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("0"), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: KeyboardRowStyle(),
          characters: [
            KeyboardButton(type: .Key("-"), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .Key("/"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key(":"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key(";"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("("), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key(")"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("$"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("&"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("@"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("\""), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardThirdRowStyle,
          characters: [
            KeyboardButton(
              type: .Text("#+="),
              style: CustomKeyboardNumbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Symbols.rawValue),
            KeyboardRow(
              style: CustomKeyboardChildRowStyle,
              characters: [
                KeyboardButton(type: .Key("."), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key(","), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("?"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("!"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("'"), style: CustomKeyboardKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .Image(UIImage(
                named: "Backspace",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardBackspaceButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardFourthRowStyle,
          characters: [
            KeyboardButton(
              type: .Text("ABC"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Letters.rawValue),
            KeyboardButton(
              type: .Image(UIImage(
                named: "Globe",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardGlobeButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .Text("space"),
              style: CustomKeyboardSpaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .Text("return"),
              style: CustomKeyboardReturnButtonStyle,
              width: .Relative(percent: 0.18),
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
            KeyboardButton(type: .Key("["), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .Key("]"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("{"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("}"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("#"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("%"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("^"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("*"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("+"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("="), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: KeyboardRowStyle(),
          characters: [
            KeyboardButton(type: .Key("_"), style: CustomKeyboardLeftKeyButtonStyle),
            KeyboardButton(type: .Key("\\"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("|"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("~"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("<"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key(">"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("€"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("£"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("¥"), style: CustomKeyboardKeyButtonStyle),
            KeyboardButton(type: .Key("•"), style: CustomKeyboardRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardThirdRowStyle,
          characters: [
            KeyboardButton(
              type: .Text("123"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardRow(
              style: CustomKeyboardChildRowStyle,
              characters: [
                KeyboardButton(type: .Key("."), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key(","), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("?"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("!"), style: CustomKeyboardKeyButtonStyle),
                KeyboardButton(type: .Key("'"), style: CustomKeyboardKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .Image(UIImage(
                named: "Backspace",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardBackspaceButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: CustomKeyboardFourthRowStyle,
          characters: [
            KeyboardButton(
              type: .Text("ABC"),
              style: CustomKeyboardNumbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Letters.rawValue),
            KeyboardButton(
              type: .Image(UIImage(
                named: "Globe",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: CustomKeyboardGlobeButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .Text("space"),
              style: CustomKeyboardSpaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .Text("return"),
              style: CustomKeyboardReturnButtonStyle,
              width: .Relative(percent: 0.18),
              identifier: CustomKeyboardIdentifier.Return.rawValue),
          ]
        ),
      ]
    )
  }
}
