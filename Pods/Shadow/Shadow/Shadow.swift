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
  public var color: UIColor = UIColor.grayColor()
  /// Radius of the shadow. Default is 1.
  public var radius: CGFloat = 1
  /// Opacity of the shadow. Default is 0.5
  public var opacity: Float = 0.5
  /// Offset of the shadow. Default is `CGSize(width: 0, height: 1)`
  public var offset: CGSize = CGSize(width: 0, height: 1)
  /// Optional bezier path of shadow.
  public var path: UIBezierPath?
}

/// Public extension of CALayer for applying or removing `Shadow`.
public extension CALayer {
  /// Applys shadow if given object is not nil.
  /// Removes shadow if given object is nil.
  public func applyShadow(shadow shadow: Shadow? = nil) {
    shadowPath = shadow?.path?.CGPath ?? nil
    shadowColor = shadow?.color.CGColor ?? UIColor.clearColor().CGColor
    shadowOffset = shadow?.offset ?? CGSize.zero
    shadowRadius = shadow?.radius ?? 0
    shadowOpacity = shadow?.opacity ?? 0
  }
}

/// Public extension of UIView for applying or removing `Shadow`
public extension UIView {
  /// Applys shadow on its layer if given object is not nil.
  /// Removes shadow on its layer if given object is nil.
  public func applyShadow(shadow shadow: Shadow? = nil) {
    layer.applyShadow(shadow: shadow)
  }
}
