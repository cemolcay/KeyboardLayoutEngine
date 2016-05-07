//
//  KeyboardLayout.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

public struct KeyboardLayoutStyle {
  public var topPadding: CGFloat
  public var bottomPadding: CGFloat
  public var rowPadding: CGFloat
  public var backgroundColor: UIColor
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

    let optimumRowHeight = getOptimumRowHeight(forView: view)
    var currentY: CGFloat = 0

    for row in rows {
      row.frame = CGRect(
        x: 0,
        y: currentY,
        width: layoutView.frame.size.width,
        height: optimumRowHeight)
      layoutView.addSubview(row)
      currentY += optimumRowHeight + style.rowPadding
    }

    view.addSubview(layoutView)
  }

  private func getOptimumRowHeight(forView view: UIView) -> CGFloat {
    let height = view.frame.size.height
    let rowPaddings = CGFloat(max(rows.count - 1, 0)) * style.rowPadding
    let totalPaddings = rowPaddings + style.topPadding + style.bottomPadding
    return max(0, (height - totalPaddings) / CGFloat(rows.count))
  }
}
