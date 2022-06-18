//
//  ActionListViewModelContainer.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/20/22.
//

import Foundation

class ActionListViewModelContainer: ActionListViewModel {
    var bidStatusInfoList: Observable<[BidStatusInfo]>
    var bidStatusInfoLoading: Observable<Bool>
    var bidStatusInfoFetchError: Observable<String>
    
    var model: ActionListModel
    init(model: ActionListModel) {
        self.model = model
        
        self.bidStatusInfoList = Observable<[BidStatusInfo]>([])
        self.bidStatusInfoLoading = Observable<Bool>(false)
        self.bidStatusInfoFetchError = Observable<String>("")
    }
    
    func fetchActionList(categoryId: Int?, vendorOnboardingId: Int?, status: BiddingStatus) {
        self.bidStatusInfoLoading.value = true
        
        model.fetchActionList(categoryId: categoryId, vendorOnboardingId: vendorOnboardingId, status: status.rawValue) { response, error in
        
            self.bidStatusInfoLoading.value = false
            if let data = response {
                do {
                    let data = try JSONSerialization.data(withJSONObject: data, options: [])
                    let list = try JSONDecoder().decode([BidStatusInfo].self, from: data)
                
                    self.bidStatusInfoList.value = list
                } catch let error {
                    print("Error :: \(error)")
                    self.bidStatusInfoFetchError.value = "Data could not be parsed"
                }
            } else {
                self.bidStatusInfoFetchError.value = error!
            }
        }
    }
    
    func getBidInfoItem(for index: Int) -> BidStatusInfo {
        return self.bidStatusInfoList.value[index]
    }
}
