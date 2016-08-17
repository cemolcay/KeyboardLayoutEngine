//
//  Shadow.swift
//  Shadow
//
//  Created by Cem Olcay on 05/06/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

/// Defines a shadow object for `CALayer` shadows.
/// Uses UIKit objects instead of CoreGraphics ones that CALayer uses.
public struct Shadow {
  /// Color of the shadow. Default is `UIColor.grayColor()`.
  public var color: UIColor
  /// Radius of the shadow. Default is 1.
  public var radius: CGFloat
  /// Opacity of the shadow. Default is 0.5
  public var opacity: Float
  /// Offset of the shadow. Default is `CGSize(width: 0, height: 1)`
  public var offset: CGSize
  /// Optional bezier path of shadow.
  public var path: UIBezierPath?

  /// Initilizes `Shadow` with default values or optional given values.
  public init(
    color: UIColor? = nil,
    radius: CGFloat? = nil,
    opacity: Float? = nil,
    offset: CGSize? = nil,
    path: UIBezierPath? = nil) {
    self.color = color ?? UIColor.gray
    self.radius = radius ?? 5
    self.opacity = opacity ?? 1
    self.offset = offset ?? CGSize(width: 0, height: 1)
    self.path = path
  }
}

/// Public extension of CALayer for applying or removing `Shadow`.
public extension CALayer {
  /// Applys shadow if given object is not nil.
  /// Removes shadow if given object is nil.
  public func applyShadow(shadow: Shadow? = nil) {
    shadowColor = shadow?.color.cgColor ?? UIColor.clear.cgColor
    shadowOpacity = shadow?.opacity ?? 0
    if let shadow = shadow {
      if let path = shadow.path {
        shadowRadius = shadow.radius
        shadowOffset = shadow.offset
        shadowPath = path.cgPath
      } else {
        var shadowRect = bounds
        shadowRect.origin = CGPoint(
          x: bounds.origin.x + shadow.offset.width,
          y: bounds.origin.y + shadow.offset.height)
        let path = UIBezierPath(
          roundedRect: shadowRect,
          cornerRadius: shadow.radius)
        shadowPath = path.cgPath
        shadowRadius = 0
        shadowOffset = CGSize.zero
      }
    } else {
      shadowRadius = 0
      shadowOffset = CGSize.zero
      shadowPath = nil
    }
  }
}

/// Public extension of UIView for applying or removing `Shadow`
public extension UIView {
  /// Applys shadow on its layer if given object is not nil.
  /// Removes shadow on its layer if given object is nil.
  public func applyShadow(shadow: Shadow? = nil) {
    layer.applyShadow(shadow: shadow)
  }
}
