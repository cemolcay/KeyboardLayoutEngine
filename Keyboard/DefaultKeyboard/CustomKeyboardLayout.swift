//
//  CustomKeyboardLayout.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 11/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

// MARK: - CustomKeyboardIdentifier
/// CustomKeyboardLayout KeyboardButton identifiers
public enum CustomKeyboardIdentifier: String {
  case Space = "Space"
  case Backspace = "Backspace"
  case Globe = "Globe"
  case Return = "Return"
  case Numbers = "Numbers"
  case Letters = "Letters"
  case Symbols = "Symbols"
  case Shift = "Shift"
  case ShiftToggled = "ShiftToggled"
  case ShiftToggledOnce = "ShiftToggledOnce"
}

// MARK: - CustomKeyboardLayoutStyle
/// Create CustomKeyboardLayout with style
public class CustomKeyboardLayoutStyle {

  // MARK: Layout Style
  public var layoutStyle = KeyboardLayoutStyle(backgroundColor: UIColor(
    red: 208.0/255.0,
    green: 213.0/255.0,
    blue: 219.0/255.0,
    alpha: 1))

  // MARK: Row Style
  public var rowStyle = KeyboardRowStyle()

  public var secondRowStyle = KeyboardRowStyle(
    leadingPadding: 22,
    leadingPaddingLandscape: 30,
    trailingPadding: 22,
    trailingPaddingLandscape: 30)

  public var thirdRowStyle = KeyboardRowStyle(
    bottomPadding: 10,
    bottomPaddingLandscape: 6,
    buttonsPadding: 15)

  public var childRowStyle = KeyboardRowStyle(
    leadingPadding: 0,
    trailingPadding: 0)

  // MARK: Button Style
  public var keyButtonStyle = KeyboardButtonStyle(keyPopType: .Default)
  public var leftKeyButtonStyle = KeyboardButtonStyle(keyPopType: .Left)
  public var rightKeyButtonStyle = KeyboardButtonStyle(keyPopType: .Right)

  public var lowercaseKeyButtonStyle = KeyboardButtonStyle(textOffsetY: -2, keyPopType: .Default)
  public var lowercaseLeftKeyButtonStyle = KeyboardButtonStyle(textOffsetY: -2, keyPopType: .Left)
  public var lowercaseRightKeyButtonStyle = KeyboardButtonStyle(textOffsetY: -2, keyPopType: .Right)

  public var spaceButtonStyle = KeyboardButtonStyle(font: UIFont.systemFontOfSize(15))

  public var backspaceButtonStyle = KeyboardButtonStyle(
    backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
    imageSize: 20)

  public var shiftButtonStyle = KeyboardButtonStyle(
    backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
    imageSize: 20)

  public var globeButtonStyle = KeyboardButtonStyle(
    backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
    imageSize: 20)

  public var returnButtonStyle = KeyboardButtonStyle(
    backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
    font: UIFont.systemFontOfSize(15))

  public var numbersButtonStyle = KeyboardButtonStyle(
    backgroundColor: UIColor(red: 172.0/255.0, green: 179.0/255.0, blue: 188.0/255.0, alpha: 1),
    font: UIFont.systemFontOfSize(15))
}

// MARK: - CustomKeyboardLayout
/// CustomKeyboardLayout is immutable.
/// Create a new keyboard layout when CustomKeyboardLayoutStyle change
public class CustomKeyboardLayout {
  public var uppercase: KeyboardLayout
  public var uppercaseToggled: KeyboardLayout
  public var lowercase: KeyboardLayout
  public var numbers: KeyboardLayout
  public var symbols: KeyboardLayout

