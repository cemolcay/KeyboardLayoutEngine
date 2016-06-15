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
  // Key Press Events
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didKeyPressStart keyboardButton: KeyboardButton)
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didKeyPressEnd keyboardButton: KeyboardButton)
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didDraggedIn fromKeyboardButton: KeyboardButton, toKeyboardButton: KeyboardButton)
  // Touch Events
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesBegin touches: Set<UITouch>)
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesMove touches: Set<UITouch>)
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesEnd touches: Set<UITouch>?)
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesCancel touches: Set<UITouch>?)
}

// MARK: - KeyboardLayoutStyle
public struct KeyboardLayoutStyle {
  public var topPadding: CGFloat
  public var bottomPadding: CGFloat
  public var rowPadding: CGFloat
  public var rowPaddingLandscape: CGFloat
  public var backgroundColor: UIColor

  public init(
    topPadding: CGFloat? = nil,
    bottomPadding: CGFloat? = nil,
    rowPadding: CGFloat? = nil,
    rowPaddingLandscape: CGFloat? = nil,
    backgroundColor: UIColor? = nil) {
    self.topPadding = topPadding ?? 10
    self.bottomPadding = bottomPadding ?? 4
    self.rowPadding = rowPadding ?? 12
    self.rowPaddingLandscape = rowPaddingLandscape ?? 6
    self.backgroundColor = backgroundColor ?? UIColor(red: 208.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)
  }
}

// MARK: - KeyboardLayout
public class KeyboardLayout: UIView {
  public var style: KeyboardLayoutStyle!
  public var rows: [KeyboardRow]!

  public weak var delegate: KeyboardLayoutDelegate?

  private var isPortrait: Bool {
    return UIScreen.mainScreen().bounds.size.width < UIScreen.mainScreen().bounds.size.height
  }

  public var typingEnabled: Bool = true
  private var currentlyPressingKeyboardButton: KeyboardButton? {
    didSet {
      oldValue?.showKeyPop(show: false)
      currentlyPressingKeyboardButton?.showKeyPop(show: true)
    }
  }

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
      row.isPortrait = isPortrait
      row.frame = CGRect(
        x: 0,
        y: currentY,
        width: frame.size.width,
        height: optimumRowHeight)
      currentY += optimumRowHeight + getRowPadding(forRow: row)
    }
  }

  private func getRowPadding(forRow row: KeyboardRow) -> CGFloat {
    return isPortrait ? row.style.bottomPadding ?? style.rowPadding : row.style.bottomPaddingLandscape ?? row.style.bottomPadding ?? style.rowPaddingLandscape
  }

  private func getRowPaddings() -> CGFloat {
    var total = CGFloat(0)
    for row in rows {
      if row == rows.last { break }
      total = total + getRowPadding(forRow: row)
    }
    return total
  }

  private func getOptimumRowHeight(forView view: UIView) -> CGFloat {
    let height = view.frame.size.height
    let totalPaddings = getRowPaddings() + style.topPadding + style.bottomPadding
    return max(0, (height - totalPaddings) / CGFloat(rows.count))
  }

  // MARK: Manage Buttons
  public func getKeyboardButton(atRowIndex rowIndex: Int, buttonIndex: Int) -> KeyboardButton? {
    if let row = rows[safe: rowIndex], let button = row.characters[safe: buttonIndex] as? KeyboardButton {
      return button
    }
    return nil
  }

  public func getKeyboardButton(withIdentifier identifier: String) -> KeyboardButton? {
    for row in rows {
      for button in row.characters {
        if let button = button as? KeyboardButton where button.identifier == identifier {
          return button
        }
      }
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
    delegate?.keyboardLayout?(self, didTouchesBegin: touches)

    if !typingEnabled {
      return
    }

    for (index, touch) in touches.enumerate() {
      if let button = hitTest(touch.locationInView(self), withEvent: nil) as? KeyboardButton {
        if index == touches.count - 1 {
          currentlyPressingKeyboardButton = button
        }
        delegate?.keyboardLayout?(self, didKeyPressStart: button)
      }
    }
  }

  public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesMoved(touches, withEvent: event)
    delegate?.keyboardLayout?(self, didTouchesMove: touches)

    if !typingEnabled {
      return
    }

    // Check the first touch moving
    if let touch = touches.first {
      if let button = hitTest(touch.locationInView(self), withEvent: nil) as? KeyboardButton {
        // Do nothing if still pressing the same button
        if currentlyPressingKeyboardButton == button {
          return
        }
        // set current button
        if let oldButton = currentlyPressingKeyboardButton {
          delegate?.keyboardLayout?(self, didDraggedIn: oldButton, toKeyboardButton: button)
        }
        currentlyPressingKeyboardButton = button
      }
    }
  }

  public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    delegate?.keyboardLayout?(self, didTouchesEnd: touches)

    if !typingEnabled {
      return
    }

    currentlyPressingKeyboardButton = nil
    for touch in touches {
      if let button = hitTest(touch.locationInView(self), withEvent: nil) as? KeyboardButton {
        delegate?.keyboardLayout?(self, didKeyPressEnd: button)
      }
    }
  }

  public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    super.touchesCancelled(touches, withEvent: event)
    currentlyPressingKeyboardButton = nil
    delegate?.keyboardLayout?(self, didTouchesCancel: touches)
  }
}
