# SmartTaskSwiftManager
By This App you can manage your tasks, based on your calender and locations. also you can add your tasks as Event in calender.

Features Implemented:

Task List:
Created a Task List view to display and fetch tasks.
Added functionality for users to add new tasks.

Date & Time Selection:
When adding a task, users can choose a specific date and time from a calendar interface.
The app requests permission to access the calendar to allow event creation.


Location Permission:
Users are prompted to grant location access when adding a task with a location.


Core Data Integration:
On saving a task, the task is added to Core Data for persistent storage.


Task Management (Edit/Delete):
From the Home screen, users can delete or edit tasks.


Task Editing:
Users are able to update or modify existing tasks by tapping on the edit option.


Task Detail Screen:
A separate TaskDetail screen is provided where users can view detailed information about the task.
On this screen, users have the ability to edit or delete tasks.





Development Practices:

UI Implementation:
The entire user interface is implemented programmatically, with no use of Interface Builder (Storyboard or XIBs), providing a more flexible and scalable UI setup.

Dependency Injection:
Followed Dependency Injection to manage dependencies and enhance code modularity and testability.

Protocols and Delegates:
Utilized protocols and delegates for effective communication between components and to ensure loose coupling.








Upcoming Features & Enhancements:


Dark/Light Mode:
Dark and Light mode support has been added to the application.
Currently, this feature is hidden as additional work is required to ensure that the mode switching doesn’t negatively impact other UI elements.
Future updates will fully enable Dark/Light mode after completing necessary adjustments and testing across the UI to ensure consistency and usability.


Calendar Sync:
Synchronization of tasks from the calendar to Core Data.


Priority Display:
Task priorities will be visually represented in the UI.


Code Enhancements:
Ongoing work to improve performance, scalability, and code maintainability.