  public init(style: CustomKeyboardLayoutStyle) {
    uppercase = KeyboardLayout(
        style: style.layoutStyle,
        rows: [
          KeyboardRow(
            style: style.rowStyle,
            characters: [
              KeyboardButton(type: .Key("Q"), style: style.leftKeyButtonStyle),
              KeyboardButton(type: .Key("W"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("E"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("R"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("T"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("Y"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("U"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("I"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("O"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("P"), style: style.rightKeyButtonStyle),
            ]
          ),
          KeyboardRow(
            style: style.secondRowStyle,
            characters: [
              KeyboardButton(type: .Key("A"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("S"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("D"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("F"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("G"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("H"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("J"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("K"), style: style.keyButtonStyle),
              KeyboardButton(type: .Key("L"), style: style.keyButtonStyle),
            ]
          ),
          KeyboardRow(
            style: style.thirdRowStyle,
            characters: [
              KeyboardButton(
                type: .Image(UIImage(
                  named: "shiftToggledOnce",
                  inBundle: NSBundle(forClass: CustomKeyboard.self),
                  compatibleWithTraitCollection: nil)),
                style: style.shiftButtonStyle,
                width: .Relative(percent: 0.115),
                identifier: CustomKeyboardIdentifier.ShiftToggledOnce.rawValue),
              KeyboardRow(
                style: style.childRowStyle,
                characters: [
                  KeyboardButton(type: .Key("Z"), style: style.keyButtonStyle),
                  KeyboardButton(type: .Key("X"), style: style.keyButtonStyle),
                  KeyboardButton(type: .Key("C"), style: style.keyButtonStyle),
                  KeyboardButton(type: .Key("V"), style: style.keyButtonStyle),
                  KeyboardButton(type: .Key("B"), style: style.keyButtonStyle),
                  KeyboardButton(type: .Key("N"), style: style.keyButtonStyle),
                  KeyboardButton(type: .Key("M"), style: style.keyButtonStyle),
                ]
              ),
              KeyboardButton(
                type: .Image(UIImage(
                  named: "backspace",
                  inBundle: NSBundle(forClass: CustomKeyboard.self),
                  compatibleWithTraitCollection: nil)),
                style: style.backspaceButtonStyle,
                width: .Relative(percent: 0.115),
                identifier: CustomKeyboardIdentifier.Backspace.rawValue),
            ]
          ),
          KeyboardRow(
            style: style.rowStyle,
            characters: [
              KeyboardButton(
                type: .Text("123"),
                style: style.numbersButtonStyle,
                width: .Relative(percent: 0.115),
                identifier: CustomKeyboardIdentifier.Numbers.rawValue),
              KeyboardButton(
                type: .Image(UIImage(
                  named: "globe",
                  inBundle: NSBundle(forClass: CustomKeyboard.self),
                  compatibleWithTraitCollection: nil)),
                style: style.globeButtonStyle,
                width: .Relative(percent: 0.115),
                identifier: CustomKeyboardIdentifier.Globe.rawValue),
              KeyboardButton(
                type: .Text("space"),
                style: style.spaceButtonStyle,
                identifier: CustomKeyboardIdentifier.Space.rawValue),
              KeyboardButton(
                type: .Text("return"),
                style: style.returnButtonStyle,
                width: .Relative(percent: 0.18),
                identifier: CustomKeyboardIdentifier.Return.rawValue),
            ]
          ),
        ]
      )

    uppercaseToggled = KeyboardLayout(
      style: style.layoutStyle,
      rows: [
        KeyboardRow(
          style: style.rowStyle,
          characters: [
            KeyboardButton(type: .Key("Q"), style: style.leftKeyButtonStyle),
            KeyboardButton(type: .Key("W"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("E"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("R"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("T"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("Y"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("U"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("I"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("O"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("P"), style: style.rightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: style.secondRowStyle,
          characters: [
            KeyboardButton(type: .Key("A"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("S"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("D"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("F"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("G"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("H"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("J"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("K"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("L"), style: style.keyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: style.thirdRowStyle,
          characters: [
            KeyboardButton(
              type: .Image(UIImage(
                named: "shiftToggled",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: style.shiftButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.ShiftToggled.rawValue),
            KeyboardRow(
              style: style.childRowStyle,
              characters: [
                KeyboardButton(type: .Key("Z"), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("X"), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("C"), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("V"), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("B"), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("N"), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("M"), style: style.keyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .Image(UIImage(
                named: "backspace",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: style.backspaceButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: style.rowStyle,
          characters: [
            KeyboardButton(
              type: .Text("123"),
              style: style.numbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardButton(
              type: .Image(UIImage(
                named: "globe",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: style.globeButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .Text("space"),
              style: style.spaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .Text("return"),
              style: style.returnButtonStyle,
              width: .Relative(percent: 0.18),
              identifier: CustomKeyboardIdentifier.Return.rawValue),
          ]
        ),
      ]
    )

    lowercase = KeyboardLayout(
      style: style.layoutStyle,
      rows: [
        KeyboardRow(
          style: style.rowStyle,
          characters: [
            KeyboardButton(type: .Key("q"), style: style.lowercaseLeftKeyButtonStyle),
            KeyboardButton(type: .Key("w"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("e"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("r"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("t"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("y"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("u"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("i"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("o"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("p"), style: style.lowercaseRightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: style.secondRowStyle,
          characters: [
            KeyboardButton(type: .Key("a"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("s"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("d"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("f"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("g"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("h"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("j"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("k"), style: style.lowercaseKeyButtonStyle),
            KeyboardButton(type: .Key("l"), style: style.lowercaseKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: style.thirdRowStyle,
          characters: [
            KeyboardButton(
              type: .Image(UIImage(
                named: "shift",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: style.shiftButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Shift.rawValue),
            KeyboardRow(
              style: style.childRowStyle,
              characters: [
                KeyboardButton(type: .Key("z"), style: style.lowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("x"), style: style.lowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("c"), style: style.lowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("v"), style: style.lowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("b"), style: style.lowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("n"), style: style.lowercaseKeyButtonStyle),
                KeyboardButton(type: .Key("m"), style: style.lowercaseKeyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .Image(UIImage(
                named: "backspace",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: style.backspaceButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: style.rowStyle,
          characters: [
            KeyboardButton(
              type: .Text("123"),
              style: style.numbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardButton(
              type: .Image(UIImage(
                named: "globe",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: style.globeButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .Text("space"),
              style: style.spaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .Text("return"),
              style: style.returnButtonStyle,
              width: .Relative(percent: 0.18),
              identifier: CustomKeyboardIdentifier.Return.rawValue),
          ]
        ),
      ]
    )

    numbers = KeyboardLayout(
      style: style.layoutStyle,
      rows: [
        KeyboardRow(
          style: style.rowStyle,
          characters: [
            KeyboardButton(type: .Key("1"), style: style.leftKeyButtonStyle),
            KeyboardButton(type: .Key("2"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("3"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("4"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("5"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("6"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("7"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("8"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("9"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("0"), style: style.rightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: style.rowStyle,
          characters: [
            KeyboardButton(type: .Key("-"), style: style.leftKeyButtonStyle),
            KeyboardButton(type: .Key("/"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key(":"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key(";"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("("), style: style.keyButtonStyle),
            KeyboardButton(type: .Key(")"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("$"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("&"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("@"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("\""), style: style.rightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: style.thirdRowStyle,
          characters: [
            KeyboardButton(
              type: .Text("#+="),
              style: style.numbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Symbols.rawValue),
            KeyboardRow(
              style: style.childRowStyle,
              characters: [
                KeyboardButton(type: .Key("."), style: style.keyButtonStyle),
                KeyboardButton(type: .Key(","), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("?"), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("!"), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("'"), style: style.keyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .Image(UIImage(
                named: "backspace",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: style.backspaceButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: style.rowStyle,
          characters: [
            KeyboardButton(
              type: .Text("ABC"),
              style: style.numbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Letters.rawValue),
            KeyboardButton(
              type: .Image(UIImage(
                named: "globe",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: style.globeButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .Text("space"),
              style: style.spaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .Text("return"),
              style: style.returnButtonStyle,
              width: .Relative(percent: 0.18),
              identifier: CustomKeyboardIdentifier.Return.rawValue),
          ]
        ),
      ]
    )

    symbols = KeyboardLayout(
      style: style.layoutStyle,
      rows: [
        KeyboardRow(
          style: style.rowStyle,
          characters: [
            KeyboardButton(type: .Key("["), style: style.leftKeyButtonStyle),
            KeyboardButton(type: .Key("]"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("{"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("}"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("#"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("%"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("^"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("*"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("+"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("="), style: style.rightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: style.rowStyle,
          characters: [
            KeyboardButton(type: .Key("_"), style: style.leftKeyButtonStyle),
            KeyboardButton(type: .Key("\\"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("|"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("~"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("<"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key(">"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("€"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("£"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("¥"), style: style.keyButtonStyle),
            KeyboardButton(type: .Key("•"), style: style.rightKeyButtonStyle),
          ]
        ),
        KeyboardRow(
          style: style.thirdRowStyle,
          characters: [
            KeyboardButton(
              type: .Text("123"),
              style: style.numbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Numbers.rawValue),
            KeyboardRow(
              style: style.childRowStyle,
              characters: [
                KeyboardButton(type: .Key("."), style: style.keyButtonStyle),
                KeyboardButton(type: .Key(","), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("?"), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("!"), style: style.keyButtonStyle),
                KeyboardButton(type: .Key("'"), style: style.keyButtonStyle),
              ]
            ),
            KeyboardButton(
              type: .Image(UIImage(
                named: "backspace",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: style.backspaceButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Backspace.rawValue),
          ]
        ),
        KeyboardRow(
          style: style.rowStyle,
          characters: [
            KeyboardButton(
              type: .Text("ABC"),
              style: style.numbersButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Letters.rawValue),
            KeyboardButton(
              type: .Image(UIImage(
                named: "globe",
                inBundle: NSBundle(forClass: CustomKeyboard.self),
                compatibleWithTraitCollection: nil)),
              style: style.globeButtonStyle,
              width: .Relative(percent: 0.115),
              identifier: CustomKeyboardIdentifier.Globe.rawValue),
            KeyboardButton(
              type: .Text("space"),
              style: style.spaceButtonStyle,
              identifier: CustomKeyboardIdentifier.Space.rawValue),
            KeyboardButton(
              type: .Text("return"),
              style: style.returnButtonStyle,
              width: .Relative(percent: 0.18),
              identifier: CustomKeyboardIdentifier.Return.rawValue),
          ]
        ),
      ]
    )
  }
}
