//
//  ActionListViewModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/20/22.
//

import Foundation

protocol ActionListViewModel {
    var bidStatusInfoList: Observable<[BidStatusInfo]> { get }    
    var bidStatusInfoLoading: Observable<Bool> { get }
    var bidStatusInfoFetchError: Observable<String> { get }
    
    func getBidInfoItem(for index: Int) -> BidStatusInfo
    func fetchActionList(categoryId: Int?, vendorOnboardingId: Int?, status: String)
}
