//
//  DashboardViewModel.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/1/22.
//

import Foundation

protocol DashboardViewModel {
    /// Out properties and methods
    // Service Count
    var servicesTitle: String { get }
    var serviceCountList: Observable<[ServiceCount]> { get }
    var isServiceCountLoading: Observable<Bool> { get }
    var serviceCountFetchError: Observable<String> { get }
    
    func getServiceCountItem(for index: Int) -> ServiceCount
    
    // Services
    var selectedService: Observable<Service?> { get set }
    var serviceList: Observable<[Service]> { get }
    var isServicesLoading: Observable<Bool> { get }
    var servicesFetchError: Observable<String> { get }
    
    func getServiceItem(for index: Int) -> Service
    
    // Services
    var selectedBranch: Observable<Branch?> { get set }
    var branches: Observable<[Branch]> { get }
    var isBranchesLoading: Observable<Bool> { get }
    var branchesFetchError: Observable<String> { get }
    
    func getBranchItem(for index: Int) -> Branch
    
    /// Input methods
    func fetchServiceCount()
    func fetchServices()
    func fetchBranches()
}
