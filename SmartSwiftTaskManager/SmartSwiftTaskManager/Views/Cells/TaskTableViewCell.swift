//
//  TaskTableViewCell.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//


import UIKit
import CoreData

class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskTableViewCell"
    
    private let titleLabel = UILabel()
    private let editButton = UIButton(type: .system)
    
    var editButtonAction: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = .systemFont(ofSize: 16)
        
        editButton.setTitle("Edit", for: .normal)
        editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        editButton.tintColor = .systemBlue
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        // Adjust the insets to place the pencil icon to the left of the text
        editButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)  // Optional: Adjust spacing between icon and text
        editButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, editButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.alignment = .center
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // Set up the cell with task data
    func configure(with task: NSManagedObject) {
        titleLabel.text = task.value(forKey: "title") as? String
    }
    
    @objc private func editButtonTapped() {
        editButtonAction?()
    }
}
