//
//  KeyboardButton.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

// MARK: - KeyboardButtonType
public enum KeyboardButtonType {
  case Key(String)
  case Text(String)
  case Image(UIImage?)
}

// MARK: - KeyboardButtonWidth
public enum KeyboardButtonWidth {
  case Dynamic
  case Static(width: CGFloat)
  case Relative(percent: CGFloat)
}

// MARK: - KeyboardButtonStyle
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

  // Image
  public var imageSize: CGFloat?

  // Popup
  public var showsPopup: Bool

  init(
    backgroundColor: UIColor = UIColor.whiteColor(),
    cornerRadius: CGFloat = 5,
    borderColor: UIColor = UIColor.clearColor(),
    borderWidth: CGFloat = 0,
    shadowColor: UIColor = UIColor.blackColor(),
    shadowOpacity: Float = 0.4,
    shadowOffset: CGSize = CGSize(width: 0, height: 1),
    shadowRadius: CGFloat = 1 / UIScreen.mainScreen().scale,
    shadowPath: UIBezierPath? = nil,
    textColor: UIColor = UIColor.blackColor(),
    font: UIFont = UIFont.systemFontOfSize(20),
    imageSize: CGFloat? = nil,
    showsPopup: Bool = false) {
    self.backgroundColor = backgroundColor
    self.cornerRadius = cornerRadius
    self.borderColor = borderColor
    self.borderWidth = borderWidth
    self.shadowColor = shadowColor
    self.shadowOpacity = shadowOpacity
    self.shadowOffset = shadowOffset
    self.shadowRadius = shadowRadius
    self.shadowPath = shadowPath
    self.textColor = textColor
    self.font = font
    self.imageSize = imageSize
    self.showsPopup = showsPopup
  }
}

// MARK: - KeyboardButton
public class KeyboardButton: UIView {
  public var type: KeyboardButtonType = .Key("")
  public var width: KeyboardButtonWidth = .Dynamic
  public var style: KeyboardButtonStyle!

  public var textLabel: UILabel?
  public var imageView: UIImageView?

  public var identifier: String?
  public var highlighted: Bool = false {
    didSet {
      showPopup(show: highlighted)
    }
  }

  // MARK: Init
  public init(
    type: KeyboardButtonType,
    style: KeyboardButtonStyle,
    width: KeyboardButtonWidth = .Dynamic,
    identifier: String? = nil) {
    
    super.init(frame: CGRect.zero)
    self.type = type
    self.style = style
    self.width = width
    self.identifier = identifier
    userInteractionEnabled = true
    setupAppearance()

    switch type {
    case .Key(let text):
      textLabel = UILabel()
      textLabel?.text = text
      textLabel?.textColor = style.textColor
      textLabel?.font = style.font
      textLabel?.textAlignment = .Center
      textLabel?.translatesAutoresizingMaskIntoConstraints = false
      addSubview(textLabel!)
    case .Text(let text):
      textLabel = UILabel()
      textLabel?.text = text
      textLabel?.textColor = style.textColor
      textLabel?.font = style.font
      textLabel?.textAlignment = .Center
      textLabel?.translatesAutoresizingMaskIntoConstraints = false
      addSubview(textLabel!)
    case .Image(let image):
      imageView = UIImageView(image: image)
      imageView?.contentMode = .ScaleAspectFit
      addSubview(imageView!)
    }
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  private func setupAppearance() {
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

  // MARK: Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
    var padding = CGFloat(5)
    textLabel?.frame = CGRect(
      x: padding,
      y: padding,
      width: frame.size.width - (padding * 2),
      height: frame.size.height - (padding * 2))

    if let imageSize = style.imageSize {
      padding = (min(frame.size.height, frame.size.width) - imageSize) / 2
    }

    imageView?.frame = CGRect(
      x: padding,
      y: padding,
      width: frame.size.width - (padding * 2),
      height: frame.size.height - (padding * 2))
  }

  // MARK: Popup
  private func showPopup(show show: Bool) {
    if show {

    } else {

    }
  }
}
