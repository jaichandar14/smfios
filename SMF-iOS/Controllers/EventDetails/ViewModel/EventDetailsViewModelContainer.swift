//
//  EventDetailsViewModelContainer.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import Foundation
import UIKit



class EventDetailViewModelContainer: EventDetailViewModel {
    var bidStatusList: Observable<[BidStatus]>
    var eventInfoList: Observable<[EventDetail]>
    var bidStatusInfoLoading: Observable<Bool>
    var bidStatusInfoFetchError: Observable<String>
    
    var model: EventDetailsModel
    
    init(model: EventDetailsModel) {
        self.model = model
        
        self.bidStatusList = Observable<[BidStatus]>([])
        self.eventInfoList = Observable<[EventDetail]>([])
        self.bidStatusInfoLoading = Observable<Bool>(false)
        self.bidStatusInfoFetchError = Observable<String>("")
    }
    
    func getBidInfoItem(for index: Int) -> BidStatus {
        return bidStatusList.value[index]
    }
    
    func fetchBidDetailsList(categoryId: Int?, vendorOnboardingId: Int?, status: String) {
        self.bidStatusList.value = [
            BidStatus(title: "Bid Accepted", subTitle: "Quote sent to customer - quote value $2500", isCompleted: true),
            BidStatus(title: "Won/reject/Lost Bid", subTitle: "", isCompleted: false),
            BidStatus(title: "Service status", subTitle: "", isCompleted: false),
            BidStatus(title: "Review Feedback", subTitle: "", isCompleted: false),
        ]
        
        self.eventInfoList.value = [
            EventDetail(title: "Event Date", value: "9 Aug 2021"),
            EventDetail(title: "Bid proposal date", value: "9 Aug 2021"),
            EventDetail(title: "Cut off date", value: "9 Aug 2021"),
            EventDetail(title: "Service date", value: "9 Aug 2021"),
            EventDetail(title: "Payment status", value: "9 Aug 2021"),
            EventDetail(title: "Serviced by", value: "NA"),
            EventDetail(title: "Address", value: "Adga solution, St Peters Rd"),
            EventDetail(title: "Customer Rating", value: "Customer promptly"),
        ]
    }
    
    func getEventInfoItem(for index: Int) -> EventDetail {
        return self.eventInfoList.value[index]
    }
}
