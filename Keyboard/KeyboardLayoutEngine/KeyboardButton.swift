//
//  KeyboardButton.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit
import ManualLayout

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

  // KeyPop
  public var keyPopType: KeyPopType?
  public var keyPopWidthMultiplier: CGFloat
  public var keyPopHeightMultiplier: CGFloat
  public var keyPopContainerView: UIView?

  public init(
    backgroundColor: UIColor = UIColor.whiteColor(),
    cornerRadius: CGFloat = 5,
    borderColor: UIColor = UIColor.clearColor(),
    borderWidth: CGFloat = 0,
    shadowEnabled: Bool = true,
    shadowColor: UIColor = UIColor.grayColor(),
    shadowOpacity: Float = 1,
    shadowOffset: CGSize = CGSize(width: 0, height: 1),
    shadowRadius: CGFloat = 0,
    shadowPath: UIBezierPath? = nil,
    textColor: UIColor = UIColor.blackColor(),
    font: UIFont = UIFont.systemFontOfSize(21),
    textOffsetY: CGFloat = 0,
    imageSize: CGFloat? = nil,
    keyPopType: KeyPopType? = nil,
    keyPopWidthMultiplier: CGFloat = 1.5,
    keyPopHeightMultiplier: CGFloat = 1.1,
    keyPopContainerView: UIView? = nil) {
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
    self.keyPopType = keyPopType
    self.keyPopWidthMultiplier = keyPopWidthMultiplier
    self.keyPopHeightMultiplier = keyPopHeightMultiplier
    self.keyPopContainerView = keyPopContainerView
  }
}

// MARK: - KeyboardButton
public var KeyboardButtonPopupViewTag: Int = 101
public var KeyboardButtonMenuViewTag: Int = 102

public class KeyboardButton: UIView {
  public var type: KeyboardButtonType = .Key("")
  public var widthInRow: KeyboardButtonWidth = .Dynamic
  public var style: KeyboardButtonStyle!
  public var keyMenu: KeyMenu?

  public var textLabel: UILabel?
  public var imageView: UIImageView?

