//
//  KeyboardButton.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

public struct KeyboardButtonStyle {
  public var backgroundColor: UIColor
  public var cornerRadius: CGFloat

  // Border
  public var borderColor: UIColor
  public var borderWidth: CGFloat

  // Shadow
  public var shadowColor: UIColor
  public var shadowOpacity: Float
  public var shadowOffset: CGSize
  public var shadowRadius: CGFloat
  public var shadowPath: UIBezierPath?

  // Text
  public var textColor: UIColor
  public var font: UIFont

  init(
    backgroundColor: UIColor? = nil,
    cornerRadius: CGFloat? = nil,
    borderColor: UIColor? = nil,
    borderWidth: CGFloat? = nil,
    shadowColor: UIColor? = nil,
    shadowOpacity: Float? = nil,
    shadowOffset: CGSize? = nil,
    shadowRadius: CGFloat? = nil,
    shadowPath: UIBezierPath? = nil,
    textColor: UIColor? = nil,
    font: UIFont? = nil) {
    self.backgroundColor = backgroundColor ?? UIColor.whiteColor()
    self.cornerRadius = cornerRadius ?? 5
    self.borderColor = borderColor ?? UIColor.clearColor()
    self.borderWidth = borderWidth ?? 0
    self.shadowColor = shadowColor ?? UIColor.blackColor()
    self.shadowOpacity = shadowOpacity ?? 0.4
    self.shadowOffset = shadowOffset ?? CGSize(width: 0, height: 1)
    self.shadowRadius = shadowRadius ?? 1
    self.shadowPath = shadowPath
    self.textColor = textColor ?? UIColor.blackColor()
    self.font = font ?? UIFont.systemFontOfSize(18)
  }
}

public class KeyboardButton: UIView {
  public var textLabel: UILabel?
  public var imageView: UIImageView?
  public var width: CGFloat?

  public init(text: String, style: KeyboardButtonStyle, width: CGFloat? = nil) {
    super.init(frame: CGRect.zero)
    self.width = width
    setupAppearance(style)

    textLabel = UILabel()
    textLabel?.text = text
    textLabel?.textColor = style.textColor
    textLabel?.font = style.font
    textLabel?.textAlignment = .Center
    textLabel?.translatesAutoresizingMaskIntoConstraints = false
    addSubview(textLabel!)
  }

  public init(imageNamed: String, style: KeyboardButtonStyle, width: CGFloat? = nil) {
    super.init(frame: CGRect.zero)
    self.width = width
    setupAppearance(style)

    imageView = UIImageView(image: UIImage(named: imageNamed))
    imageView?.contentMode = .ScaleAspectFit
    imageView?.translatesAutoresizingMaskIntoConstraints = false
    addSubview(imageView!)
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func setupAppearance(style: KeyboardButtonStyle) {
    backgroundColor = style.backgroundColor
    layer.cornerRadius = style.cornerRadius
    layer.borderColor = style.borderColor.CGColor
    layer.borderWidth = style.borderWidth
    layer.shadowColor = style.shadowColor.CGColor
    layer.shadowOpacity = style.shadowOpacity
    layer.shadowOffset = style.shadowOffset
    layer.shadowRadius = style.shadowRadius
    if let path = style.shadowPath {
      layer.shadowPath = path.CGPath
    }
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    let padding = CGFloat(5)
    textLabel?.frame = CGRect(
      x: padding,
      y: padding,
      width: frame.size.width - (padding * 2),
      height: frame.size.height - (padding * 2))
    imageView?.frame = CGRect(
      x: padding,
      y: padding,
      width: frame.size.width - (padding * 2),
      height: frame.size.height - (padding * 2))
  }
}
