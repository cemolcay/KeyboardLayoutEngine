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

// MARK: - UITouch Extension
internal extension UITouch {
  internal var key: String {
    return "\(unsafeAddressOf(self))"
  }
}

// MARK: - KeyboardButtonTouch
internal class KeyboardButtonTouch {
  internal var touch: String
  internal var button: KeyboardButton

  internal init(touch: UITouch, button: KeyboardButton) {
    self.touch = touch.key
    self.button = button
  }
}

// MARK: - KeyboardLayoutDelegate
@objc public protocol KeyboardLayoutDelegate {
  // Key Press Events
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didKeyPressStart keyboardButton: KeyboardButton)
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didKeyPressEnd keyboardButton: KeyboardButton)
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didDraggedInFrom oldKeyboardButton: KeyboardButton, to newKeyboardButton: KeyboardButton)
  // Touch Events
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesBegin touches: Set<UITouch>)
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesMove touches: Set<UITouch>)
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesEnd touches: Set<UITouch>?)
  optional func keyboardLayout(keyboardLayout: KeyboardLayout, didTouchesCancel touches: Set<UITouch>?)
}

// MARK: - KeyboardLayoutStyle
public struct KeyboardLayoutStyle {
  public var backgroundColor: UIColor

  public init(backgroundColor: UIColor? = nil) {
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
  private var currentTouches: [KeyboardButtonTouch] = []

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
    superview?.backgroundColor = style.backgroundColor

    let optimumRowHeight = getOptimumRowHeight()
    var currentY: CGFloat = 0
    for row in rows {
      row.isPortrait = isPortrait
      currentY += isPortrait ? row.style.topPadding : row.style.topPaddingLandscape
      row.frame = CGRect(
        x: 0,
        y: currentY,
        width: frame.size.width,
        height: optimumRowHeight)
      currentY += optimumRowHeight + (isPortrait ? row.style.bottomPadding : row.style.bottomPaddingLandscape)
    }
  }

  private func getRowPaddings() -> CGFloat {
    var total = CGFloat(0)
    for row in rows {
      total += isPortrait ? row.style.topPadding + row.style.bottomPadding : row.style.topPaddingLandscape + row.style.bottomPaddingLandscape
    }
    return total
  }

  private func getOptimumRowHeight() -> CGFloat {
    let height = frame.size.height
    let totalPaddings = getRowPaddings()
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

    // Add valid touches that hit a `KeyboardButton` to `currentTouches` dictionary
    for touch in touches {
      if let button = hitTest(touch.locationInView(self), withEvent: nil) as? KeyboardButton {
        if currentTouches.map({ $0.touch }).contains(touch.key) == false {
          currentTouches.append(KeyboardButtonTouch(touch: touch, button: button))
        }
      }
    }

    // Send key press start and end events ordered from current touches
    for (index, currentTouch) in currentTouches.enumerate() {
      if index == max(0, currentTouches.count - 1) {
        delegate?.keyboardLayout?(self, didKeyPressStart: currentTouch.button)
        currentTouch.button.showKeyPop(show: true)
      } else {
        delegate?.keyboardLayout?(self, didKeyPressEnd: currentTouch.button)
        currentTouch.button.showKeyPop(show: false)
      }
    }

    if currentTouches.count > 1 {
      currentTouches.removeRange(0..<max(0, currentTouches.count - 1))
    }
  }

  public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesMoved(touches, withEvent: event)
    delegate?.keyboardLayout?(self, didTouchesMove: touches)

    if !typingEnabled {
      return
    }

    for touch in touches {
      if let currentTouch = currentTouches.filter({ $0.touch == touch.key }).first,
         button = hitTest(touch.locationInView(self), withEvent: nil) as? KeyboardButton {
        if currentTouch.button != button {
          delegate?.keyboardLayout?(self, didDraggedInFrom: currentTouch.button, to: button)
          currentTouch.button.showKeyPop(show: false)
          currentTouch.button = button
          currentTouch.button.showKeyPop(show: true)
        }
      }
    }
  }

  public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    super.touchesEnded(touches, withEvent: event)
    delegate?.keyboardLayout?(self, didTouchesEnd: touches)

    if !typingEnabled {
      return
    }

    for touch in touches {
      if let currentTouch = currentTouches.filter({ $0.touch == touch.key }).first {
        currentTouch.button.showKeyPop(show: false)
        delegate?.keyboardLayout?(self, didKeyPressEnd: currentTouch.button)
        currentTouches = currentTouches.filter({ $0.touch != touch.key })
      }
    }
  }

  public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
    super.touchesCancelled(touches, withEvent: event)
    currentTouches.forEach({ $0.button.showKeyPop(show: false) })
    currentTouches = []
    delegate?.keyboardLayout?(self, didTouchesCancel: touches)
  }
}
