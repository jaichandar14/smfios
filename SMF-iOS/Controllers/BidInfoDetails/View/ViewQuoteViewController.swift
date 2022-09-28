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
        //
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
