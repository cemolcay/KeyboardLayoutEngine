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

  init(
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

public protocol KeyboardLayuotDelegate: class {
  func keyboardLayoutDidPressButton(keyboardLayout: KeyboardLayout, keyboardButton: KeyboardButton)
}

public class KeyboardLayout: UIView {
  public var rows: [KeyboardRow]!
  public var style: KeyboardLayoutStyle!

  private var panGestureRecognizer: UIPanGestureRecognizer!
  private var tapGestureRecognizer: UITapGestureRecognizer!

  public weak var delegate: KeyboardLayuotDelegate?

  public init(rows: [KeyboardRow], style: KeyboardLayoutStyle) {
    super.init(frame: CGRect.zero)
    self.rows = rows
    self.style = style

    panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(KeyboardLayout.didPan(_:)))
    addGestureRecognizer(panGestureRecognizer)
    tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(KeyboardLayout.didTap(_:)))
    addGestureRecognizer(tapGestureRecognizer)

    for row in rows {
      addSubview(row)
    }
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

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

  public func didPan(pan: UIPanGestureRecognizer) {
    if pan == panGestureRecognizer {
      switch pan.state {
      case .Began, .Changed, .Ended:
        if let button = hitTest(pan.locationInView(self), withEvent: nil) as? KeyboardButton {
          for row in rows {
            row.highlightButton(button)
          }
          if pan.state == .Ended {
            button.highlighted = false
            delegate?.keyboardLayoutDidPressButton(self, keyboardButton: button)
          }
        }
        default:
          return
      }
    }
  }

  public func didTap(tap: UITapGestureRecognizer) {
    if tap == tapGestureRecognizer {
      if tap.state == .Ended {
        if let button = hitTest(tap.locationInView(self), withEvent: nil) as? KeyboardButton {
          button.highlighted = false
          delegate?.keyboardLayoutDidPressButton(self, keyboardButton: button)
        }
      }
    }
  }
}
