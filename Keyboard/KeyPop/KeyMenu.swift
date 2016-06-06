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
  case Horizontal
  case Vertical
}

// MARK: - KeyMenuStyle
public struct KeyMenuStyle {
  // MARK: Shadow
  public var shadow: Shadow?

  // MARK: Background Color
  public var backgroundColor: UIColor

  // MARK: Item Style
  public var itemStyle: KeyMenuItemStyle
  public var itemSize: CGSize

  // MARK: Padding
  public var horizontalMenuItemPadding: CGFloat
  public var horizontalMenuLeftPadding: CGFloat
  public var horizontalMenuRightPadding: CGFloat

  // MARK: Separator
  public var verticalMenuSeparatorColor: UIColor
  public var verticalMenuSeparatorWidth: CGFloat

  // MARK: Init
  init(
    shadow: Shadow? = nil,
    backgroundColor: UIColor? = nil,
    itemStyle: KeyMenuItemStyle? = nil,
    itemSize: CGSize? = nil,
    horizontalMenuItemPadding: CGFloat? = nil,
    horizontalMenuLeftPadding: CGFloat? = nil,
    horizontalMenuRightPadding: CGFloat? = nil,
    verticalMenuSeparatorColor: UIColor? = nil,
    verticalMenuSeparatorWidth: CGFloat? = nil) {
    self.shadow = shadow
    self.backgroundColor = backgroundColor ?? UIColor.grayColor()
    self.itemStyle = itemStyle ?? KeyMenuItemStyle()
    self.itemSize = itemSize ?? CGSize(width: 40, height: 40)
    self.horizontalMenuItemPadding = horizontalMenuItemPadding ?? 5
    self.horizontalMenuLeftPadding = horizontalMenuLeftPadding ?? 5
    self.horizontalMenuRightPadding = horizontalMenuRightPadding ?? 5
    self.verticalMenuSeparatorColor = verticalMenuSeparatorColor ?? UIColor.blackColor()
    self.verticalMenuSeparatorWidth = verticalMenuSeparatorWidth ?? 1
  }
}

// MARK: - KeyMenu
public class KeyMenu: UIView {
  public var items = [KeyMenuItem]()
  public var style = KeyMenuStyle()
  public var type = KeyMenuType.Horizontal

  private let titleLabelTag = 1

  public var selectedIndex: Int = -1 {
    didSet {
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
  public override func layoutSubviews() {
    super.layoutSubviews()
    switch type {
    case .Horizontal:
      generateHorizontalMenu()
    case .Vertical:
      generateVerticalMenu()
    }
  }

  private func generateHorizontalMenu() {
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

  private func generateVerticalMenu() {
    frame = CGRect(
      x: 0,
      y: 0,
      width: style.itemSize.width,
      height: CGFloat(items.count) * style.itemSize.height)

    var currentY = CGFloat(0)
    for item in items {
      // Menu Item
      item.frame = CGRect(
        x: 0,
        y: currentY,
        width: style.itemSize.width,
        height: style.itemSize.height + style.verticalMenuSeparatorWidth)
      currentY += item.frame.size.height
      // Separator
      let seperatorLayer = CALayer()
      seperatorLayer.frame = CGRect(
        x: 0,
        y: style.itemSize.height,
        width: style.itemSize.width,
        height: style.verticalMenuSeparatorWidth)
      seperatorLayer.backgroundColor = style.verticalMenuSeparatorColor.CGColor
      item.layer.addSublayer(seperatorLayer)
    }
  }

  // MARK: Update Selection
  public func updateSelection(touchLocation location: CGPoint, inView view: UIView) {
    var isAboveMenu = false
    var isBelowMenu = false
    switch type {
    case .Horizontal:
      let beginingOfMenu = view.convertPoint(frame.origin, fromView: self).x
      let endOfMenu = view.convertPoint(CGPoint(x: frame.origin.x + frame.size.width, y: 0), fromView: self).x
      isAboveMenu = location.x < beginingOfMenu
      isBelowMenu = location.x > endOfMenu
    case .Vertical:
      let beginingOfMenu = view.convertPoint(frame.origin, fromView: self).y
      let endOfMenu = view.convertPoint(CGPoint(x: 0, y: frame.origin.y + frame.size.height), fromView: self).y
      isAboveMenu = location.y < beginingOfMenu
      isBelowMenu = location.y > endOfMenu
    }

    for (index, item) in items.enumerate() {
      switch index {
      case 0:
        item.highlighted = isAboveMenu
      case items.count - 1:
        item.highlighted = isBelowMenu
      default:
        let rect = CGRect(
          x: item.frame.origin.x,
          y: item.frame.origin.y,
          width: item.frame.size.width,
          height: item.frame.size.height)
        item.highlighted = CGRectContainsPoint(view.convertRect(rect, fromView: self), location)
      }
    }
  }
}
