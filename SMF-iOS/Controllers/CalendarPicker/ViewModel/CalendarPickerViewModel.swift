//
//  CalendarPickerViewModel.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 28/05/22.
//

import Foundation

protocol CalendarPickerViewModel {
    var calendarEvents: Observable<[CalendarEvent]> { get }
    var calendarEventLoading: Observable<Bool> { get }
    var calendarEventFetchError: Observable<String?> { get }
    
    var bookedSlots: Observable<[Event]> { get }
    var bookedSlotsLoading: Observable<Bool> { get }
    var bookedSlotsFetchError: Observable<String?> { get }
    
    var dayCount: Observable<Int> { get }
    var weekCount: Observable<Int> { get }
    var monthCount: Observable<Int> { get }
    
    func fetchCalendarEvents(categoryId: Int?, onboardingVendorId: Int?, fromDate: Date?, toDate: Date?)
    func fetchBookedServiceSlots(calendarHeaderId: Int, categoryId: Int?, onboardingVendorId: Int?, fromDate: Date?, toDate: Date?)
}

struct CalendarEvent {
    var date: Date
}

struct BookedSlot: Decodable, Event {
    var parentId: Int = -1
    var serviceSlot: String
    var slotEventDetails: [BookedSlotEventDetail]?
    var isLast = false
    
    enum CodingKeys: String, CodingKey {
        case serviceSlot, bookedEventServiceDtos
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        serviceSlot = try container.decode(String.self, forKey: .serviceSlot)
        slotEventDetails = try? container.decode([BookedSlotEventDetail].self, forKey: .bookedEventServiceDtos)
    }
}

struct EmptyData: Event {
    var title: String = ""
    var parentId: Int = -1
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
