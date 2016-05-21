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
  public var shadowEnabled: Bool
  public var shadowColor: UIColor
  public var shadowOpacity: Float
  public var shadowOffset: CGSize
  public var shadowRadius: CGFloat
  public var shadowPath: UIBezierPath?

  // Text
  public var textColor: UIColor
  public var font: UIFont
  public var textOffsetY: CGFloat

  // Image
  public var imageSize: CGFloat?

  // Popup
  public var showsPopup: Bool
  public var popupWidthMultiplier: CGFloat
  public var popupHeightMultiplier: CGFloat

  public init(
    backgroundColor: UIColor = UIColor.whiteColor(),
    cornerRadius: CGFloat = 5,
    borderColor: UIColor = UIColor.clearColor(),
    borderWidth: CGFloat = 0,
    shadowEnabled: Bool = true,
    shadowColor: UIColor = UIColor(red: 138.0/255.0, green: 139.0/255.0, blue: 143.0/255.0, alpha: 1),
    shadowOpacity: Float = 1,
    shadowOffset: CGSize = CGSize(width: 0, height: 1),
    shadowRadius: CGFloat = 1 / UIScreen.mainScreen().scale,
    shadowPath: UIBezierPath? = nil,
    textColor: UIColor = UIColor.blackColor(),
    font: UIFont = UIFont.systemFontOfSize(20),
    textOffsetY: CGFloat = 0,
    imageSize: CGFloat? = nil,
    showsPopup: Bool = true,
    popupWidthMultiplier: CGFloat = 1.7,
    popupHeightMultiplier: CGFloat = 1.4) {
    self.backgroundColor = backgroundColor
    self.cornerRadius = cornerRadius
    self.borderColor = borderColor
    self.borderWidth = borderWidth
    self.shadowEnabled = shadowEnabled
    self.shadowColor = shadowColor
    self.shadowOpacity = shadowOpacity
    self.shadowOffset = shadowOffset
    self.shadowRadius = shadowRadius
    self.shadowPath = shadowPath
    self.textColor = textColor
    self.font = font
    self.textOffsetY = textOffsetY
    self.imageSize = imageSize
    self.showsPopup = showsPopup
    self.popupWidthMultiplier = popupWidthMultiplier
    self.popupHeightMultiplier = popupHeightMultiplier
  }
}

// MARK: - KeyboardButton
private let KeyboardButtonPopupViewTag: Int = 101

public class KeyboardButton: UIView {
  public var type: KeyboardButtonType = .Key("")
  public var width: KeyboardButtonWidth = .Dynamic
  public var style: KeyboardButtonStyle!

  public var textLabel: UILabel?
  public var imageView: UIImageView?

  public var identifier: String?
  public var highlighted: Bool = false {
    didSet {
      if style.showsPopup {
        showPopup(show: highlighted)
      }
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
      textLabel?.adjustsFontSizeToFitWidth = true
      textLabel?.minimumScaleFactor = 0.5
      addSubview(textLabel!)
    case .Text(let text):
      textLabel = UILabel()
      textLabel?.text = text
      textLabel?.textColor = style.textColor
      textLabel?.font = style.font
      textLabel?.textAlignment = .Center
      textLabel?.translatesAutoresizingMaskIntoConstraints = false
      textLabel?.adjustsFontSizeToFitWidth = true
      textLabel?.minimumScaleFactor = 0.5
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
    // border
    layer.borderColor = style.borderColor.CGColor
    layer.borderWidth = style.borderWidth
    // shadow
    if style.shadowEnabled {
      layer.shadowColor = style.shadowColor.CGColor
      layer.shadowOpacity = style.shadowOpacity
      layer.shadowOffset = style.shadowOffset
      layer.shadowRadius = style.shadowRadius
      if let path = style.shadowPath {
        layer.shadowPath = path.CGPath
      }
    }
  }

  // MARK: Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
    var padding = CGFloat(5)
    textLabel?.frame = CGRect(
      x: padding,
      y: padding + style.textOffsetY,
      width: frame.size.width - (padding * 2),
      height: frame.size.height - (padding * 2))

    switch type {
    case .Key(_):
      textLabel?.font = textLabel?.font.fontWithSize(min(textLabel!.frame.size.height, textLabel!.frame.size.width) + 1)
    default:
      break
    }

    if let imageSize = style.imageSize {
      padding = (min(frame.size.height, frame.size.width) - imageSize) / 2
    }

    imageView?.frame = CGRect(
      x: padding,
      y: padding,
      width: frame.size.width - (padding * 2),
      height: frame.size.height - (padding * 2))
  }

  private func showPopup(show show: Bool) {
    if show {
      if viewWithTag(KeyboardButtonPopupViewTag) != nil { return }
      let popup = createPopup()
      popup.tag = KeyboardButtonPopupViewTag
      addSubview(popup)
    } else {
      if let popup = viewWithTag(KeyboardButtonPopupViewTag) {
        popup.removeFromSuperview()
      }
    }
  }

  public func createPopup() -> UIView {
    let topCornerRadius = style.cornerRadius * style.popupWidthMultiplier
    let topWidth = frame.size.width * style.popupWidthMultiplier
    let topHeight = frame.size.height * style.popupHeightMultiplier
    let middleWidth = frame.size.width
    let middleHeight = CGFloat(3) + style.cornerRadius
    // middle
    let middle = UIView(frame: CGRect(x: 0, y: -middleHeight + (style.cornerRadius / 2) + 1, width: middleWidth, height: middleHeight))
    middle.backgroundColor = style.backgroundColor
    middle.center.x = frame.size.width / 2
    // top
    let top = UIView(frame: CGRect(
      x: 0,
      y: middle.frame.origin.y - topHeight,
      width: topWidth,
      height: topHeight))
    top.backgroundColor = style.backgroundColor
    top.layer.cornerRadius = topCornerRadius
    top.center.x = frame.size.width / 2
    top.addSubview(copyContentIntoView(top))
    // popup
    let popup = UIView()
    popup.userInteractionEnabled = false
    popup.addSubview(middle)
    popup.addSubview(top)
    return popup
  }

  private func copyContentIntoView(view: UIView) -> UIView {
    let padding = CGFloat(5)
    let contentView = UIView(frame: CGRect(
      x: padding,
      y: padding,
      width: view.frame.size.width - (padding * 2),
      height: view.frame.size.height - (padding * 2)))

    switch type {
    case .Key(let text):
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
      label.text = text
      label.textColor = style.textColor
      label.textAlignment = .Center
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.5
      if let textLabel = self.textLabel {
        label.font = textLabel.font.fontWithSize(textLabel.font.pointSize * style.popupWidthMultiplier)
      } else {
        label.font = style.font.fontWithSize(style.font.pointSize * style.popupWidthMultiplier)
      }
      contentView.addSubview(label)
    case .Text(let text):
      let label = UILabel(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
      label.text = text
      label.textColor = style.textColor
      label.textAlignment = .Center
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.5
      if let textLabel = self.textLabel {
        label.font = textLabel.font.fontWithSize(textLabel.font.pointSize * style.popupWidthMultiplier)
      } else {
        label.font = style.font.fontWithSize(style.font.pointSize * style.popupWidthMultiplier)
      }
      contentView.addSubview(label)
    case .Image(let image):
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height))
      imageView.contentMode = .ScaleAspectFit
      imageView.image = image
      contentView.addSubview(imageView)
    }
    
    return contentView
  }
}
