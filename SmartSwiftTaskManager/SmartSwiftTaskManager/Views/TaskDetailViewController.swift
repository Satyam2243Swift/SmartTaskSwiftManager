//
//  TaskDetailViewController.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//



import UIKit
import CoreData

class TaskDetailViewController: UIViewController {

    var task: NSManagedObject?  // Task to display
    
    // UI Elements
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let locationLabel = UILabel()
    private let editButton = UIButton(type: .system)
    private let deleteButton = UIButton(type: .system)

    private var viewModel: AddTaskViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        // Initialize the ViewModel with the CoreDataManager
        viewModel = AddTaskViewModel(coreDataManager: CoreDataManager.shared, task: task)
        
        // Display task details
        if let task = task {
            locationLabel.text = "Location: " + (task.value(forKey: "location") as? String ?? "N/A")
            titleLabel.text = "Title: " + (task.value(forKey: "title") as? String ?? "Untitled")
            descriptionLabel.text = "Desc: " + (task.value(forKey: "taskDescription") as? String ?? "No description available")

        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        
        // Title Label
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        // Description Label
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .gray
        descriptionLabel.textAlignment = .center
        
        // Location Label
        locationLabel.font = UIFont.systemFont(ofSize: 18)
        locationLabel.numberOfLines = 0
        locationLabel.textColor = .green
        locationLabel.textAlignment = .center
        
        // StackView to arrange UI elements (Title, Description, Location Labels)
        let stackView = UIStackView(arrangedSubviews: [locationLabel, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        // Layout constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Edit Button
        editButton.setTitle("Edit Task", for: .normal)
        editButton.addTarget(self, action: #selector(didTapEditButton), for: .touchUpInside)
        
        // Delete Button
        deleteButton.setTitle("Delete Task", for: .normal)
        deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        // Add buttons directly to the view
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        
        // Layout constraints for the Edit Button (Bottom-left corner)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            editButton.widthAnchor.constraint(equalToConstant: 150) // Adjust width if needed
        ])
        
        // Layout constraints for the Delete Button (Bottom-right corner)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.widthAnchor.constraint(equalToConstant: 150) // Adjust width if needed
        ])
    }


    // MARK: - Button Actions

    @objc private func didTapEditButton() {
        guard let task = task else { return }
        
        // Navigate to AddTaskViewController to edit the task
        let addTaskVC = AddTaskViewController()
        addTaskVC.taskToEdit = task
        navigationController?.pushViewController(addTaskVC, animated: true)
    }

    @objc private func didTapDeleteButton() {
        // Show confirmation alert before deleting
        let alertController = UIAlertController(
            title: "Delete Task",
            message: "Are you sure you want to delete this task?",
            preferredStyle: .alert
        )

        // Delete action
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteTask()
        }
        
        // Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Task Deletion

    private func deleteTask() {
        guard let task = task else { return }
        
        // Delete task from CoreData
        CoreDataManager.shared.deleteTask(task)
        
        // Pop the view controller after deletion
        navigationController?.popViewController(animated: true)
    }
}
