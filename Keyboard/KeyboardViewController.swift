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

  override func updateViewConstraints() {
      super.updateViewConstraints()
  
      // Add custom view sizing constraints here
  }

  override func viewDidLoad() {
      super.viewDidLoad()
  
      // Perform custom UI setup here
      self.nextKeyboardButton = UIButton(type: .System)
  
      self.nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
      self.nextKeyboardButton.sizeToFit()
      self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
  
      self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
      
      self.view.addSubview(self.nextKeyboardButton)
  
      self.nextKeyboardButton.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor).active = true
      self.nextKeyboardButton.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated
  }

  override func textWillChange(textInput: UITextInput?) {
      // The app is about to change the document's contents. Perform any preparation here.
  }

  override func textDidChange(textInput: UITextInput?) {
      // The app has just changed the document's contents, the document context has been updated.
  
      var textColor: UIColor
      let proxy = self.textDocumentProxy
      if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
          textColor = UIColor.whiteColor()
      } else {
          textColor = UIColor.blackColor()
      }
      self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
  }

}
