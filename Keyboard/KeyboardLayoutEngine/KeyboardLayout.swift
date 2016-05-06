//
//  KeyboardLayout.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

public struct KeyboardLayoutStyle {
  public var backgroundColor: UIColor
  public var topPadding: CGFloat
  public var bottomPadding: CGFloat
  public var rowPadding: CGFloat
}

public class KeyboardLayout {
  public var rows: [KeyboardRow]!
  public var style: KeyboardLayoutStyle!

  public init(rows: [KeyboardRow], style: KeyboardLayoutStyle) {
    self.rows = rows
    self.style = style
  }

  public func apply(onView view: UIView) {
    let layoutHeight = view.frame.size.height - style.topPadding - style.bottomPadding
    let layoutView = UIView(frame: CGRect(
      x: 0,
      y: style.topPadding,
      width: view.frame.size.width,
      height: layoutHeight))

    var currentY = CGFloat(0)
    for row in rows {
      row.frame.size.width = layoutView.frame.size.width
      row.frame.origin.y = currentY
      layoutView.addSubview(row)
      currentY += row.style.height + style.rowPadding
    }

    view.addSubview(layoutView)
  }
}
