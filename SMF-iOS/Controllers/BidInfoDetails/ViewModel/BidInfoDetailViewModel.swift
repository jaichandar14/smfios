//
//  EventDetailViewModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import Foundation

protocol BidInfoDetailViewModel {
    var orderDetails: Observable<QuestionareWrapperDTO?> { get }
    var bidStatus: Observable<BidStatusInfo?> { get }
    var bidStatusList: Observable<[BidStatus]> { get }
    var serviceList: Observable<[ServiceDetail]> { get }
    var eventInfoList: Observable<[EventDetail]> { get }
    var bidStatusInfoLoading: Observable<Bool> { get }
    var bidStatusInfoFetchError: Observable<String> { get }
    
    func getBidInfoItem(for index: Int) -> BidStatus
    func getEventInfoItem(for index: Int) -> EventDetail
    
    func fetchBidDetailsList(bidRequestId: Int)
    func fetchOrderDescription(eventId: Int, eventServiceDescId: Int)
    
    func getQuestionDTO() -> [QuestionAns]?
    
    func prepareStatus(with status: BiddingStatus)
    func prepareEventInfo(info: BidStatusInfo)
    
    var viewQuoteLoading: Observable<Bool> { get }
    var viewQuoteFetchError: Observable<String?> { get }
    var viewQuoteData: Observable<ViewQuote?> { get }
    func fetchViewQuote(bidRequestId: Int)
}
