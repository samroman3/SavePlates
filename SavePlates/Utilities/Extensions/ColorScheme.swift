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
        view.backgroundColor = UIColor(displayP3Red: 120/255, green: 205/255, blue: 215/255, alpha: 1)
        //baby powder white
    }
    static func styleHeaderLabel(_ label: UILabel) {
        label.numberOfLines = 0
        label.textColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 250/255, alpha: 1)
        label.backgroundColor = .clear
        label.textAlignment = .center
    }
    
    static func styleTextField(_ textfield: UITextField) {
        textfield.autocorrectionType = .no
        textfield.textAlignment = .left
        textfield.layer.cornerRadius = 15
        textfield.textColor = .black
        textfield.borderStyle = .roundedRect
    }
    
    static func styleHollowButton(_ button: UIButton) {
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor(displayP3Red: 36/255, green: 123/255, blue: 123/255, alpha: 1).cgColor
    }
    
    
    
}
