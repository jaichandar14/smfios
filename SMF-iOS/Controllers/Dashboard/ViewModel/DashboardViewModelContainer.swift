//
//  DataViewModelContainer.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/19/22.
//

import Foundation


class DashboardViewModelContainer: DashboardViewModel {
    var eventsOverviewTitle: String
    var calendarTitle: String
    var serviceCountList: Observable<[ServiceCount]>
    var isServiceCountLoading: Observable<Bool>
    var serviceCountFetchError: Observable<String>
    
    var selectedService: Observable<Service?>
    var serviceList: Observable<[Service]>
    var isServicesLoading: Observable<Bool>
    var servicesFetchError: Observable<String>
    
    var selectedBranch: Observable<Branch?>
    var branches: Observable<[Branch]>
    var isBranchesLoading: Observable<Bool>
    var branchesFetchError: Observable<String>
    
    let model: DashboardModel
    
    init(model: DashboardModel) {
        self.model = model
        
        self.eventsOverviewTitle = "My Services"
        self.calendarTitle = "Calendar"
        self.serviceCountList = Observable<[ServiceCount]>([])
        self.isServiceCountLoading = Observable<Bool>(false)
        self.serviceCountFetchError = Observable<String>("")
        
        self.selectedService = Observable<Service?>(nil)
        self.serviceList = Observable<[Service]>([])
        self.isServicesLoading = Observable<Bool>(false)
        self.servicesFetchError = Observable<String>("")
        
        self.selectedBranch = Observable<Branch?>(nil)
        self.branches = Observable<[Branch]>([])
        self.isBranchesLoading = Observable<Bool>(false)
        self.branchesFetchError = Observable<String>("")
    }
    
