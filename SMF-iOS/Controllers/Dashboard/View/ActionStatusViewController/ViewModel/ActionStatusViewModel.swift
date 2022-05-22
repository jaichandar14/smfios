//
//  ActionStatusViewModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/20/22.
//

import Foundation

protocol ActionStatusViewModel {
    var pendingActions: Observable<Int> { get }
    var pendingStatus: Observable<Int> { get }
    
    var actionBidCountList: Observable<[BidCount]> { get }
    var statusBidCountList: Observable<[BidCount]> { get }
    var isBidCountLoading: Observable<Bool> { get }
    var bidCountFetchError: Observable<String> { get }
    
    func getActionCountItem(for index: Int) -> BidCount
    func getStatusCountItem(for index: Int) -> BidCount
    
    func fetchBidCount(categoryId: Int?, vendorOnboardingId: Int?)
}
