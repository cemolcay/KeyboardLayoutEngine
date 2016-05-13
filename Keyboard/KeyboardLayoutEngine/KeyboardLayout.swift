//
//  KeyboardLayout.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

// MARK: - Array Extension
extension CollectionType {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Generator.Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

// MARK: - KeyboardLayoutDelegate
@objc public protocol KeyboardLayoutDelegate {
  optional func keyboardLayoutDidStartPressingButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton)
  optional func keyboardLayoutDidPressButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton)
}

// MARK: - KeyboardLayoutStyle
public struct KeyboardLayoutStyle {
  public var topPadding: CGFloat
  public var bottomPadding: CGFloat
  public var rowPadding: CGFloat
  public var rowPaddingLandscape: CGFloat
  public var backgroundColor: UIColor

  public init(
    topPadding: CGFloat = 5,
    bottomPadding: CGFloat = 5,
    rowPadding: CGFloat = 15,
    rowPaddingLandscape: CGFloat = 8,
    backgroundColor: UIColor = UIColor(red: 208.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)) {
    self.topPadding = topPadding
    self.bottomPadding = bottomPadding
    self.rowPadding = rowPadding
    self.rowPaddingLandscape = rowPaddingLandscape
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
      currentY += optimumRowHeight + getRowPadding()
    }
  }

  private func getOptimumRowHeight(forView view: UIView) -> CGFloat {
    let height = view.frame.size.height
    let rowPaddings = CGFloat(max(rows.count - 1, 0)) * getRowPadding()
    let totalPaddings = rowPaddings + style.topPadding + style.bottomPadding
    return max(0, (height - totalPaddings) / CGFloat(rows.count))
  }

  private func getRowPadding() -> CGFloat {
    return frame.size.width > frame.size.height ? style.rowPaddingLandscape : style.rowPadding
  }

  // MARK: Manage Buttons
  public func getKeyboardButton(atRowIndex rowIndex: Int, buttonIndex: Int) -> KeyboardButton? {
    if let row = rows[safe: rowIndex], let button = row.characters[safe: buttonIndex] as? KeyboardButton {
      return button
    }
    return nil
  }

  public func addKeyboardButton(keyboardButton button: KeyboardButton, rowAtIndex: Int, buttonIndex: Int?) {
    if let row = rows[safe: rowAtIndex] {
      if let index = buttonIndex where buttonIndex < row.characters.count {
        row.characters.insert(button, atIndex: index)
      } else {
        row.characters.append(button)
      }
      row.addSubview(button)
    }
  }

  public func removeKeyboardButton(atRowIndex rowIndex: Int, buttonIndex: Int) -> Bool {
    if let row = rows[safe: rowIndex], let button = row.characters[safe: buttonIndex] {
      row.characters.removeAtIndex(buttonIndex)
      button.removeFromSuperview()
      return true
    }
    return false
  }

  // MARK: Touch Handling
  public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesBegan(touches, withEvent: event)
    if let touch = touches.first {
      if let button = hitTest(touch.locationInView(self), withEvent: nil) as? KeyboardButton {
        for row in rows {
          row.highlightButton(button)
          delegate?.keyboardLayoutDidStartPressingButton?(self, keyboardButton: button)
        }
      }
    }
  }

  public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesMoved(touches, withEvent: event)
    if let touch = touches.first {
      if let button = hitTest(touch.locationInView(self), withEvent: nil) as? KeyboardButton {
        for row in rows {
          row.highlightButton(button)
        }
      }
    }
  }

  public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    for row in rows {
      row.unhighlightButtons()
    }
    if let touch = touches.first {
      if let button = hitTest(touch.locationInView(self), withEvent: nil) as? KeyboardButton {
        delegate?.keyboardLayoutDidPressButton?(self, keyboardButton: button)
      }
    }
  }

  public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    super.touchesCancelled(touches, withEvent: event)
    for row in rows {
      row.unhighlightButtons()
    }
  }
}
