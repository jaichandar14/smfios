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
        
        let headers = [APIConstant.auth: APIConstant.auth_token]
        var params: [String: Any] = [:]
        if let id = categoryId {
            params[APIConstant.serviceCategoryId] = id
        }
        if let id = vendorOnboardingId {
            params[APIConstant.serviceVendorOnboardingId] = id
        }
        
        let url = APIConfig.serviceProviderBiddingCount + "/\(APIConfig.user!.spRegId)"
        APIManager().executeDataRequest(id: "ServiceList", url: url, method: .GET, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            self.isBidCountLoading.value = false
            switch result {
            case true:
                var pendingActions: [BidCount] = []
                var statusItems: [BidCount] = []
                if let respData = response?["data"] as? [String: Any] {
                    respData.forEach { (key, value) in
                        if let intData = value as? Int {
                            if key == "actionCount" {
                                self.pendingActions.value = intData
                            } else if key == "statusCount" {
                                self.pendingStatus.value = intData
                            } else {
                                let (status, title, apiLabel) = self.getItemStatus(key: key)
                                if status == .isAction {
                                    pendingActions.append(BidCount(key: key, title: title, count: intData, apiLabel: apiLabel))
                                } else {
                                    statusItems.append(BidCount(key: key, title: title, count: intData, apiLabel: apiLabel))
                                }
                            }
                        }
                    }
                    self.actionBidCountList.value = pendingActions
                    self.statusBidCountList.value = statusItems
                } else {
                    self.bidCountFetchError.value = "Data could not be parsed"
                }
            case false:
                self.bidCountFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
    
    enum ActionStatusCheck {
        case isAction
        case isStatus
    }
    
    func getItemStatus(key: String) -> (ActionStatusCheck, String, String) {
        switch key {
        case "bidRequestedCount":
            return (.isAction, "New request", "BID REQUESTED")
        case "bidSubmittedCount":
            return (.isAction, "Bid Submitted", "BID SUBMITTED")
        case "pendingForQuoteCount":
            return (.isAction, "Pending Quote", "PENDING FOR QUOTE")
        case "wonBidCount":
            return (.isAction, "Won Bid", "")
            
        case "bidRejectedCount":
            return (.isStatus, "Bid Rejected", "BID REJECTED")
        case "lostBidCount":
            return (.isStatus, "Lost Bid", "")
        case "bidTimedOutCount":
            return (.isStatus, "Timed Out", "")
        case "serviceDoneCount":
            return (.isStatus, "Request closed", "")
        default:
            return (.isStatus, "", "")
        }
    }
    
    func getActionCountItem(for index: Int) -> BidCount {
        return self.actionBidCountList.value[index]
    }
    
    func getStatusCountItem(for index: Int) -> BidCount {
        return self.statusBidCountList.value[index]
    }
}
