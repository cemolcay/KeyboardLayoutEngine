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
  public var leadingPaddingLandscape: CGFloat

  public var trailingPadding: CGFloat
  public var trailingPaddingLandscape: CGFloat

  public var topPadding: CGFloat
  public var topPaddingLandscape: CGFloat

  public var bottomPadding: CGFloat
  public var bottomPaddingLandscape: CGFloat

  public var buttonsPadding: CGFloat
  public var buttonsPaddingLandscape: CGFloat

  public init(
    leadingPadding: CGFloat? = nil,
    leadingPaddingLandscape: CGFloat? = nil,
    trailingPadding: CGFloat? = nil,
    trailingPaddingLandscape: CGFloat? = nil,
    topPadding: CGFloat? = nil,
    topPaddingLandscape: CGFloat? = nil,
    bottomPadding: CGFloat? = nil,
    bottomPaddingLandscape: CGFloat? = nil,
    buttonsPadding: CGFloat? = nil,
    buttonsPaddingLandscape: CGFloat? = nil) {

    self.leadingPadding = leadingPadding ?? 3
    self.leadingPaddingLandscape = leadingPaddingLandscape ?? leadingPadding ?? 3
    self.trailingPadding = trailingPadding ?? 3
    self.trailingPaddingLandscape = trailingPaddingLandscape ?? trailingPadding ?? 3
    self.topPadding = topPadding ?? 6
    self.topPaddingLandscape = topPaddingLandscape ?? topPadding ?? 6
    self.bottomPadding = bottomPadding ?? 6
    self.bottomPaddingLandscape = bottomPaddingLandscape ?? bottomPadding ?? 4
    self.buttonsPadding = buttonsPadding ?? 6
    self.buttonsPaddingLandscape = buttonsPaddingLandscape ?? buttonsPadding ?? 5
  }
}

// MARK: - KeyboardRow
open class KeyboardRow: UIView {
  open var style: KeyboardRowStyle!
  /// Characters should be eighter `KeyboardButton` or `KeyboardRow`
  open var characters: [AnyObject]!
  /// Managed by KeyboardLayout
  internal var isPortrait: Bool = true
  /// Managed by self, returns parent `KeyboardRow` if exists.
  open fileprivate(set) var parentRow: KeyboardRow?

  open var buttonHitRangeInsets: UIEdgeInsets {
    return UIEdgeInsets(
      top: isPortrait ? -style.topPadding : -style.topPaddingLandscape,
      left: -(style.buttonsPadding / 2.0),
      bottom: isPortrait ? -style.bottomPadding : -style.bottomPaddingLandscape,
      right: -(style.buttonsPadding / 2.0))
  }

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
  open override func layoutSubviews() {
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
        // Set hit range
        character.hitRangeInsets = buttonHitRangeInsets
        if character == characters.first as? KeyboardButton && parentRow == nil {
          character.hitRangeInsets.left -= 20
        } else if character == characters.last as? KeyboardButton && parentRow == nil {
          character.hitRangeInsets.right -= 20
        }
      }
      if let childRow = character as? KeyboardRow {
        childRow.parentRow = self
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

  fileprivate func getRelativeWidthForPercent(_ percent: CGFloat) -> CGFloat {
    let buttonsPadding = max(0, CGFloat(characters.count - 1)) * getButtonsPadding()
    let totalPadding = buttonsPadding + getLeadingPadding() + getTrailingPadding()
    let cleanWidth = frame.size.width - totalPadding
    return cleanWidth * percent
  }

  fileprivate func getWidthForKeyboardButton(_ button: KeyboardButton) -> CGFloat {
    switch button.widthInRow {
    case .dynamic:
      return getOptimumButtonWidth()
    case .static(let width):
      return width
    case .relative(let percent):
      return getRelativeWidthForPercent(percent)
    }
  }

  fileprivate func getOptimumButtonWidth() -> CGFloat {
    var charactersWithDynamicWidthCount: Int = 0
    var totalStaticWidthButtonsWidth: CGFloat = 0
    var totalChildRowPadding: CGFloat = 0

    for character in characters {
      if let button = character as? KeyboardButton {
        switch button.widthInRow {
        case .dynamic:
          charactersWithDynamicWidthCount += 1
        case .static(let width):
          totalStaticWidthButtonsWidth += width
        case .relative(let percent):
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
  open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    if UIEdgeInsetsEqualToEdgeInsets(buttonHitRangeInsets, UIEdgeInsets.zero) {
      return super.point(inside: point, with: event)
    }

    let hitFrame = UIEdgeInsetsInsetRect(bounds, buttonHitRangeInsets)
    return hitFrame.contains(point)
  }
}
