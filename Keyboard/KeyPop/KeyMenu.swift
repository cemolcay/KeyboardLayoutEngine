//
//  KeyMenu.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 05/06/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit
import Shadow

// MARK: - KeyMenuType
public enum KeyMenuType {
  case horizontal
  case vertical
}

// MARK: - KeyMenuStyle
public struct KeyMenuStyle {
  // MARK: Shadow
  public var shadow: Shadow?

  // MARK: Background Color
  public var backgroundColor: UIColor

  // MARK: Item Style
  public var itemSize: CGSize

  // MARK: Padding
  public var horizontalMenuItemPadding: CGFloat
  public var horizontalMenuLeftPadding: CGFloat
  public var horizontalMenuRightPadding: CGFloat

  // MARK: Init
  public init(
    shadow: Shadow? = nil,
    backgroundColor: UIColor? = nil,
    itemSize: CGSize? = nil,
    horizontalMenuItemPadding: CGFloat? = nil,
    horizontalMenuLeftPadding: CGFloat? = nil,
    horizontalMenuRightPadding: CGFloat? = nil) {
    self.shadow = shadow
    self.backgroundColor = backgroundColor ?? UIColor.white
    self.itemSize = itemSize ?? CGSize(width: 40, height: 40)
    self.horizontalMenuItemPadding = horizontalMenuItemPadding ?? 5
    self.horizontalMenuLeftPadding = horizontalMenuLeftPadding ?? 5
    self.horizontalMenuRightPadding = horizontalMenuRightPadding ?? 5
  }
}

// MARK: - KeyMenu
open class KeyMenu: UIView {
  open var items = [KeyMenuItem]()
  open var style = KeyMenuStyle()
  open var type = KeyMenuType.horizontal

  fileprivate let titleLabelTag = 1

  open var selectedIndex: Int = -1 {
    didSet {
      if selectedIndex == -1 {
        for item in items {
          item.highlighted = false
        }
      }
      layoutIfNeeded()
    }
  }

  // MARK: Init
  public init(items: [KeyMenuItem], style: KeyMenuStyle, type: KeyMenuType) {
    super.init(frame: CGRect.zero)
    self.items = items
    self.style = style
    self.type = type

    backgroundColor = style.backgroundColor
    applyShadow(shadow: style.shadow)

    for item in items {
      addSubview(item)
    }
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: Layout
  open override func layoutSubviews() {
    super.layoutSubviews()
    switch type {
    case .horizontal:
      generateHorizontalMenu()
    case .vertical:
      generateVerticalMenu()
    }
  }

  fileprivate func generateHorizontalMenu() {
    let verticalPadding = CGFloat(5)
    let paddings = style.horizontalMenuLeftPadding +
      style.horizontalMenuRightPadding +
      (CGFloat(items.count - 1) * style.horizontalMenuItemPadding)
    let itemsWidth = CGFloat(items.count) * style.itemSize.width
    frame = CGRect(
      x: 0,
      y: 0,
      width: itemsWidth + paddings,
      height: style.itemSize.height + (verticalPadding * 2))

    var currentX = style.horizontalMenuLeftPadding
    for item in items {
      item.frame = CGRect(
        x: currentX,
        y: verticalPadding,
        width: style.itemSize.width,
        height: style.itemSize.height)
      currentX += item.frame.size.width + style.horizontalMenuItemPadding
    }
  }

  fileprivate func generateVerticalMenu() {
    frame = CGRect(
      x: 0,
      y: 0,
      width: style.itemSize.width,
      height: CGFloat(items.count) * style.itemSize.height)

    var currentY = CGFloat(0)
    for (index, item) in items.enumerated() {
      if index == items.count - 1 {
        item.separator = nil
      }
      item.frame = CGRect(
        x: 0,
        y: currentY,
        width: style.itemSize.width,
        height: style.itemSize.height)
      currentY += item.frame.size.height
    }
  }

  // MARK: Update Selection
  open func updateSelection(touchLocation location: CGPoint, inView view: UIView) {
    var tempIndex = -1
    for (index, item) in items.enumerated() {
      item.highlighted = view.convert(item.frame, from: self).contains(location)
      if item.highlighted {
        tempIndex = index
      }
    }
    selectedIndex = tempIndex
  }
}
