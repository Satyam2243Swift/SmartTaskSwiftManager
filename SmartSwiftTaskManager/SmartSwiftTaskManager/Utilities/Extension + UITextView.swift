//
//  Extension + UITextView.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//

import UIKit

extension UITextView {
    func setBorderAndCornerRadius(borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