    /// Actions
    func fetchServiceCount() {
        self.isServiceCountLoading.value = true
        
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        
        let url = APIConfig.serviceCountURL + "/\(AmplifyLoginUtility.user!.spRegId)"
        APIManager().executeDataRequest(id: "ServiceCount", url: url, method: .GET, parameters: nil, header: headers, cookieRequired: false, priority: .high, queueType: .data) { response, result, error in
            
            self.isServiceCountLoading.value = false
            switch result {
            case true:
                
                if let data = response?["data"] as? [String: Any] {
                    
                    self.serviceCountList.value =   self.fetchOrderedServiceCount(data: data)
                } else {
                    self.serviceCountFetchError.value = "Data could not be parsed"
                }
            case false:
                self.serviceCountFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
        
        
    }
    
    // 3521 when ever i try to refresh we getting the unaligned order of service names
    func fetchOrderedServiceCount(data:[String: Any])->[ServiceCount]{
        var services: [ServiceCount] = []
        data.forEach { (key, value) in
            if let count = value as? Int {
                if key == "activeServiceCount"{
                    services.append(ServiceCount(key: key, count: count))
                    data.forEach { (key, value) in
                        if let count = value as? Int {
                            if key == "approvalPendingServiceCount"{
                                services.append(ServiceCount(key: key, count: count))
                                data.forEach { (key, value) in
                                    if let count = value as? Int {
                                        if key == "draftServiceCount"{
                                            services.append(ServiceCount(key: key, count: count))
                                            data.forEach { (key, value) in
                                                if let count = value as? Int {
                                                    if key == "inactiveServiceCount"{
                                                        services.append(ServiceCount(key: key, count: count))
                                                        data.forEach { (key, value) in
                                                            if let count = value as? Int {
                                                                if key == "rejectedServiceCount"{
                                                                    services.append(ServiceCount(key: key, count: count))
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                        }
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    }
                    
                }
                
            }
        }
        return services
    }
    
    
    func fetchServices() {
        self.isServicesLoading.value = true
        
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        
        let url = APIConfig.servicesListURL + "/\(AmplifyLoginUtility.user!.spRegId)"
        APIManager().executeDataRequest(id: "ServicesList", url: url, method: .GET, parameters: nil, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            self.isServicesLoading.value = false
            switch result {
            case true:
                if let respData = response?["data"] as? [[String: Any]],
                   let data = try? JSONSerialization.data(withJSONObject: respData, options: []),
                   let services = try? JSONDecoder().decode([Service].self, from: data) {
                    
                    self.serviceList.value = services
                } else {
                    self.servicesFetchError.value = "Data could not be parsed"
                }
            case false:
                self.servicesFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
    
    func fetchBranches() {
        self.isBranchesLoading.value = true
        self.selectedBranch.value = nil
        
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        
        var params: [String: Any]?
        if let serviceId = self.selectedService.value?.serviceCategoryId {
            params = [APIConstant.serviceCategoryId: serviceId]
        } else {
            self.branches.value = []
        }
        
        let url = APIConfig.branchesListURL + "/\(AmplifyLoginUtility.user!.spRegId)"
        APIManager().executeDataRequest(id: "BranchList", url: url, method: .GET, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            self.isBranchesLoading.value = false
            switch result {
            case true:
                if let respData = response?["data"] as? [[String: Any]],
                   let data = try? JSONSerialization.data(withJSONObject: respData, options: []),
                   let branches = try? JSONDecoder().decode([Branch].self, from: data) {
                    
                    self.branches.value = branches
                } else {
                    self.branchesFetchError.value = "Data could not be parsed"
                }
            case false:
                self.branchesFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
    
    func rejectBid(requestId: Int, reason: String?, comment: String?, completion: @escaping () -> Void) {
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        
        var params: [String: Any] = [APIConstant.bidRequestId: requestId]
        if let reason = reason {
            params[APIConstant.rejectedBidReason] = reason
        }
        if let comment = comment {
            params[APIConstant.rejectedBidComment] = comment
        }
        
        APIManager().executeDataRequest(id: "Reject Bid", url: APIConfig.rejectBidRequest, method: .PUT, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            switch result {
            case true:
                if let respData = response?["data"] as? [String: Any] {
                    completion()
                } else {
                    self.branchesFetchError.value = "Data could not be parsed"
                }
            case false:
                self.branchesFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
    
    func afterServiceClosedInitiateBid(requestId: Int, reason: String?, comment: String?, completion: @escaping () -> Void) {
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        
        let params: [String: Any] = [APIConstant.bidRequestId: requestId]
        
        APIManager().executeDataRequest(id: "Accept Bid", url: APIConfig.rejectBidRequest, method: .PUT, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            switch result {
            case true:
                if let respData = response?["data"] as? [String: Any] {
                    completion()
                } else {
                    self.branchesFetchError.value = "Data could not be parsed"
                }
            case false:
                self.branchesFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
    
    func acceptBid(requestId: Int, params: [String: Any], completion: @escaping () -> ()) {
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        
        let url = APIConfig.acceptBidRequest + "/\(requestId)"
        APIManager().executeDataRequest(id: "Accept Bid", url: url, method: .PUT, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            switch result {
            case true:
                if let respData = response?["data"] as? [String: Any] {
                    completion()
                } else {
                    self.branchesFetchError.value = "Data could not be parsed"
                }
            case false:
                self.branchesFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
    
    func getBranchItem(for index: Int) -> Branch {
        return branches.value[index]
    }
    
    func getServiceItem(for index: Int) -> Service {
        return self.serviceList.value[index]
    }
    
    func getServiceCountItem(for index: Int) -> ServiceCount {
        return self.serviceCountList.value[index]
    }
    
    func updateServiceProgress(requestId: Int, eventId: Int, serviceDescId: Int, status: String, completion: @escaping () -> Void) {
        let headers = [APIConstant.auth: AmplifyLoginUtility.amplifyToken]
        
        let params: [String: Any] = [
            APIConstant.eventId: eventId,
            APIConstant.eventServiceDescriptionId: serviceDescId,
            APIConstant.status: status
        ]
        
        let url = APIConfig.serviceProgress + "/\(requestId)"
        APIManager().executeDataRequest(id: "Accept Bid", url: url, method: .PUT_URL_PARAM, parameters: params, header: headers, cookieRequired: false, priority: .normal, queueType: .data) { response, result, error in
            
            switch result {
            case true:
                if let respData = response?["data"] as? [String: Any] {
                    completion()
                } else {
                    self.branchesFetchError.value = "Data could not be parsed"
                }
            case false:
                self.branchesFetchError.value = error?.localizedDescription ?? "Error in updateServiceProgress"
            }
        }
    }
}
