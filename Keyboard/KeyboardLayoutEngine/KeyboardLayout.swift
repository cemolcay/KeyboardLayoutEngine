//
//  KeyboardLayout.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

// MARK: - KeyboardLayoutDelegate
public protocol KeyboardLayoutDelegate: class {
  func keyboardLayoutDidPressButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton)
}

// MARK: - KeyboardLayoutStyle
public struct KeyboardLayoutStyle {
  public var topPadding: CGFloat
  public var bottomPadding: CGFloat
  public var rowPadding: CGFloat
  public var backgroundColor: UIColor

  public init(
    topPadding: CGFloat = 5,
    bottomPadding: CGFloat = 5,
    rowPadding: CGFloat = 15,
    backgroundColor: UIColor = UIColor(red: 208.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)) {
    self.topPadding = topPadding
    self.bottomPadding = bottomPadding
    self.rowPadding = rowPadding
    self.backgroundColor = backgroundColor
  }
}

// MARK: - KeyboardLayout
public class KeyboardLayout: UIView {
  public var style: KeyboardLayoutStyle!
  public var rows: [KeyboardRow]!

  public weak var delegate: KeyboardLayoutDelegate?

  // MARK: Init
  public init(style: KeyboardLayoutStyle, rows: [KeyboardRow]) {
    super.init(frame: CGRect.zero)
    self.style = style
    self.rows = rows

    for row in rows {
      addSubview(row)
    }
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

  // MARK: Layout
  public override func layoutSubviews() {
    super.layoutSubviews()
    guard let superview = superview else { return }
    superview.backgroundColor = style.backgroundColor

    let layoutHeight = superview.frame.size.height - style.topPadding - style.bottomPadding
    frame = CGRect(x: 0, y: style.topPadding, width: superview.frame.size.width, height: layoutHeight)

    let optimumRowHeight = getOptimumRowHeight(forView: superview)
    var currentY: CGFloat = 0
    for row in rows {
      row.frame = CGRect(
        x: 0,
        y: currentY,
        width: frame.size.width,
        height: optimumRowHeight)
      currentY += optimumRowHeight + style.rowPadding
    }
  }

  private func getOptimumRowHeight(forView view: UIView) -> CGFloat {
    let height = view.frame.size.height
    let rowPaddings = CGFloat(max(rows.count - 1, 0)) * style.rowPadding
    let totalPaddings = rowPaddings + style.topPadding + style.bottomPadding
    return max(0, (height - totalPaddings) / CGFloat(rows.count))
  }

  // MARK: Touch Handling
  public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesBegan(touches, withEvent: event)
    highlightButton(withTouches: touches)
  }

  public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesMoved(touches, withEvent: event)
    highlightButton(withTouches: touches)
  }

  public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    unhighlightButtons()
    for touch in touches {
      if let button = hitTest(touch.locationInView(self), withEvent: nil) as? KeyboardButton {
        delegate?.keyboardLayoutDidPressButton(self, keyboardButton: button)
      }
    }
  }

  public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    super.touchesCancelled(touches, withEvent: event)
    unhighlightButtons()
  }

  // MARK: Button Highlighting
  private func highlightButton(withTouches touches: Set<UITouch>) {
    for touch in touches {
      if let button = hitTest(touch.locationInView(self), withEvent: nil) as? KeyboardButton {
        for row in rows {
          row.highlightButton(button)
        }
      }
    }
  }

  private func unhighlightButtons() {
    for row in rows {
      row.unhighlightButtons()
    }
  }
}
