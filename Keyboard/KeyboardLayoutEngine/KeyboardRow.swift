//
//  KeyboardRow.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

public struct KeyboardRowStyle {
  public var leadingPadding: CGFloat
  public var trailingPadding: CGFloat
  public var buttonsPadding: CGFloat

  public init(
    leadingPadding: CGFloat = 5,
    trailingPadding: CGFloat = 5,
    buttonsPadding: CGFloat = 6) {
    
    self.leadingPadding = leadingPadding
    self.trailingPadding = trailingPadding
    self.buttonsPadding = buttonsPadding
  }
}

public class KeyboardRow: UIView {
  /// Characters should be eighter `KeyboardButton` or `KeyboardRow`
  public var characters: [AnyObject]!
  public var style: KeyboardRowStyle!

  public init(characters: [AnyObject], style: KeyboardRowStyle) {
    assert(characters.filter({ !(($0 is KeyboardButton) || ($0 is KeyboardRow)) }).count <= 0)
    super.init(frame: CGRect.zero)
    
    self.style = style
    self.characters = characters

    for character in self.characters {
      if let character = character as? KeyboardButton {
        addSubview(character)
      }
      if let row = character as? KeyboardRow {
        addSubview(row)
      }
    }
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    let optimumButtonWidth = getOptimumButtonWidth()
    var currentX = style.leadingPadding
    for character in characters {
      if let character = character as? KeyboardButton {
        character.frame = CGRect(
          x: currentX,
          y: 0,
          width: getWidthForKeyboardButton(character),
          height: frame.size.height)
        currentX += character.frame.size.width + style.buttonsPadding
      }
      if let childRow = character as? KeyboardRow {
        childRow.frame = CGRect(
          x: currentX,
          y: 0,
          width: childRow.style.leadingPadding + optimumButtonWidth  + childRow.style.trailingPadding,
          height: frame.size.height)
        currentX += childRow.frame.size.width + style.buttonsPadding
      }
    }
    currentX += style.trailingPadding
  }

  private func getRelativeWidthForPercent(percent: CGFloat) -> CGFloat {
    let buttonsPadding = max(0, CGFloat(characters.count - 1)) * style.buttonsPadding
    let totalPadding = buttonsPadding + style.leadingPadding + style.trailingPadding
    let cleanWidth = frame.size.width - totalPadding
    return cleanWidth * percent
  }

  private func getWidthForKeyboardButton(button: KeyboardButton) -> CGFloat {
    switch button.width {
    case .Dynamic:
      return getOptimumButtonWidth()
    case .Static(let width):
      return width
    case .Relative(let percent):
      return getRelativeWidthForPercent(percent)
    }
  }

  private func getOptimumButtonWidth() -> CGFloat {
    var charactersWithDynamicWidthCount: Int = 0
    var totalStaticWidthButtonsWidth: CGFloat = 0
    var totalChildRowPadding: CGFloat = 0

    for character in characters {
      if let button = character as? KeyboardButton {
        switch button.width {
        case .Dynamic:
          charactersWithDynamicWidthCount += 1
        case .Static(let width):
          totalStaticWidthButtonsWidth += width
        case .Relative(let percent):
          totalStaticWidthButtonsWidth += getRelativeWidthForPercent(percent)
          break
         }
      } else if let row = character as? KeyboardRow {
        totalChildRowPadding += row.style.leadingPadding + row.style.trailingPadding
        charactersWithDynamicWidthCount += 1
      }
    }

    let width = frame.size.width
    let totalButtonPadding: CGFloat = max(0, CGFloat(characters.count - 1) * style.buttonsPadding)
    let totalPadding = totalButtonPadding +
      totalStaticWidthButtonsWidth +
      totalChildRowPadding +
      style.leadingPadding +
      style.trailingPadding
    let opt = (width - totalPadding) / CGFloat(charactersWithDynamicWidthCount)
    return opt
  }

  public func highlightButton(button: KeyboardButton) {
    for character in characters {
      if let highlightedButton = character as? KeyboardButton {
        highlightedButton.highlighted = highlightedButton == button
      } else if let row = character as? KeyboardRow {
        row.highlightButton(button)
      }
    }
  }
}
