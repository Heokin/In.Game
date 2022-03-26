//
//  TextFeild+Extension.swift
//  In.GameTestTask
//
//  Created by Stas Dashkevich on 25.03.22.
//

import Foundation
import UIKit

extension UITextField {
    convenience init(placeholder: String,
                     cornerRaduis: CGFloat = 9,
                     isShadow: Bool = true,
                     textColor: UIColor = .systemGray,
                     textAlignment: NSTextAlignment = .center) {
        
        self.init()
        self.textColor = textColor
        self.placeholder = placeholder
        self.layer.cornerRadius = cornerRaduis
        self.textAlignment = textAlignment
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 15
            self.layer.shadowOffset = CGSize(width: 0, height: 6)
        }
    }
}
