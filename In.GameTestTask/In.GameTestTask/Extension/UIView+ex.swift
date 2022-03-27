//
//  UIView+ex.swift
//  MeetMe
//
//  Created by Stas Dashkevich on 25.03.22.
//

import Foundation
import UIKit

extension UIView {
    
    func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
        let gradientView = GradientView(from: .top, to: .bottom, startColor: #colorLiteral(red: 0.9331739545, green: 0, blue: 0, alpha: 1), endColor: #colorLiteral(red: 0.8330358267, green: 0, blue: 1, alpha: 1))
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            gradientLayer.opacity = 0.65
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}
