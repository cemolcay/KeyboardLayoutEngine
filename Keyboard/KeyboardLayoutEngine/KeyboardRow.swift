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
  public var height: CGFloat
}

public class KeyboardRow: UIView {

  public var characters: [AnyObject]!
  public var style: KeyboardRowStyle!

  public init(characters: [AnyObject], style: KeyboardRowStyle) {
    super.init(frame: CGRect.zero)
    self.characters = characters
    self.style = style
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    layoutRow(self)
  }

  private func layoutRow(row: KeyboardRow) {
    let buttonWidth = getOptimumButtonWidth()
    var currentX = row.style.leadingPadding
    for character in characters {
      if let character = character as? KeyboardButton {
        character.frame = CGRect(
          x: currentX,
          y: 0,
          width: character.width ?? buttonWidth,
          height: style.height)
        row.addSubview(character)
        currentX += character.frame.size.width + row.style.buttonsPadding
      } else if let childRow = character as? KeyboardRow {
        childRow.style.height = style.height
        childRow.frame.origin.x = currentX
        addSubview(childRow)
        layoutRow(childRow)
      } else {
        continue
      }
    }
    currentX += row.style.trailingPadding
    row.frame.size.width = currentX
  }

  internal func getOptimumButtonWidth() -> CGFloat {
    let width = frame.size.width
    let charactersCount = getCharacterCount()
    let buttonsTotalPadding = CGFloat(min(0, charactersCount - 1)) * style.buttonsPadding
    let totalPadding = buttonsTotalPadding + style.leadingPadding + style.trailingPadding
    return max(0, (width - totalPadding) / CGFloat(charactersCount))
  }

  internal func getCharacterCount() -> Int {
    var count = 0
    for character in characters {
      if character is KeyboardButton {
        count += 1
      } else if let row = character as? KeyboardRow {
        count += row.getCharacterCount()
      }
    }
    return count
  }
}
