//
//  KeyPop.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 05/06/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit
import Shadow

// MARK: - KeyPopType
public enum KeyPopType {
  case normal
  case left
  case right
}

// MARK: - KeyPopStyle
public struct KeyPopStyle {
  public var backgroundColor: UIColor
  public var shadow: Shadow?
  public var widthMultiplier: CGFloat
  public var heightMultiplier: CGFloat
  public var font: UIFont
  public var textColor: UIColor
  public var contentInset: CGSize
  public var contentOffset: CGSize

  public init(
    backgroundColor: UIColor? = nil,
    shadow: Shadow? = nil,
    widthMultiplier: CGFloat? = nil,
    heightMultiplier: CGFloat? = nil,
    font: UIFont? = nil,
    textColor: UIColor? = nil,
    contentInset: CGSize? = nil,
    contentOffset: CGSize? = nil) {
    self.backgroundColor = backgroundColor ?? UIColor.white
    self.shadow = shadow ?? nil
    self.widthMultiplier = widthMultiplier ?? 1.2
    self.heightMultiplier = heightMultiplier ?? 1.2
    self.font = font ?? UIFont.systemFont(ofSize: 15)
    self.textColor = textColor ?? UIColor.black
    self.contentInset = contentInset ?? CGSize(width: 5, height: 5)
    self.contentOffset = contentOffset ?? CGSize.zero
  }
}

// MARK: - KeyPop
open class KeyPop: UIView {
  open var type: KeyPopType = .normal
  open var style: KeyPopStyle = KeyPopStyle()
  fileprivate(set) var keyboardButton: KeyboardButton?
  fileprivate(set) var contentView: UIView?

  // MARK: Init
  public init(referenceButton keyboardButton: KeyboardButton, style: KeyPopStyle = KeyPopStyle()) {
    super.init(frame: CGRect.zero)
    self.style = style
    self.keyboardButton = keyboardButton
    isUserInteractionEnabled = false

    switch keyboardButton.type {
    case .key(let text):
      let label = UILabel()
      label.text = text
      label.textColor = style.textColor
      label.textAlignment = .center
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.5
      if let textLabel = keyboardButton.textLabel {
        label.font = textLabel.font.withSize(textLabel.font.pointSize * style.widthMultiplier)
      } else {
        label.font = style.font.withSize(style.font.pointSize * style.widthMultiplier)
      }
      addSubview(label)
      contentView = label
    case .text(let text):
      let label = UILabel()
      label.text = text
      label.textColor = style.textColor
      label.textAlignment = .center
      label.adjustsFontSizeToFitWidth = true
      label.minimumScaleFactor = 0.5
      if let textLabel = keyboardButton.textLabel {
        label.font = textLabel.font.withSize(textLabel.font.pointSize * style.widthMultiplier)
      } else {
        label.font = style.font.withSize(style.font.pointSize * style.widthMultiplier)
      }
      contentView = label
      addSubview(label)
    case .image(let image):
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFit
      imageView.image = image
      contentView = imageView
      addSubview(imageView)
    }
  }

  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: Layout
  open override func layoutSubviews() {
    super.layoutSubviews()
    contentView?.frame = CGRect(
      x: style.contentInset.width + style.contentOffset.width,
      y: style.contentInset.height + style.contentOffset.height,
      width: frame.size.width - (style.contentInset.width * 2),
      height: frame.size.height - (style.contentInset.height * 2))
  }
}
