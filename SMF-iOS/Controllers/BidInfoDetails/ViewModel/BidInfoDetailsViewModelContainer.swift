//
//  EventDetailsViewModelContainer.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/22/22.
//

import Foundation
import UIKit

class BidInfoDetailViewModelContainer: BidInfoDetailViewModel {
    
    
    var bidStatus: Observable<BidStatusInfo?>
    var bidStatusList: Observable<[BidStatus]>
    var eventInfoList: Observable<[EventDetail]>
    var bidStatusInfoLoading: Observable<Bool>
    var bidStatusInfoFetchError: Observable<String>
    
    var serviceList: Observable<[ServiceDetail]>
    var questionAnsList: Observable<[QuestionAns]>
    
    var model: BidInfoDetailsModel
    
    init(model: BidInfoDetailsModel) {
        self.model = model
        
        self.bidStatus = Observable<BidStatusInfo?>(nil)
        self.bidStatusList = Observable<[BidStatus]>([])
        self.eventInfoList = Observable<[EventDetail]>([])
        
        self.serviceList = Observable<[ServiceDetail]>([])
        self.questionAnsList = Observable<[QuestionAns]>([])
        self.bidStatusInfoLoading = Observable<Bool>(false)
        self.bidStatusInfoFetchError = Observable<String>("")
    }
    
    func getBidInfoItem(for index: Int) -> BidStatus {
        return bidStatusList.value[index]
    }
    
    func fetchBidDetailsList(bidRequestId: Int) {
        self.bidStatusInfoLoading.value = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let headers = [APIConstant.auth: APIConstant.auth_token]
            
            let url = APIConfig.orderInfo + "/\(bidRequestId)"
            APIManager().executeDataRequest(id: "BidOrderInfo", url: url, method: .GET, parameters: nil, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
                
                self.bidStatusInfoLoading.value = false
                switch result {
                case true:
                    
                    if let respData = response?["data"] as? [String: Any] {
                        do {
                            let data = try JSONSerialization.data(withJSONObject: respData, options: [])
                            let obj = try JSONDecoder().decode(BidStatusInfo.self, from: data)
                            self.updateServiceList(with: obj)
                            self.bidStatus.value = obj
                        } catch let error {
                            print("Error :: \(error)")
                            self.bidStatusInfoFetchError.value = "Data could not be parsed"
                        }
                    } else {
                        self.bidStatusInfoFetchError.value = "Data could not be parsed"
                    }
                case false:
                    self.bidStatusInfoFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
                }
            }
        }
        
        self.questionAnsList.value = [
            QuestionAns(question: "Q: Which type of food prefreed?", ans: "Answer: Both"),
            QuestionAns(question: "Q: Which type of beverage", ans: "Answer: Both"),
        ]
    }
    
    func updateServiceList(with model: BidStatusInfo) {
        self.serviceList.value.append(contentsOf: [
            ServiceDetail(title: "Service Date", subTitle: model.serviceDate.toSMFDateFormat(), isCompleted: false),
            ServiceDetail(title: "Bid Cut Off Date", subTitle: model.biddingCutOffDate.toSMFDateFormat(), isCompleted: false),
            ServiceDetail(title: "Estimation Budget", subTitle: model.cost, isCompleted: false),
            ServiceDetail(title: "Service Radius", subTitle: "50 - 100 Miles", isCompleted: false),
            ServiceDetail(title: "Preferred Time Slot", subTitle: "4pm - 8pm, 8pm - 12am", isCompleted: false),
        ])
    }
    
    func getEventInfoItem(for index: Int) -> EventDetail {
        return self.eventInfoList.value[index]
    }
}