//
//  ViewQuoteViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 9/28/22.
//

import UIKit

struct ViewQuote: Decodable {
    var bidRequestId: Int
    var fileName: String?
    var fileContent: String?
    var fileType: String?
    var fileSize: String?
    var bidStatus: String
    var latestBidValue: Int?
    var comment: String?
    var branchName: String
    var costingType: String?
    var cost: String?
    var currencyType: String?
    
    enum CodingKeys: String, CodingKey {
        case bidRequestId, fileName, fileContent, fileType, fileSize, bidStatus, latestBidValue, comment, branchName, costingType, cost, currencyType
    }
}

class ViewQuoteViewController: BaseViewController {
    
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblEventDescID: UILabel!
    @IBOutlet weak var eventDetailContainer: UIView!
    
    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var lblBranch: UILabel!
    
    @IBOutlet weak var lblCostingType: UILabel!
    @IBOutlet weak var txtCostingAmount: UITextField!
    
    @IBOutlet weak var lblQuoteDetailTitle: UILabel!
    @IBOutlet weak var btnFile: UIButton!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var imgFileRightIcon: UIImageView!
    @IBOutlet weak var imgFileLeftIcon: UIImageView!
    
    @IBOutlet weak var commentTopConstraint: NSLayoutConstraint!
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
            
//            self.lblBidStatus.text = self.getStatusTitle(status: self.bidStatus)
            
            self.lblEventTitle.text = bidInfo.eventName
            self.lblEventDescID.text = "\(bidInfo.eventServiceDescriptionId)"
            self.lblEventDescID.textColor = _theme.primaryColor
            
            self.lblServices.text = bidInfo.serviceName
            self.lblBranch.text = bidInfo.branchName
            
            if bidInfo.costingType == .bidding {
                self.txtCostingAmount.text = bidInfo.latestBidValue == nil ? "" : "\(bidInfo.currencyType?.currency ?? "$")\(bidInfo.latestBidValue!)"
            } else {
                self.txtCostingAmount.text = bidInfo.cost == "" ? "" : "\(bidInfo.currencyType?.currency ?? "$")\(bidInfo.cost)"
            }
            
        }
        
        self.setUpViewShadow(self.eventDetailContainer, backgroundColor: UIColor.white, radius: 11, shadowRadius: 10, isHavingBorder: false)
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
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoader()
                } else {
                    self.hideLoader()
                }
            }
        }
        
        viewModel.viewQuoteFetchError.bindAndFire { error in
            if let err = error {
                DispatchQueue.main.async {
                    self.view.makeToast(err)
                }
            }
        }
        
        viewModel.viewQuoteData.bindAndFire { viewQuote in
            if let quote = viewQuote {
                DispatchQueue.main.async {
                    self.lblFileName.text = quote.fileName
                    self.btnFile.setTitleColor(.darkGray, for: .normal)
                    self.lblCostingType.text = quote.costingType
                    self.lblComment.text = (quote.comment ?? "") == "" ? "No comments available" : quote.comment
                    
                    if (quote.fileName ?? "") == "" {
                        self.commentTopConstraint.constant = 10
                        self.btnFile.isHidden = true
                        self.lblQuoteDetailTitle.isHidden = true
                        
                        self.lblFileName.isHidden = true
                        self.imgFileLeftIcon.isHidden = true
                        self.imgFileRightIcon.isHidden = true
                    } else {
                        self.commentTopConstraint.constant = 85
                        self.btnFile.isHidden = false
                        self.lblQuoteDetailTitle.isHidden = false
                    }
                }
            }
        }
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFileTapped(_ sender: UIButton) {
        let (isFileWritten, url) = AppFileManager().writeAFile(quote: self.viewModel?.viewQuoteData.value)
        if isFileWritten {
            self.view.makeToast("File saved in local")
            if #available(iOS 14.0, *) {
                let docPicker = UIDocumentPickerViewController(forExporting: [url!])
                docPicker.modalPresentationStyle = .formSheet
                self.present(docPicker, animated: true)
            } else {
                let docPicker = UIDocumentPickerViewController(url: url!, in: .exportToService)
                docPicker.modalPresentationStyle = .formSheet
                self.present(docPicker, animated: true)
            }
        }
    }
}
