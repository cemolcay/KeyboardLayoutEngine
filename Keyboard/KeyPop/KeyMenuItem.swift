//
//  KeyMenuItem.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 05/06/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

// MARK: KeyMenuItemStyle
public struct KeyMenuItemStyle {
  // MARK: Background Color
  public var highlightedBackgroundColor: UIColor

  // MARK: Text Color
  public var textColor: UIColor
  public var highlightedTextColor: UIColor

  // MARK: Font
  public var font: UIFont
  public var highlightedFont: UIFont

  // MARK: Init
  public init(
    highlightedBackgroundColor: UIColor? = nil,
    textColor: UIColor? = nil,
    highlightedTextColor: UIColor? = nil,
    font: UIFont? = nil,
    highlightedFont: UIFont? = nil) {
    self.highlightedBackgroundColor = highlightedBackgroundColor ?? UIColor.blueColor()
    self.textColor = textColor ?? UIColor.blackColor()
    self.highlightedTextColor = highlightedTextColor ?? UIColor.whiteColor()
    self.font = font ?? UIFont.systemFontOfSize(15)
    self.highlightedFont = highlightedFont ?? UIFont.boldSystemFontOfSize(15)
  }
}

// MARK: - KeyMenuItem
public typealias KeyMenuItemAction = (keyMenuItem: KeyMenuItem) -> Void

public class KeyMenuItem: UIView {
  public var title: String?
  public var style = KeyMenuItemStyle()
  public var action: KeyMenuItemAction?

  public var highlighted: Bool = false {
    didSet {
      setNeedsLayout()
    }
  }

  public var titleLabel: UILabel?

  // MARK: Init
  public init(
    title: String? = "",
    style: KeyMenuItemStyle = KeyMenuItemStyle(),
    action: KeyMenuItemAction? = nil) {
    super.init(frame: CGRect.zero)
    self.title = title
    self.style = style
    self.action = action

    titleLabel = UILabel()
    titleLabel?.text = title
    titleLabel?.textAlignment = .Center
    addSubview(titleLabel!)
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
    titleLabel?.frame = superview?.frame ?? CGRect.zero
    if highlighted {
      titleLabel?.textColor = style.highlightedTextColor
      titleLabel?.font = style.highlightedFont
      titleLabel?.backgroundColor = style.highlightedBackgroundColor
    } else {
      titleLabel?.textColor = style.textColor
      titleLabel?.font = style.font
      titleLabel?.backgroundColor = UIColor.clearColor()
    }
  }
}