  public var hitTestEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: -6, left: -6, bottom: -6, right: -6)
  public var identifier: String?

  // MARK: Init
  public init(
    type: KeyboardButtonType,
    style: KeyboardButtonStyle,
    width: KeyboardButtonWidth = .Dynamic,
    menu: KeyMenu? = nil,
    identifier: String? = nil) {

    super.init(frame: CGRect.zero)
    self.type = type
    self.style = style
    self.widthInRow = width
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
    var padding = CGFloat(0)
    textLabel?.frame = CGRect(
      x: padding,
      y: padding + style.textOffsetY,
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

  // MARK: KeyPop
  public func showKeyPop(show show: Bool) {
    if style.keyPopType == nil {
      return
    }

    let view = style.keyPopContainerView ?? self
    if show {
      if view.viewWithTag(KeyboardButtonPopupViewTag) != nil { return }
      let popup = createKeyPop()
      popup.tag = KeyboardButtonPopupViewTag
      popup.frame.origin = convertPoint(popup.frame.origin, toView: view)
      view.addSubview(popup)
    } else {
      if let popup = view.viewWithTag(KeyboardButtonPopupViewTag) {
        popup.removeFromSuperview()
      }
    }
  }

  private func createKeyPop() -> UIView {
    let padding = CGFloat(5)
    let popStyle = KeyPopStyle(
      widthMultiplier: style.keyPopWidthMultiplier,
      heightMultiplier: style.keyPopHeightMultiplier)
    let content = KeyPop(referenceButton: self, style: popStyle)
    let contentWidth = frame.size.width * content.style.widthMultiplier

    var contentX = CGFloat(0)
    var contentRoundCorners = UIRectCorner.AllCorners
    switch style.keyPopType! {
    case .Default:
      contentX = (contentWidth - width) / -2.0
    case .Right:
      contentX = width - contentWidth
      contentRoundCorners = [.TopLeft, .TopRight, .BottomLeft]
    case .Left:
      contentX = 0
      contentRoundCorners = [.TopLeft, .TopRight, .BottomRight]
    }

    content.frame = CGRect(
      x: contentX,
      y: 0,
      width: contentWidth,
      height: frame.size.height * content.style.heightMultiplier)
    content.bottom = -padding

    let bottomRect = CGRect(
      x: 0,
      y: -padding - 1, // a little hack for filling the gap
      width: width,
      height: height + padding)

    let path = UIBezierPath(
      roundedRect: content.frame,
      byRoundingCorners: contentRoundCorners,
      cornerRadii: CGSize(
        width: style.cornerRadius * style.keyPopWidthMultiplier,
        height: style.cornerRadius * style.keyPopHeightMultiplier))
    path.appendPath(UIBezierPath(
      roundedRect: bottomRect,
      byRoundingCorners: [.BottomLeft, .BottomRight],
      cornerRadii: CGSize(
        width: style.cornerRadius,
        height: style.cornerRadius)))

    let mask = CAShapeLayer()
    mask.path = path.CGPath
    mask.fillColor = popStyle.backgroundColor.CGColor

    let popup = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: content.width,
        height: content.height + padding + frame.size.height))
    popup.addSubview(content)
    popup.layer.applyShadow(shadow: popStyle.shadow)
    popup.layer.insertSublayer(mask, atIndex: 0)

    return popup
  }

  // MARK: KeyMenu
  public func showKeyMenu(show show: Bool) {
    if keyMenu == nil {
      return
    }

    let view = style.keyPopContainerView ?? self
    if show {
      if view.viewWithTag(KeyboardButtonMenuViewTag) != nil { return }
      keyMenu?.selectedIndex = -1
      let menu = createKeyMenu()
      menu.tag = KeyboardButtonMenuViewTag
      view.addSubview(menu)
    } else {
      if let menu = view.viewWithTag(KeyboardButtonMenuViewTag) {
        menu.removeFromSuperview()
      }
    }
  }

  private func createKeyMenu() -> UIView {
    guard let content = keyMenu else { return UIView() }
    let padding = CGFloat(5)
    content.bottom = -padding
    content.layer.cornerRadius = style.cornerRadius * style.keyPopWidthMultiplier
    content.clipsToBounds = true

    let bottomRect = CGRect(
      x: 0,
      y: -padding - 1, // a little hack for filling the gap
      width: width,
      height: height + padding)

    let path = UIBezierPath(
      roundedRect: content.frame,
      byRoundingCorners: [.TopLeft, .TopRight, .BottomRight],
      cornerRadii: CGSize(
        width: style.cornerRadius * style.keyPopWidthMultiplier,
        height: style.cornerRadius * style.keyPopHeightMultiplier))
    path.appendPath(UIBezierPath(
      roundedRect: bottomRect,
      byRoundingCorners: [.BottomLeft, .BottomRight],
      cornerRadii: CGSize(
        width: style.cornerRadius,
        height: style.cornerRadius)))

    let mask = CAShapeLayer()
    mask.path = path.CGPath
    mask.fillColor = content.style.backgroundColor.CGColor
    mask.applyShadow(shadow: content.style.shadow)

    let popup = UIView(
      frame: CGRect(
        x: 0,
        y: 0,
        width: content.width,
        height: content.height + padding + frame.size.height))
    popup.addSubview(content)
    popup.layer.insertSublayer(mask, atIndex: 0)
    return popup
  }

  // MARK: Hit Test
  public override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
    if UIEdgeInsetsEqualToEdgeInsets(hitTestEdgeInsets, UIEdgeInsetsZero) {
      return super.pointInside(point, withEvent: event)
    }

    let hitFrame = UIEdgeInsetsInsetRect(bounds, hitTestEdgeInsets)
    return CGRectContainsPoint(hitFrame, point)
  }
}
