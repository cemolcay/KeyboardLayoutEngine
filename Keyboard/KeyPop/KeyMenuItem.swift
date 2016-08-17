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

  // MARK: Separator
  public var separatorColor: UIColor
  public var separatorWidth: CGFloat

  // MARK: Init
  public init(
    highlightedBackgroundColor: UIColor? = nil,
    textColor: UIColor? = nil,
    highlightedTextColor: UIColor? = nil,
    font: UIFont? = nil,
    highlightedFont: UIFont? = nil,
    separatorColor: UIColor? = nil,
    separatorWidth: CGFloat? = nil) {
    self.highlightedBackgroundColor = highlightedBackgroundColor ?? UIColor.blue
    self.textColor = textColor ?? UIColor.black
    self.highlightedTextColor = highlightedTextColor ?? UIColor.white
    self.font = font ?? UIFont.systemFont(ofSize: 15)
    self.highlightedFont = highlightedFont ?? UIFont.boldSystemFont(ofSize: 15)
    self.separatorColor = separatorColor ?? UIColor.black
    self.separatorWidth = separatorWidth ?? 1
  }
}

// MARK: - KeyMenuItem
public typealias KeyMenuItemAction = (_ keyMenuItem: KeyMenuItem) -> Void

open class KeyMenuItem: UIView {
  open var title: String?
  open var style = KeyMenuItemStyle()
  open var action: KeyMenuItemAction?

  open var highlighted: Bool = false {
    didSet {
      setNeedsLayout()
    }
  }

  open var titleLabel: UILabel?
  open var separator: CALayer?

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
    titleLabel?.textAlignment = .center
    addSubview(titleLabel!)

    separator = CALayer()
    separator?.backgroundColor = style.separatorColor.cgColor
    layer.addSublayer(separator!)
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: Layout
  open override func layoutSubviews() {
    super.layoutSubviews()
    titleLabel?.frame = CGRect(
      x: 0,
      y: 0,
      width: frame.size.width,
      height: frame.size.height)

    separator?.frame = CGRect(
      x: 0,
      y: frame.size.height - style.separatorWidth,
      width: frame.size.width,
      height: style.separatorWidth)

    if highlighted {
      titleLabel?.textColor = style.highlightedTextColor
      titleLabel?.font = style.highlightedFont
      titleLabel?.backgroundColor = style.highlightedBackgroundColor
    } else {
      titleLabel?.textColor = style.textColor
      titleLabel?.font = style.font
      titleLabel?.backgroundColor = UIColor.clear
    }
  }
}
