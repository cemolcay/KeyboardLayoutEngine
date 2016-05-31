//
//  KeyboardRow.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

// MARK: - KeyboardRowStyle
public struct KeyboardRowStyle {
  public var leadingPadding: CGFloat
  public var leadingPaddingLandscape: CGFloat?
  public var trailingPadding: CGFloat
  public var trailingPaddingLandscape: CGFloat?
  public var bottomPadding: CGFloat?
  public var bottomPaddingLandscape: CGFloat?
  public var buttonsPadding: CGFloat
  public var buttonsPaddingLandscape: CGFloat?
  public var buttonHitTestEdgeInsests: UIEdgeInsets

  public init(
    leadingPadding: CGFloat = 3,
    leadingPaddingLandscape: CGFloat? = nil,
    trailingPadding: CGFloat = 3,
    trailingPaddingLandscape: CGFloat? = nil,
    topPadding: CGFloat? = nil,
    topPaddingLandscape: CGFloat? = nil,
    bottomPadding: CGFloat? = nil,
    bottomPaddingLandscape: CGFloat? = nil,
    buttonsPadding: CGFloat = 6,
    buttonsPaddingLandscape: CGFloat? = nil,
    buttonHitTestEdgeInsests: UIEdgeInsets = UIEdgeInsets(top: -6, left: -6, bottom: -6, right: -6)) {

    self.leadingPadding = leadingPadding
    self.leadingPaddingLandscape = leadingPaddingLandscape
    self.trailingPadding = trailingPadding
    self.trailingPaddingLandscape = trailingPaddingLandscape
    self.bottomPadding = bottomPadding
    self.bottomPaddingLandscape = bottomPaddingLandscape
    self.buttonsPadding = buttonsPadding
    self.buttonsPaddingLandscape = buttonsPaddingLandscape
    self.buttonHitTestEdgeInsests = buttonHitTestEdgeInsests
  }
}

// MARK: - KeyboardRow
public class KeyboardRow: UIView {
  public var style: KeyboardRowStyle!
  /// Characters should be eighter `KeyboardButton` or `KeyboardRow`
  public var characters: [AnyObject]!
  /// Managed by KeyboardLayout
  internal var isPortrait: Bool = true

  // MARK: Init
  public init(style: KeyboardRowStyle, characters: [AnyObject]) {
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

  // MARK: Paddings

  func getLeadingPadding() -> CGFloat {
    return isPortrait ? style.leadingPadding : style.leadingPaddingLandscape ?? style.leadingPadding
  }

  func getTrailingPadding() -> CGFloat {
    return isPortrait ? style.trailingPadding : style.trailingPaddingLandscape ?? style.trailingPadding
  }

  func getButtonsPadding() -> CGFloat {
    return isPortrait ? style.buttonsPadding : style.buttonsPaddingLandscape ?? style.buttonsPadding
  }

  // MARK: Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
    let optimumButtonWidth = getOptimumButtonWidth()
    var currentX = getLeadingPadding()
    for character in characters {
      if let character = character as? KeyboardButton {
        character.frame = CGRect(
          x: currentX,
          y: 0,
          width: getWidthForKeyboardButton(character),
          height: frame.size.height)
        currentX += character.frame.size.width + getButtonsPadding()
      }
      if let childRow = character as? KeyboardRow {
        childRow.isPortrait = isPortrait
        childRow.frame = CGRect(
          x: currentX,
          y: 0,
          width: childRow.getLeadingPadding() + optimumButtonWidth  + childRow.getTrailingPadding(),
          height: frame.size.height)
        currentX += childRow.frame.size.width + getButtonsPadding()
      }
    }
    currentX += getTrailingPadding()
  }

  private func getRelativeWidthForPercent(percent: CGFloat) -> CGFloat {
    let buttonsPadding = max(0, CGFloat(characters.count - 1)) * getButtonsPadding()
    let totalPadding = buttonsPadding + getLeadingPadding() + getTrailingPadding()
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
        totalChildRowPadding += row.getLeadingPadding() + row.getTrailingPadding()
        charactersWithDynamicWidthCount += 1
      }
    }

    let width = frame.size.width
    let totalButtonPadding: CGFloat = max(0, CGFloat(characters.count - 1) * getButtonsPadding())
    let totalPadding = totalButtonPadding +
      totalStaticWidthButtonsWidth +
      totalChildRowPadding +
      getLeadingPadding() +
      getTrailingPadding()
    let opt = (width - totalPadding) / CGFloat(charactersWithDynamicWidthCount)
    return opt
  }

  // MARK: Hit Test
  public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    if UIEdgeInsetsEqualToEdgeInsets(style.buttonHitTestEdgeInsests, UIEdgeInsetsZero) {
      return super.pointInside(point, withEvent: event)
    }

    let hitFrame = UIEdgeInsetsInsetRect(bounds, style.buttonHitTestEdgeInsests)
    return CGRectContainsPoint(hitFrame, point)
  }

  // MARK: Button Highlighting
  public func highlightButton(button: KeyboardButton) {
    for character in characters {
      if let highlightedButton = character as? KeyboardButton {
        highlightedButton.highlighted = highlightedButton == button
      } else if let row = character as? KeyboardRow {
        row.highlightButton(button)
      }
    }
  }

  public func unhighlightButtons() {
    for character in characters {
      if let highlightedButton = character as? KeyboardButton {
        highlightedButton.highlighted = false
      } else if let row = character as? KeyboardRow {
        row.unhighlightButtons()
      }
    }
  }
}
