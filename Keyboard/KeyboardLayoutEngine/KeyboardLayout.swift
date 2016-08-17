//
//  KeyboardLayout.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


// MARK: - Array Extension
extension IndexableBase {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  public subscript(safe index: Index) -> _Element? {
    return index >= startIndex && index < endIndex ? self[index] : nil
  }
}

// MARK: - UITouch Extension
internal extension UITouch {
  internal var key: String {
    return "\(Unmanaged.passUnretained(self).toOpaque())"
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
  @objc optional func keyboardLayout(_ keyboardLayout: KeyboardLayout, didKeyPressStart keyboardButton: KeyboardButton)
  @objc optional func keyboardLayout(_ keyboardLayout: KeyboardLayout, didKeyPressEnd keyboardButton: KeyboardButton)
  @objc optional func keyboardLayout(_ keyboardLayout: KeyboardLayout, didDraggedInFrom oldKeyboardButton: KeyboardButton, to newKeyboardButton: KeyboardButton)
  // Touch Events
  @objc optional func keyboardLayout(_ keyboardLayout: KeyboardLayout, didTouchesBegin touches: Set<UITouch>)
  @objc optional func keyboardLayout(_ keyboardLayout: KeyboardLayout, didTouchesMove touches: Set<UITouch>)
  @objc optional func keyboardLayout(_ keyboardLayout: KeyboardLayout, didTouchesEnd touches: Set<UITouch>?)
  @objc optional func keyboardLayout(_ keyboardLayout: KeyboardLayout, didTouchesCancel touches: Set<UITouch>?)
}

// MARK: - KeyboardLayoutStyle
public struct KeyboardLayoutStyle {
  public var backgroundColor: UIColor

  public init(backgroundColor: UIColor? = nil) {
    self.backgroundColor = backgroundColor ?? UIColor(red: 208.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)
  }
}

// MARK: - KeyboardLayout
open class KeyboardLayout: UIView {
  open var style: KeyboardLayoutStyle!
  open var rows: [KeyboardRow]!

  open weak var delegate: KeyboardLayoutDelegate?

  fileprivate var isPortrait: Bool {
    return UIScreen.main.bounds.size.width < UIScreen.main.bounds.size.height
  }

  open var typingEnabled: Bool = true
  fileprivate var currentTouches: [KeyboardButtonTouch] = []

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
  open override func layoutSubviews() {
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

  fileprivate func getRowPaddings() -> CGFloat {
    var total = CGFloat(0)
    for row in rows {
      total += isPortrait ? row.style.topPadding + row.style.bottomPadding : row.style.topPaddingLandscape + row.style.bottomPaddingLandscape
    }
    return total
  }

  fileprivate func getOptimumRowHeight() -> CGFloat {
    let height = frame.size.height
    let totalPaddings = getRowPaddings()
    return max(0, (height - totalPaddings) / CGFloat(rows.count))
  }

  // MARK: Manage Buttons
  open func getKeyboardButton(atRowIndex rowIndex: Int, buttonIndex: Int) -> KeyboardButton? {
    if let row = rows[safe: rowIndex], let button = row.characters[safe: buttonIndex] as? KeyboardButton {
      return button
    }
    return nil
  }

  open func getKeyboardButton(withIdentifier identifier: String) -> KeyboardButton? {
    for row in rows {
      for button in row.characters {
        if let button = button as? KeyboardButton , button.identifier == identifier {
          return button
        }
      }
    }
    return nil
  }

  open func addKeyboardButton(keyboardButton button: KeyboardButton, rowAtIndex: Int, buttonIndex: Int?) {
    if let row = rows[safe: rowAtIndex] {
      if let index = buttonIndex , buttonIndex < row.characters.count {
        row.characters.insert(button, at: index)
      } else {
        row.characters.append(button)
      }
      row.addSubview(button)
    }
  }

  open func removeKeyboardButton(atRowIndex rowIndex: Int, buttonIndex: Int) -> Bool {
    if let row = rows[safe: rowIndex], let button = row.characters[safe: buttonIndex] {
      row.characters.remove(at: buttonIndex)
      button.removeFromSuperview()
      return true
    }
    return false
  }

  // MARK: Touch Handling
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    delegate?.keyboardLayout?(self, didTouchesBegin: touches)

    if !typingEnabled {
      return
    }

    // Add valid touches that hit a `KeyboardButton` to `currentTouches` dictionary
    for touch in touches {
      if let button = hitTest(touch.location(in: self), with: nil) as? KeyboardButton {
        if currentTouches.map({ $0.touch }).contains(touch.key) == false {
          currentTouches.append(KeyboardButtonTouch(touch: touch, button: button))
        }
      }
    }

    // Send key press start and end events ordered from current touches
    for (index, currentTouch) in currentTouches.enumerated() {
      if index == max(0, currentTouches.count - 1) {
        delegate?.keyboardLayout?(self, didKeyPressStart: currentTouch.button)
        currentTouch.button.showKeyPop(show: true)
      } else {
        delegate?.keyboardLayout?(self, didKeyPressEnd: currentTouch.button)
        currentTouch.button.showKeyPop(show: false)
      }
    }

    if currentTouches.count > 1 {
      currentTouches.removeSubrange(0..<max(0, currentTouches.count - 1))
    }
  }

  open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    delegate?.keyboardLayout?(self, didTouchesMove: touches)

    if !typingEnabled {
      return
    }

    for touch in touches {
      if let currentTouch = currentTouches.filter({ $0.touch == touch.key }).first,
         let button = hitTest(touch.location(in: self), with: nil) as? KeyboardButton {
        if currentTouch.button != button {
          delegate?.keyboardLayout?(self, didDraggedInFrom: currentTouch.button, to: button)
          currentTouch.button.showKeyPop(show: false)
          currentTouch.button = button
          currentTouch.button.showKeyPop(show: true)
        }
      }
    }
  }

  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
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

  open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    currentTouches.forEach({ $0.button.showKeyPop(show: false) })
    currentTouches = []
    delegate?.keyboardLayout?(self, didTouchesCancel: touches)
  }
}
