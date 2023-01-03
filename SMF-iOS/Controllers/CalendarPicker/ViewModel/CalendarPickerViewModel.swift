//
//  CalendarPickerViewModel.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 28/05/22.
//

import Foundation

protocol CalendarPickerViewModel {
    var businessValidityStartDate: Observable<Date?> { get }
    var businessValidityEndDate: Observable<Date?> { get }
    
    var calendarEvents: Observable<[CalendarEvent]> { get }
    var calendarEventLoading: Observable<Bool> { get }
    var calendarEventFetchError: Observable<String?> { get }
    
    var bookedSlots: Observable<[Event]> { get }
    var bookedSlotsLoading: Observable<Bool> { get }
    var bookedSlotsFetchError: Observable<String?> { get }
    
    var dayCount: Observable<Int> { get }
    var weekCount: Observable<Int> { get }
    var monthCount: Observable<Int> { get }
    
    func fetchBusinessValidity() 
    
    func fetchCalendarEvents(categoryId: Int?, onboardingVendorId: Int?, fromDate: Date?, toDate: Date?)
    func fetchBookedServiceSlots(calendarHeaderId: Int, categoryId: Int?, onboardingVendorId: Int?, fromDate: Date?, toDate: Date?)
    
    func fetchSlotsAvailability(calendarHeaderId: Int, categoryId: Int?, onboardingVendorId: Int?, fromDate: Date?, toDate: Date?, isMonth: Bool)
    func modifySlotAvailability(categoryId: Int?, onboardingVendorId: Int?, fromDate: Date?, toDate: Date?, fetchDataFor: FetchDataForSegment, isAvailable: Bool, modifiedSlot: String)
}
