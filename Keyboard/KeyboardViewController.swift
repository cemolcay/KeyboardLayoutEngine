//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Cem Olcay on 06/05/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
  @IBOutlet var nextKeyboardButton: UIButton!
  var keyboardHeight = CGFloat(260) { didSet { view.setNeedsUpdateConstraints() } }
  private weak var keyboardHeightConstraint: NSLayoutConstraint?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    keyboardHeightConstraint = NSLayoutConstraint(
      item: view!,
      attribute: .Height,
      relatedBy: .Equal,
      toItem: nil,
      attribute: .NotAnAttribute,
      multiplier: 1,
      constant: keyboardHeight)
    inputView?.addConstraint(keyboardHeightConstraint!)
  }

  override func updateViewConstraints() {
    super.updateViewConstraints()
    keyboardHeightConstraint?.constant = keyboardHeight
  }
}
