//
//  CalendarPickerViewModelContainer.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 28/05/22.
//

import Foundation

class CalendarPickerViewModelContainer: CalendarPickerViewModel {

    
    var calendarEvents: Observable<[CalendarEvent]>
    var calendarEventLoading: Observable<Bool>
    var calendarEventFetchError: Observable<String?>
    
    var bookedSlots: Observable<[Event]>
    var bookedSlotsLoading: Observable<Bool>
    var bookedSlotsFetchError: Observable<String?>
    
    var dayCount: Observable<Int>
    var weekCount: Observable<Int>
    var monthCount: Observable<Int>
    
    init() {
        self.calendarEvents = Observable<[CalendarEvent]>([])
        self.calendarEventLoading = Observable<Bool>(false)
        self.calendarEventFetchError = Observable<String?>("")
        
        self.bookedSlots = Observable<[Event]>([])
        self.bookedSlotsLoading = Observable<Bool>(false)
        self.bookedSlotsFetchError = Observable<String?>("")
        
        self.dayCount = Observable<Int>(0)
        self.weekCount = Observable<Int>(0)
        self.monthCount = Observable<Int>(0)
    }
    
    func fetchCalendarEvents(categoryId: Int?, onboardingVendorId: Int?, fromDate: Date?, toDate: Date?) {
        self.calendarEventLoading.value = true

//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.calendarEventLoading.value = false
//            var dates: [CalendarEvent] = []
//            ["06/03/2022", "06/13/2022", "06/18/2022", "06/24/2022", "06/28/2022"].forEach { dateStr in
//                dates.append(CalendarEvent(date: dateStr.convertToDate()!))
//            }
//            self.calendarEvents.value = dates
//        }
//
//        return
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
            
            var params: [String: Any] = [:]
            if let id = categoryId {
                params[APIConstant.serviceCategoryId] = id
            }
            if let id = onboardingVendorId {
                params[APIConstant.serviceVendorOnboardingId] = id
            }
            if let date = fromDate {
                params[APIConstant.fromDate] = date.toString(with: "MM/dd/yyyy")
            }
            if let date = toDate {
                params[APIConstant.toDate] = date.toString(with: "MM/dd/yyyy")
            }
            
            let url = APIConfig.calendarEvents + "/\(AmplifyLoginUtility.user!.spRegId)"
            APIManager().executeDataRequest(id: "BidOrderInfo", url: url, method: .GET, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
                
                self.calendarEventLoading.value = false
                switch result {
                case true:
                    
                    if let respData = response?["data"] as? [String: Any] {
                        if let array = respData["serviceDates"] as? [String] {
                            var dates: [CalendarEvent] = []
                            array.forEach { dateStr in
                                if let date = dateStr.convertToDate() {
                                    dates.append(CalendarEvent(date: date))
                                }
                            }
                            self.calendarEvents.value = dates
                        }
                        
                        if let dayCount = respData["dayCount"] as? Int {
                            self.dayCount.value = dayCount
                        }
                        
                        if let weekCount = respData["weekCount"] as? Int {
                            self.weekCount.value = weekCount
                        }
                        
                        if let monthCount = respData["monthcount"] as? Int {
                            self.monthCount.value = monthCount
                        }
                        
                    } else {
                        self.calendarEventFetchError.value = "Data could not be parsed"
                    }
                case false:
                    self.calendarEventFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
                }
            }
        }
    }
    
    func fetchBookedServiceSlots(calendarHeaderId: Int, categoryId: Int?, onboardingVendorId: Int?, fromDate: Date?, toDate: Date?) {
        self.bookedSlotsLoading.value = true
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.bookedSlotsLoading.value = false
//
//            let respData: [[String: Any]] = [
//                [
//                    "serviceSlot": "9am - 11am",
//                    "bookedSlotEventDetail": [
//                        [ "branchName": "sdf",
//                          "eventName": "Pune",
//                          "eventDate": "sdf"]
//                    ]
//                ],
//                [
//                    "serviceSlot": "5am - 11am",
//                    "bookedSlotEventDetail": [
//                        [ "branchName": "sdf",
//                          "eventName": "The function can be simplified slightly, using automatic type inference, also you use variables a lot where constants are sufficient. In addition, the function should return an optional which is nil for an invalid input string.",
//                          "eventDate": "sdf"]
//                    ]
//                ],
//            ]
//
//            do {
//                let data = try JSONSerialization.data(withJSONObject: respData, options: [])
//                var slots = try JSONDecoder().decode([BookedSlot].self, from: data)
//
//                for i in 0 ..< slots.count {
//                    slots[i].parentId = calendarHeaderId
//                }
//
//                self.bookedSlots.value = slots
//            } catch {
//                print("Error :: \(error)")
//                self.bookedSlotsFetchError.value = "Data could not be parsed"
//            }
//        }
//
//        return
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
            
            var params: [String: Any] = [:]
            if let id = categoryId {
                params[APIConstant.serviceCategoryId] = id
            }
            if let id = onboardingVendorId {
                params[APIConstant.serviceVendorOnboardingId] = id
            }
            if let date = fromDate {
                params[APIConstant.fromDate] = date.toString(with: "MM/dd/yyyy")
            }
            if let date = toDate {
                params[APIConstant.toDate] = date.toString(with: "MM/dd/yyyy")
            }
            
            let url = APIConfig.bookedServiceSlot + "/\(AmplifyLoginUtility.user!.spRegId)"
            APIManager().executeDataRequest(id: "BookedSlot", url: url, method: .GET, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
                
                self.bookedSlotsLoading.value = false
                switch result {
                case true:
                    
                    if let respData = response?["data"] as? [[String: Any]] {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: respData, options: [])
                            let slots = try JSONDecoder().decode([BookedSlot].self, from: data)
                            
                            for i in 0 ..< slots.count {
                                slots[i].parentId = calendarHeaderId
                            }
                            
                            self.bookedSlots.value = slots.isEmpty ? [EmptyData(title: "No Records found", parentId: calendarHeaderId)] : slots
                        } catch {
                            print("Error :: \(error)")
                            self.bookedSlotsFetchError.value = "Data could not be parsed"
                        }
                    } else {
                        self.bookedSlotsFetchError.value = "Data could not be parsed"
                    }
                case false:
                    self.bookedSlotsFetchError.value = error?.localizedDescription ?? "Error in fetchBookedServiceSlots"
                }
            }
        }
    }
    
    func fetchSlotsAvailability(calendarHeaderId: Int, categoryId: Int?, onboardingVendorId: Int?, fromDate: Date?, toDate: Date?, isMonth: Bool) {
        self.bookedSlotsLoading.value = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
            
            var params: [String: Any] = [:]
            if let id = categoryId {
                params[APIConstant.serviceCategoryId] = id
            }
            if let id = onboardingVendorId {
                params[APIConstant.serviceVendorOnboardingId] = id
            }
            if let date = fromDate {
                params[APIConstant.fromDate] = date.toString(with: "MM/dd/yyyy")
            }
            if let date = toDate {
                params[APIConstant.toDate] = date.toString(with: "MM/dd/yyyy")
            }
            
            params[APIConstant.isMonth] = "\(isMonth)"
            
            
            let url = APIConfig.slotsAvailability + "/\(AmplifyLoginUtility.user!.spRegId)"
            APIManager().executeDataRequest(id: "SlotsAvailability", url: url, method: .GET, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
                
                self.bookedSlotsLoading.value = false
                switch result {
                case true:
                    
                    if let respData = response?["data"] as? [[String: Any]] {
                        var slots: [SlotAvailability] = []
                        respData.forEach { data in
                            if let serviceSlot = data["serviceSlot"] as? String {
                                let val = data["bookedEventServiceDtos"] as? [Any]
                                let slot = SlotAvailability(serviceSlot: serviceSlot, isAvailable: val != nil)
                                slot.parentId = calendarHeaderId
                                slot.fromDate = fromDate
                                slot.toDate = toDate
                                
                                if let arr = val as? [[String: Any]] {
                                    arr.forEach { data in
                                        let eventName = (data["eventName"] as? String) ?? ""
                                        let eventDate = (data["eventDate"] as? String) ?? ""
                                        let branchName = (data["branchName"] as? String) ?? ""
                                        let event = SlotEvent(eventName: eventName, eventDate: eventDate, branchName: branchName)
                                        
                                        slot.slotEvents.append(event)
                                    }
                                }
                                
                                slots.append(slot)
                            }
                        }
                        self.bookedSlots.value = slots
                    } else {
                        self.calendarEventFetchError.value = "Data could not be parsed"
                    }
                case false:
                    self.calendarEventFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
                }
            }
        }
    }
    
    func modifySlotAvailability(categoryId: Int?, onboardingVendorId: Int?, fromDate: Date?, toDate: Date?, fetchDataFor: FetchDataForSegment, isAvailable: Bool, modifiedSlot: String) {
        self.bookedSlotsLoading.value = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
            
            var params: [String: Any] = [APIConstant.isAvailable: isAvailable, APIConstant.modifiedSlot: modifiedSlot]
            if let id = categoryId {
                params[APIConstant.serviceCategoryId] = id
            }
            if let id = onboardingVendorId {
                params[APIConstant.serviceVendorOnboardingId] = id
            }
            if let date = fromDate {
                params[APIConstant.fromDate] = date.toString(with: "MM/dd/yyyy")
            }
            if let date = toDate {
                params[APIConstant.toDate] = date.toString(with: "MM/dd/yyyy")
            }
            
            var api = ""
            switch (fetchDataFor) {
            case .day:
                api = APIConfig.modifyDaySlots
                break
            case .week:
                api = APIConfig.modifyWeekSlots
                break
            case .month:
                api = APIConfig.modifyMonthSlots
                break
            }
            
            let url = "\(api)/\(AmplifyLoginUtility.user!.spRegId)"
            APIManager().executeDataRequest(id: "SlotsAvailability", url: url, method: .PUT, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
                
                self.bookedSlotsLoading.value = false
                switch result {
                case true:
                    
                    if let respData = response?["data"] as? [String: Any] {
                        if let array = respData["serviceDates"] as? [String] {
                            var dates: [CalendarEvent] = []
                            array.forEach { dateStr in
                                if let date = dateStr.convertToDate() {
                                    dates.append(CalendarEvent(date: date))
                                }
                            }
                            self.calendarEvents.value = dates
                        }
                        
                    } else {
                        self.calendarEventFetchError.value = "Data could not be parsed"
                    }
                case false:
                    self.calendarEventFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
                }
            }
        }
    }
}

enum FetchDataForSegment {
    case day
    case week
    case month
}

