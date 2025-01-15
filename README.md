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




Upcoming Features:

Synchronization of tasks from the calendar to Core Data.
Display task priorities in the user interface.
Further code enhancements for performance optimization and better maintainability.


