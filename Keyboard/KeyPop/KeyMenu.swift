//
//  KeyMenu.swift
//  KeyboardLayoutEngine
//
//  Created by Cem Olcay on 05/06/16.
//  Copyright © 2016 Prototapp. All rights reserved.
//

import UIKit

public enum KeyMenuType {
  case Horizontal
  case Vertical
}

public struct KeyMenuStyle {
  public var backgroundColor: UIColor


  init(backgroundColor: UIColor? = nil) {
    self.backgroundColor = backgroundColor ?? UIColor.grayColor()
  }
}

class KeyMenu: UIView {


}
