//
//  TaskListViewController.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//


import UIKit

class TaskListViewController: UIViewController {
    
    private var viewModel: TaskListViewModel!
    private let tableView = UITableView()
    let addButton = UIButton()
    let toggleButton = UIButton()
    
    private var isDarkMode: Bool {
        get {
            // Retrieve the dark mode preference from UserDefaults
            return UserDefaults.standard.bool(forKey: "isDarkMode")
        }
        set {
            // Save the preference to UserDefaults
            UserDefaults.standard.set(newValue, forKey: "isDarkMode")
        }
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TaskListViewModel(coreDataManager: CoreDataManager.shared)
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTasks() // Fetch tasks each time view appears
    }
    
    private func setupUI() {
        setupNavigationBar()
        
        // Add table view
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 12
        tableView.clipsToBounds = true
        tableView.backgroundColor = .systemGray6
        
        // Configure the Add Task button using the extension
        addButton.configureButton(
            title: "Add Task",
            backgroundColor: .systemBlue,
            action: #selector(didTapAddButton),
            target: self
        )
        
        // Configure the Toggle Dark Mode button using the extension
        let toggleButton = UIButton(type: .system)
        let currentImage = (UITraitCollection.current.userInterfaceStyle == .dark)
                ? UIImage(systemName: "moon.fill")  // Dark mode - Moon
                : UIImage(systemName: "sun.max.fill") // Light mode - Sun
        
        toggleButton.configureButton(
            title: "Change Mode",
            backgroundColor: .systemGray,
            image: currentImage,
            font: UIFont.boldSystemFont(ofSize: 12),
            action: #selector(didTapToggleDarkMode),
            target: self
        )
        
        
        // Add Add Task button to the view
        view.addSubview(addButton)
        
        // Set constraints for the Add Task button (bottom-right)
        NSLayoutConstraint.activate([
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.widthAnchor.constraint(equalToConstant: 160),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
//        // Add Toggle Dark Mode button to the view
//        view.addSubview(toggleButton)
//        
//        // Set constraints for the Toggle Dark Mode button (bottom-left)
//        toggleButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            toggleButton.heightAnchor.constraint(equalToConstant: 60),
//            toggleButton.widthAnchor.constraint(equalToConstant: 160),
//            toggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            toggleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
//        ])
    }

    private func setupNavigationBar() {
        navigationItem.title = "Task List"
        let titleLabel = UILabel()
        titleLabel.text = "Tasks"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Manage your tasks efficiently"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = stackView
        
        navigationController?.navigationBar.barTintColor = .systemOrange
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    @objc private func didTapToggleDarkMode() {
        // Toggle the dark mode setting
        isDarkMode.toggle()

        // Apply the new user interface style globally
        if isDarkMode {
            // Apply dark mode for all scenes
            if let window = self.view.window {
                window.overrideUserInterfaceStyle = .dark
            }
        } else {
            // Apply light mode for all scenes
            if let window = self.view.window {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    
    
    private func fetchTasks() {
        viewModel.fetchTasks { [weak self] in
            self?.tableView.reloadData() // Reload table data after fetching tasks
        }
    }
    
    @objc private func didTapAddButton() {
        let addTaskVC = AddTaskViewController()
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
}

extension TaskListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count // Display tasks from ViewModel
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.identifier, for: indexPath) as! TaskTableViewCell
        let task = viewModel.tasks[indexPath.row]
        cell.configure(with: task)
        
        // Edit button action
        cell.editButtonAction = { [weak self] in
            self?.editTask(at: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskDetail(at: indexPath)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = viewModel.tasks[indexPath.row]
            CoreDataManager.shared.deleteTask(task)
            fetchTasks()
        }
    }
    
    private func editTask(at indexPath: IndexPath) {
        let task = viewModel.tasks[indexPath.row]
        let addTaskVC = AddTaskViewController()
        addTaskVC.taskToEdit = task // Pass task for editing
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
    
    private func taskDetail(at indexPath: IndexPath) {
        let task = viewModel.tasks[indexPath.row]
        let taskDetailVC = TaskDetailViewController()
        taskDetailVC.task = task
        navigationController?.pushViewController(taskDetailVC, animated: true)
    }


}


extension TaskListViewController {
    // UITraitChangeObservable method to handle changes
      func traitDidChange(from oldTraits: UITraitCollection?, to newTraits: UITraitCollection?) {
          if let newTraits = newTraits {
              if newTraits.userInterfaceStyle == .dark {
                  // Respond to dark mode
                  print("Switched to Dark Mode")
              } else {
                  // Respond to light mode
                  print("Switched to Light Mode")
              }
          }
      }
}