//
//  ColorScheme.swift
//  SavePlates
//
//  Created by Sam Roman on 12/19/19.
//  Copyright © 2019 Sam Roman. All rights reserved.
//

import Foundation
import UIKit

class ColorScheme {
  
  
  static func setUpBackgroundColor(_ view: UIView) {
    view.backgroundColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 250/255, alpha: 1)
    //Keppel
  }
  static func styleHeaderLabel(_ label: UILabel) {
    label.numberOfLines = 0
    label.textColor = UIColor(displayP3Red: 13/255, green: 92/255, blue: 99/255, alpha: 1)
    label.backgroundColor = .clear
    label.textAlignment = .center
  }
  
  static func styleLabel(_ label: UILabel) {
    label.numberOfLines = 0
    label.textColor = UIColor(displayP3Red: 13/255, green: 92/255, blue: 99/255, alpha: 1)
    label.backgroundColor = .clear
    label.textAlignment = .left
  }
  
  static func styleTextField(_ textfield: UITextField) {
    textfield.autocorrectionType = .no
    textfield.textAlignment = .left
    textfield.layer.cornerRadius = 15
    textfield.textColor = .black
    textfield.borderStyle = .roundedRect
    textfield.backgroundColor = .clear
  }
  
  static func styleHollowButton(_ button: UIButton) {
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 10
    button.backgroundColor = .clear
    button.layer.borderColor = UIColor(displayP3Red: 36/255, green: 123/255, blue: 123/255, alpha: 1).cgColor
  }
  
  
  static func styleFilledButton(_ button: UIButton) {
    button.layer.borderWidth = 2
    button.layer.cornerRadius = 10
    button.layer.borderColor = UIColor(displayP3Red: 120/255, green: 205/255, blue: 215/255, alpha: 1).cgColor
    button.backgroundColor = UIColor(displayP3Red: 120/255, green: 205/255, blue: 215/255, alpha: 1)
    button.setTitleColor(UIColor(displayP3Red: 255/255, green: 255/255, blue: 250/255, alpha: 1), for: .normal)
  }
  
}
