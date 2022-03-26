//
//  TextFieldHideKeyboard+Extension.swift
//  In.GameTestTask
//
//  Created by Stas Dashkevich on 25.03.22.
//

import Foundation
import UIKit

extension ViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        if self.searchTextField.text == "" {
            self.searchTextField.placeholder = "Coctail name"
        }
    }
}
