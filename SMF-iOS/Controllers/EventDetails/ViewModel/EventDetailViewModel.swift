//
//  EventDetailViewModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import Foundation

protocol EventDetailViewModel {
    var bidStatusList: Observable<[BidStatus]> { get }
    var eventInfoList: Observable<[EventDetail]> { get }
    var bidStatusInfoLoading: Observable<Bool> { get }
    var bidStatusInfoFetchError: Observable<String> { get }
    
    func getBidInfoItem(for index: Int) -> BidStatus
    func getEventInfoItem(for index: Int) -> EventDetail
    
    func fetchBidDetailsList(categoryId: Int?, vendorOnboardingId: Int?, status: String)
}
