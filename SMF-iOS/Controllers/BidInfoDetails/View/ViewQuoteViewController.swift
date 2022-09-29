//
//  ViewQuoteViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 9/28/22.
//

import UIKit

class ViewQuoteViewController: BaseViewController {
    var bidInfo: BidStatusInfo?
    var viewModel: BidInfoDetailViewModel? {
        didSet {
            setDataToUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleUI()
        setDataToUI()
        
    }
    
    func styleUI() {
        if let bidInfo = self.bidInfo {
            self.title = "Quote details for \(bidInfo.branchName)"
        }
        self.customizeBackButton()
    }
    
    func setDataToUI() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }

        viewModel.fetchViewQuote(bidRequestId: self.bidInfo?.bidRequestId ?? 0)
        viewModel.viewQuoteLoading.bindAndFire { isLoading in
            if isLoading {
                self.showLoader()
            } else {
                self.hideLoader()
            }
        }
        
        viewModel.viewQuoteFetchError.bindAndFire { error in
            if let err = error {
                self.view.makeToast(err)
            }
        }
        
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
