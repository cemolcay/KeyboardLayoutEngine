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
  public var shadow: Shadow?
  public var backgroundColor: UIColor
  public var highlightedBackgroundColor: UIColor
  public var textColor: UIColor
  public var highlightedTextColor: UIColor
  public var font: UIFont
  public var highlightedFont: UIFont

  init(
    shadow: Shadow? = nil,
    backgroundColor: UIColor? = nil,
    highlightedBackgroundColor: UIColor? = nil,
    textColor: UIColor? = nil,
    highlightedTextColor: UIColor? = nil,
    font: UIFont? = nil,
    highlightedFont: UIFont? = nil) {
    self.shadow = shadow
    self.backgroundColor = backgroundColor ?? UIColor.grayColor()
    self.highlightedBackgroundColor = highlightedBackgroundColor ?? UIColor.blueColor()
    self.textColor = textColor ?? UIColor.blackColor()
    self.highlightedTextColor = highlightedTextColor ?? UIColor.whiteColor()
    self.font = font ?? UIFont.systemFontOfSize(15)
    self.highlightedFont = highlightedFont ?? UIFont.boldSystemFontOfSize(15)
  }
}

// MARK: - KeyMenu
public class KeyMenu: UIView {
  public var items = [String]()
  public var style = KeyMenuStyle()
  public var type = KeyMenuType.Horizontal

  public var selectedIndex: Int = -1

  // MARK: Init
  public init(items: [String], style: KeyMenuStyle, type: KeyMenuType) {
    super.init(frame: CGRect.zero)
    self.items = items
    self.style = style
    self.type = type
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}
