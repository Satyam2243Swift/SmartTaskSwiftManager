//
//  EventManager.swift
//  SmartSwiftTaskManager
//
//  Created by Satyam Dixit on 14/01/25.
//
import Foundation
import EventKit


protocol EventManagerProtocol {
    func addEventToCalendar(title: String, startDate: Date, endDate: Date, location: String?, notes: String?)
}

class EventManager: EventManagerProtocol {
    private let eventStore = EKEventStore()
    
    init() {
        eventStore.requestAccess(to: .event) { granted, error in
            if granted {
                print("Access granted to calendar")
            } else {
                print("Access denied to calendar")
            }
        }
    }

    func addEventToCalendar(title: String, startDate: Date, endDate: Date, location: String?, notes: String?) {
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.location = location
        event.notes = notes

        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            print("Event added to calendar!")
        } catch let error as NSError {
            print("Error adding event: \(error.localizedDescription)")
        }
    }
}
