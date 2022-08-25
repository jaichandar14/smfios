//
//  CalendarModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 6/29/22.
//

import Foundation

struct CalendarEvent {
    var date: Date
}

class BookedSlot: Decodable, Event {
    var parentId: Int = -1
    var serviceSlot: String
    var slotEventDetails: [BookedSlotEventDetail]?
    var isLast = false
    
    enum CodingKeys: String, CodingKey {
        case serviceSlot, bookedEventServiceDtos
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        serviceSlot = try container.decode(String.self, forKey: .serviceSlot)
        slotEventDetails = try? container.decode([BookedSlotEventDetail].self, forKey: .bookedEventServiceDtos)
    }
}

class SlotAvailability: Event {
    var parentId: Int = -1
    var serviceSlot: String
    var isAvailable: Bool
    var isLast = false
    var slotEvents: [SlotEvent] = []
    
    var fromDate: Date!
    var toDate: Date!
    
    init(serviceSlot: String, isAvailable: Bool) {
        self.serviceSlot = serviceSlot
        self.isAvailable = isAvailable
    }
}

class SlotEvent {
    var eventName: String
    var eventDate: String
    var branchName: String
//    var preferrentSlots:
    
    init(eventName: String, eventDate: String, branchName: String) {
        self.eventName = eventName
        self.eventDate = eventDate
        self.branchName = branchName
    }
}

class EmptyData: Event {
    var title: String = ""
    var parentId: Int = -1
    
    init(title: String, parentId: Int) {
        self.title = title
        self.parentId = parentId
    }
}

struct BookedSlotEventDetail: Decodable {
    var branchName: String
    var eventName: String
    var eventDate: String
    var preferredSlots: [String]?

    enum CodingKeys: String, CodingKey {
        case branchName, eventName, eventDate, preferredSlots
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        branchName = try container.decode(String.self, forKey: .branchName)
        eventName = try container.decode(String.self, forKey: .eventName)
        eventDate = try container.decode(String.self, forKey: .eventDate)
        preferredSlots = try? container.decode([String].self, forKey: .preferredSlots)
    }
}
