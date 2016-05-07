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

  public var characters: [AnyObject]!
  public var style: KeyboardRowStyle!
  private var childRowsAdded: Bool = false

  public init(characters: [AnyObject], style: KeyboardRowStyle) {
    super.init(frame: CGRect.zero)
    self.characters = characters
    self.style = style

    for character in characters {
      if let character = character as? KeyboardButton {
        addSubview(character)
      }
      if let row = character as? KeyboardRow {
        addSubview(row)
      }
    }
    childRowsAdded = true
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    if childRowsAdded {
      layoutRow(self)
    }
  }

  private func layoutRow(row: KeyboardRow) {
    let optimumButtonWidth = row.getOptimumButtonWidth()
    var currentX = row.style.leadingPadding
    for character in row.characters {
      if let character = character as? KeyboardButton {
        character.frame = CGRect(
          x: currentX,
          y: 0,
          width: character.width ?? optimumButtonWidth,
          height: row.frame.size.height)
        currentX += character.frame.size.width + row.style.buttonsPadding
      }
      if let childRow = character as? KeyboardRow {
        childRow.frame.size.height = frame.size.height
        childRow.frame.origin.x = currentX
        layoutRow(childRow)
      }
    }
    currentX += row.style.trailingPadding
    row.frame.size.width = currentX
  }

  private func getOptimumButtonWidth() -> CGFloat {
    let width = frame.size.width
    let charactersCount = getCharactersCount()
    let dynamicWidthCharactersCount = getDynamicWidthCharacterCount()
    let buttonsTotalPadding = CGFloat(max(0, charactersCount - 1)) * style.buttonsPadding
    let totalPadding = buttonsTotalPadding + style.leadingPadding + style.trailingPadding + getTotalStaticWidthOfButtons()
    return max(0, (width - totalPadding) / CGFloat(dynamicWidthCharactersCount))
  }

  private func getTotalStaticWidthOfButtons() -> CGFloat {
    var totalWidth = CGFloat(0)
    for character in characters {
      if let button = character as? KeyboardButton {
        if let width = button.width {
          totalWidth += width
        }
      }
      if let row = character as? KeyboardRow {
        totalWidth += row.getTotalStaticWidthOfButtons()
      }
    }
    return totalWidth
  }

  private func getCharactersCount() -> Int {
    var count = 0
    for character in characters {
      if character is KeyboardButton {
        count += 1
      }
      if let row = character as? KeyboardRow {
        count += row.getCharactersCount()
      }
    }
    return count
  }

  private func getDynamicWidthCharacterCount() -> Int {
    var count = 0
    for character in characters {
      if let button = character as? KeyboardButton {
        if button.width == nil {
          count += 1
        }
      }
      if let row = character as? KeyboardRow {
        count += row.getDynamicWidthCharacterCount()
      }
    }
    return count
  }
}
