//
//  Extension + UIButton.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//

import UIKit

extension UIButton {
    
    // Customizable method for button creation
    func configureButton(
        title: String,
        titleColor: UIColor = .white,
        backgroundColor: UIColor = .systemBlue,
        cornerRadius: CGFloat = 30,
        image: UIImage? = UIImage(systemName: "plus"),
        font: UIFont = UIFont.boldSystemFont(ofSize: 16),
        action: Selector,
        target: Any
    ) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius
        self.setImage(image, for: .normal)
        self.tintColor = .white
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = font
        self.titleLabel?.textAlignment = .center
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        // Adjust the insets to ensure the image is on the left and text is right next to it
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 5

        // Add target for the action
        self.addTarget(target, action: action, for: .touchUpInside)
    }
}
