//
//  ChangeInMindViewController.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 24/05/22.
//

import UIKit
import DropDown

protocol ChangeInMindDelegate {
    func rejectionCompleted()
    func acceptationCompleted()
}

class ChangeInMindViewController: BaseViewController {
        

    @IBOutlet weak var lblRejectedBidTitle: UILabel!
    @IBOutlet weak var lblReasonForBidRejection: UILabel!
    @IBOutlet weak var btnBidRejection: UIButton!
    @IBOutlet weak var lblCommentTitle: UILabel!
    @IBOutlet weak var commentContainer: UIView!
    @IBOutlet weak var txtCommentView: UITextView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var lblCommentDesc: UILabel!
    
    var reasonToReject: String?
    var rejectBid: BidStatusInfo?
    var status: BiddingStatus?
    var viewModel: DashboardViewModel?
    
    var delegate: ChangeInMindDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleUI()
    }

    func styleUI() {
        if self.status == .pendingForQuote {
            self.lblCommentDesc.isHidden = true
        } else {
            self.lblCommentDesc.isHidden = false
        }
        
        self.lblRejectedBidTitle.text = "You are rejecting a \(self.rejectBid?.eventName ?? "") #\(self.rejectBid?.eventServiceDescriptionId ?? 0)"
        self.lblRejectedBidTitle.textColor = _theme.textColor
        self.lblRejectedBidTitle.font = _theme.muliFont(size: 14, style: .muliSemiBold)
        self.lblReasonForBidRejection.textColor = _theme.textGreyColor
        self.btnBidRejection.setTitle("Select rejection reason", for: .normal)
        
        self.btnBidRejection.layer.borderColor = ColorConstant.greyColor8.cgColor
        self.btnBidRejection.layer.borderWidth = 1
        self.btnBidRejection.layer.cornerRadius = 2
        self.btnBidRejection.backgroundColor = .clear
        self.btnBidRejection.setTitleColor(_theme.textColor, for: .normal)
        
        self.commentContainer.layer.borderColor = ColorConstant.greyColor8.cgColor
        self.commentContainer.layer.borderWidth = 1
        self.commentContainer.layer.cornerRadius = 10
        
        self.txtCommentView.font = _theme.ralewayFont(size: 14, style: .ralewayRegular)
        
        self.setButton(self.btnCancel, backgroundColor: ColorConstant.greyColor8, textColor: _theme.textColor)
        self.setButton(self.btnOK, backgroundColor: ColorConstant.accentColor, textColor: UIColor.white)
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setDataToUI() {
        //
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }

    
    func setButton(_ button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
        button.layer.cornerRadius = 12
    }
    
    override func showDropDown(on view: UIView, items: [String], selection: SelectionClosure?) {
        let dropDown = DropDown()
        dropDown.anchorView = view
        
        dropDown.dataSource = items
        
        dropDown.selectionAction = { (index: Int, item: String) in
            print("Selected Item \(item)")
            selection?(index, item)
            dropDown.hide()
        }
        
        dropDown.show()
    }

    @IBAction func btnChooseReason(_ sender: UIButton) {
        let itemList = [
            "Already booked for this day",
            "Budget too low",
            "Venue to far to provide service",
            "Other"
        ]
        showDropDown(on: sender, items: itemList) { [weak self] (index, item) in
            self?.reasonToReject = item
            self?.btnBidRejection.setTitle(item, for: .normal)
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnOKAction(_ sender: UIButton) {
        viewModel?.rejectBid(requestId: self.rejectBid!.bidRequestId, reason: self.reasonToReject, comment: self.txtCommentView.text) { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: false, completion: nil)
                self?.delegate?.rejectionCompleted()
            }
        }
    }
}
