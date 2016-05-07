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
          width: character.width ?? optimumButtonWidth,
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

  private func getOptimumButtonWidth() -> CGFloat {
    var charactersWithDynamicWidthCount: Int = 0
    var totalStaticWidthButtonsWidth: CGFloat = 0
    var totalChildRowPadding: CGFloat = 0

    for character in characters {
      if let button = character as? KeyboardButton {
        if let width = button.width {
          totalStaticWidthButtonsWidth += width
        } else {
          charactersWithDynamicWidthCount += 1
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
}
