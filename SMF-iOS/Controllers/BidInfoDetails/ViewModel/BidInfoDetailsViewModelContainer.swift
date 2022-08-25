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
    var orderDetails: Observable<QuestionareWrapperDTO?>
    var bidStatusInfoLoading: Observable<Bool>
    var bidStatusInfoFetchError: Observable<String>
    
    var serviceList: Observable<[ServiceDetail]>
    
    var model: BidInfoDetailsModel
    
    init(model: BidInfoDetailsModel) {
        self.model = model
        
        self.bidStatus = Observable<BidStatusInfo?>(nil)
        self.bidStatusList = Observable<[BidStatus]>([])
        self.eventInfoList = Observable<[EventDetail]>([])
        
        self.orderDetails = Observable<QuestionareWrapperDTO?>(nil)
        self.serviceList = Observable<[ServiceDetail]>([])
        self.bidStatusInfoLoading = Observable<Bool>(false)
        self.bidStatusInfoFetchError = Observable<String>("")
    }
    
    func getBidInfoItem(for index: Int) -> BidStatus {
        return bidStatusList.value[index]
    }
    
    func fetchBidDetailsList(bidRequestId: Int) {
        self.bidStatusInfoLoading.value = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.bidStatusList.value = [
//                BidStatus(title: "Bid accepted", subTitle: "Quote send to the customer - $2500", isCompleted: true),
//                BidStatus(title: "Won/Reject/LostBid", subTitle: "", isCompleted: false),
//                BidStatus(title: "Service Status", subTitle: "", isCompleted: false),
//                BidStatus(title: "Review Feedback", subTitle: "", isCompleted: false)
//            ]
//
//            self.eventInfoList.value = [
//                EventDetail(title: "Event date", value: "06 Jul 2022"),
//                EventDetail(title: "Bid proposal date", value: "23 Jul 2022"),
//                EventDetail(title: "Cut off date", value: "26 Jul 2022"),
//                EventDetail(title: "Service date", value: "06 Jul 2022"),
//                EventDetail(title: "Payment status", value: "NA"),
//                EventDetail(title: "Service by", value: "NA"),
//                EventDetail(title: "Address", value: "352 Mullai new housing thanjour"),
//                EventDetail(title: "Customer Rating", value: "NA"),
//                EventDetail(title: "Review Comment", value: "NA"),
//            ]
//        }
//
//        return
        
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        
        let url = APIConfig.orderInfo + "/\(bidRequestId)"
        APIManager().executeDataRequest(id: "BidOrderInfo", url: url, method: .GET, parameters: nil, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            self.bidStatusInfoLoading.value = false
            switch result {
            case true:
                
                if let respData = response?["data"] as? [String: Any] {
                    do {
                        let data = try JSONSerialization.data(withJSONObject: respData, options: [])
                        let obj = try JSONDecoder().decode(BidStatusInfo.self, from: data)

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
    
    func fetchOrderDescription(eventId: Int, eventServiceDescId: Int) {
        self.bidStatusInfoLoading.value = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
            
            let url = APIConfig.orderDescriptionAPI + "/\(eventId)" + "/\(eventServiceDescId)"
            APIManager().executeDataRequest(id: "OrderDescription", url: url, method: .GET, parameters: nil, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
                
                self.bidStatusInfoLoading.value = false
                switch result {
                case true:
                    
                    if let respData = response?["data"] as? [String: Any],
                       let questionareJson = respData["eventServiceQuestionnaireDescriptionDto"] as? [String: Any],
                       let venueJson = respData["venueInformationDto"] as? [String: Any] {
                        do {
                            
                            let questionaredata = try JSONSerialization.data(withJSONObject: questionareJson, options: [])
                            var questionareObject = try JSONDecoder().decode(QuestionareWrapperDTO.self, from: questionaredata)
                            
                            let venueData = try JSONSerialization.data(withJSONObject: venueJson, options: [])
                            let venueObject = try JSONDecoder().decode(VenueAddress.self, from: venueData)
                            
                            questionareObject.venueAddress = venueObject
                            
                            self.updateServiceList(with: questionareObject)
                            self.orderDetails.value = questionareObject
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
    }
    
    func getQuestionDTO() -> [QuestionAns]? {
        return self.orderDetails.value?.questionnaireWrapperDto.questionnaireDtos
    }
    
    func updateBidEventStatus(model: BidStatusInfo) {
        self.eventInfoList.value = [
//            EventDetail(title: , value: )
        ]
    }
    
    func updateServiceList(with model: QuestionareWrapperDTO) {
        self.serviceList.value.append(contentsOf: [
            ServiceDetail(title: "Service Date", subTitle: model.eventServiceDescriptionDto.serviceDate.toSMFDateFormat(), isCompleted: false),
            ServiceDetail(title: "Bid Cut Off Date", subTitle: model.eventServiceDescriptionDto.biddingCutOffDate.toSMFDateFormat(), isCompleted: false),
            ServiceDetail(title: "Estimation Budget", subTitle: "\(model.eventServiceDescriptionDto.currencyType ?? "") \(model.eventServiceDescriptionDto.estimatedBudget)", isCompleted: false),
            ServiceDetail(title: "Service Radius", subTitle: model.eventServiceDescriptionDto.radius, isCompleted: false),
            ServiceDetail(title: "Preferred Time Slot", subTitle: model.eventServiceDescriptionDto.preferredSlots.joined(separator: ","), isCompleted: false),
        ])
    }
    
    func getEventInfoItem(for index: Int) -> EventDetail {
        return self.eventInfoList.value[index]
    }
}
