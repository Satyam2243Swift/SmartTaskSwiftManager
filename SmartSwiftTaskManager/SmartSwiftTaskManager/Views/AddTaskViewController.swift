//
//  AddTaskViewController.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//


import UIKit
import CoreLocation
import CoreData
import EventKit

class AddTaskViewController: UIViewController {
    
    var taskToEdit: NSManagedObject?
    private var viewModel: AddTaskViewModel! // ViewModel for Add Task
    private var locationManager: LocationManager!
    private var eventManager: EventManager!
    
    private let titleField = UITextField()
    private let descriptionField = UITextView()
    private let dueDatePicker = UIDatePicker()
    private let prioritySegment = UISegmentedControl(items: ["High", "Medium", "Low"])
    private let locationLabel = UILabel() // To show the location
    private let fetchLocationButton = UIButton(type: .system) // To trigger fetching the location
    private let saveButton = UIButton(type: .system)
    private var taskLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Initialize ViewModel with task if it exists
        viewModel = AddTaskViewModel(coreDataManager: CoreDataManager.shared, task: taskToEdit)
        
        // Initialize LocationManager and EventManager
        locationManager = LocationManager()
        eventManager = EventManager()
        
        // If editing, populate the fields with existing task data
        if let task = taskToEdit {
            populateFields(with: task)
        }
    }
    
    private func setupUI() {
        // Set up UI elements like text fields, picker, etc.
        view.backgroundColor = .white
        
        titleField.placeholder = "Task Title"
        descriptionField.setBorderAndCornerRadius(borderColor: .gray, borderWidth: 1.0, cornerRadius: 8.0)
        descriptionField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let stackView = UIStackView(arrangedSubviews: [locationLabel, titleField, descriptionField, dueDatePicker, prioritySegment, fetchLocationButton, saveButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Add height constraint for the descriptionField (UITextView)
        descriptionField.heightAnchor.constraint(equalToConstant: 120).isActive = true
        prioritySegment.selectedSegmentIndex = 1
        
        saveButton.setTitle(taskToEdit == nil ? "Save Task" : "Save Changes", for: .normal)
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        
        locationLabel.text = "Location: Not set"
        fetchLocationButton.setTitle("Fetch Current Location", for: .normal)
        fetchLocationButton.addTarget(self, action: #selector(fetchCurrentLocation), for: .touchUpInside)
    }
    
    // Populate the fields for editing
    private func populateFields(with task: NSManagedObject) {
        // Set Title field with "Title: " label
        titleField.text = "Title: " + (task.value(forKey: "title") as? String ?? "Untitled")

        // Set Description field with "Desc: " label
        descriptionField.text = "Desc: " + (task.value(forKey: "taskDescription") as? String ?? "No description available")

        // Set Due Date field
        if let dueDate = task.value(forKey: "dueDate") as? Date {
            dueDatePicker.date = dueDate
        }

        // Set Priority field (assuming you have a segmented control for priority)
        if let priority = task.value(forKey: "priority") as? String {
            prioritySegment.selectedSegmentIndex = priority == "High" ? 0 : (priority == "Medium" ? 1 : 2)
        }

    }
    
    @objc private func fetchCurrentLocation() {
        locationManager.fetchCurrentLocation { [weak self] location in
            guard let self = self, let location = location else { return }
            self.reverseGeocodeLocation(location)
        }
    }
    
    private func reverseGeocodeLocation(_ location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first, error == nil else { return }
            if let city = placemark.locality {
                self.taskLocation = city
                DispatchQueue.main.async {
                    self.locationLabel.text = "Location: \(city)"
                }
            }
        }
    }
    
    @objc private func didTapSaveButton() {
        guard let title = titleField.text, !title.isEmpty else { return }
        
//        let updatedPriority = prioritySegment.titleForSegment(at: prioritySegment.selectedSegmentIndex) ?? "Medium"
        let updatedPriority = (prioritySegment.selectedSegmentIndex >= 0 && prioritySegment.selectedSegmentIndex < prioritySegment.numberOfSegments)
            ? prioritySegment.titleForSegment(at: prioritySegment.selectedSegmentIndex) ?? "Medium"
            : "Medium"

        let updatedDescription = descriptionField.text
        let updatedDueDate = dueDatePicker.date
        let location = taskLocation ?? "No location"
        
        // Use ViewModel to save or update task
        viewModel.saveTask(title: title, description: updatedDescription ?? "", dueDate: updatedDueDate, priority: updatedPriority, location: location)
        
        // Add event to calendar
        eventManager.addEventToCalendar(title: title, startDate: updatedDueDate, endDate: updatedDueDate.addingTimeInterval(60 * 60), location: location, notes: updatedDescription)
        
        navigationController?.popToRootViewController(animated: true)
        
    }
}