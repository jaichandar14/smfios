//
//  ActionStatusViewModelContainer.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/20/22.
//

import Foundation

class ActionStatusViewModelContainer: ActionStatusViewModel {
    var pendingActions: Observable<Int>
    var pendingStatus: Observable<Int>
    
    var actionBidCountList: Observable<[BidCount]>
    var statusBidCountList: Observable<[BidCount]>
    var isBidCountLoading: Observable<Bool>
    var bidCountFetchError: Observable<String>
    
    private let model: ActionStatusModel
    
    init(model: ActionStatusModel) {
        self.model = model
        
        self.pendingActions = Observable<Int>(0)
        self.pendingStatus = Observable<Int>(0)
        
        self.actionBidCountList = Observable<[BidCount]>([])
        self.statusBidCountList = Observable<[BidCount]>([])
        self.isBidCountLoading = Observable<Bool>(false)
        self.bidCountFetchError = Observable<String>("")
    }
    
    func fetchBidCount(categoryId: Int?, vendorOnboardingId: Int?) {
        self.isBidCountLoading.value = true
        
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        var params: [String: Any] = [:]
        if let id = categoryId {
            params[APIConstant.serviceCategoryId] = id
        }
        if let id = vendorOnboardingId {
            params[APIConstant.serviceVendorOnboardingId] = id
        }
        
        let url = APIConfig.serviceProviderBiddingCount + "/\(AmplifyLoginUtility.user!.spRegId)"
        APIManager().executeDataRequest(id: "ServiceList", url: url, method: .GET, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            self.isBidCountLoading.value = false
            switch result {
            case true:
                var pendingActions: [BidCount] = []
                var statusItems: [BidCount] = []
                if let respData = response?["data"] as? [String: Any] {
                    print("Bidding count:: \(respData)")
                    respData.forEach { (key, value) in
                        let intData = value as? Int ?? 0
                        if key == "actionCount" {
                            self.pendingActions.value = intData
                        } else if key == "statusCount" {
                            self.pendingStatus.value = intData
                        } else {
                            if let (status, title, apiLabel) = self.getItemStatus(key: key) {
                                if status == .isAction {
                                    pendingActions.append(BidCount(key: key, title: title, count: intData, apiLabel: apiLabel))
                                } else {
                                    statusItems.append(BidCount(key: key, title: title, count: intData, apiLabel: apiLabel))
                                }
                            }
                        }
                    }
                    
                    self.actionBidCountList.value = self.getOrderedActiveRequest(array: pendingActions)
                    self.statusBidCountList.value = self.getOrderedStatusRequest(array: statusItems)
                    
                    var activeServices = 0
                    pendingActions.forEach { bidCount in
                        activeServices += bidCount.count
                    }
                    
                    var inactiveServices = 0
                    statusItems.forEach { status in
                        inactiveServices += status.count
                    }
                    self.pendingActions.value = activeServices
                    self.pendingStatus.value = inactiveServices
                    
                } else {
                    self.bidCountFetchError.value = "Data could not be parsed"
                }
            case false:
                self.bidCountFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
    
    func getOrderedActiveRequest(array: [BidCount]) -> [BidCount] {
        var orderedArray: [BidCount] = []
        if let obj = array.first(where: { $0.apiLabel == .bidRequested }) {
            orderedArray.append(obj)
        }
        if let obj = array.first(where: { $0.apiLabel == .pendingForQuote }) {
            orderedArray.append(obj)
        }
        if let obj = array.first(where: { $0.apiLabel == .bidSubmitted }) {
            orderedArray.append(obj)
        }
        if let obj = array.first(where: { $0.apiLabel == .wonBid }) {
            orderedArray.append(obj)
        }
        if let obj = array.first(where: { $0.apiLabel == .serviceInProgress }) {
            orderedArray.append(obj)
        }
        if let obj = array.first(where: { $0.apiLabel == .pendingReview }) {
            orderedArray.append(obj)
        }
        
        return orderedArray
    }
    
    func getOrderedStatusRequest(array: [BidCount]) -> [BidCount] {
        var orderedArray: [BidCount] = []
        if let obj = array.first(where: { $0.apiLabel == .serviceClosed }) {
            orderedArray.append(obj)
        }
        if let obj = array.first(where: { $0.apiLabel == .bidRejected }) {
            orderedArray.append(obj)
        }
        if let obj = array.first(where: { $0.apiLabel == .bidTimedOut }) {
            orderedArray.append(obj)
        }
        if let obj = array.first(where: { $0.apiLabel == .lostBid }) {
            orderedArray.append(obj)
        }
        
        return orderedArray
    }
    
    enum ActionStatusCheck {
        case isAction
        case isStatus
    }
    
    func getItemStatus(key: String) -> (ActionStatusCheck, String, BiddingStatus)? {
        switch key {
        case "bidRequestedCount":
            return (.isAction, "New request", .bidRequested)
        case "bidSubmittedCount":
            return (.isAction, "Quote Sent", .bidSubmitted)
        case "pendingForQuoteCount":
            return (.isAction, "Pending Quote", .pendingForQuote)
        case "wonBidCount":
            return (.isAction, "Won Bid", .wonBid)
        case "serviceInProgressCount":
            return (.isAction, "Service Progress", .serviceInProgress)
            
        case "bidRejectedCount":
            return (.isStatus, "Bid Rejected", .bidRejected)
        case "lostBidCount":
            return (.isStatus, "Lost Bid", .lostBid)
        case "bidTimedOutCount":
            return (.isStatus, "Timed Out", .bidTimedOut)
        case "serviceDoneCount":
            return (.isStatus, "Service closed", .serviceClosed)
        default:
            return nil
        }
    }
    
    func getActionCountItem(for index: Int) -> BidCount {
        return self.actionBidCountList.value[index]
    }
    
    func getStatusCountItem(for index: Int) -> BidCount {
        return self.statusBidCountList.value[index]
    }
}
