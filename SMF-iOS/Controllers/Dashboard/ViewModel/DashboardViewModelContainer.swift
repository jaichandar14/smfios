//
//  DataViewModelContainer.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/19/22.
//

import Foundation


class DashboardViewModelContainer: DashboardViewModel {
    var servicesTitle: String
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
        
        self.servicesTitle = "Services"
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
        
        let headers = [APIConstant.auth: APIConstant.auth_token]
        
        let url = APIConfig.serviceCountURL + "/\(APIConfig.user!.spRegId)"
        APIManager().executeDataRequest(id: "ServiceCount", url: url, method: .GET, parameters: nil, header: headers, cookieRequired: false, priority: .high, queueType: .data) { response, result, error in
            
            self.isServiceCountLoading.value = false
            switch result {
            case true:
                var services: [ServiceCount] = []
                if let data = response?["data"] as? [String: Any] {
                    data.forEach { (key, value) in
                        if let count = value as? Int {
                            services.append(ServiceCount(key: key, count: count))
                        }
                    }
                    self.serviceCountList.value = services
                } else {
                    self.serviceCountFetchError.value = "Data could not be parsed"
                }
            case false:
                self.serviceCountFetchError.value = error?.localizedDescription ?? "Error in fetchServiceCount"
            }
        }
    }
    
    func fetchServices() {
        self.isServicesLoading.value = true
        
        let headers = [APIConstant.auth: APIConstant.auth_token]
        
        let url = APIConfig.servicesListURL + "/\(APIConfig.user!.spRegId)"
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
        
        let headers = [APIConstant.auth: APIConstant.auth_token]
        
        var params: [String: Any]?
        if let serviceId = self.selectedService.value?.serviceCategoryId {
            params = [APIConstant.serviceCategoryId: serviceId]
        } else {
            self.branches.value = []
        }
        
        let url = APIConfig.branchesListURL + "/\(APIConfig.user!.spRegId)"
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
    
    func getBranchItem(for index: Int) -> Branch {
        return branches.value[index]
    }
    
    func getServiceItem(for index: Int) -> Service {
        return self.serviceList.value[index]
    }
    
    func getServiceCountItem(for index: Int) -> ServiceCount {
        return self.serviceCountList.value[index]
    }
}
