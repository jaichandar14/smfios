//
//  AcceptBidViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 9/27/22.
//

import UIKit

class ConfirmationPopUpViewController: BaseViewController {
    @IBOutlet weak var lblAcceptBidTitle: UILabel!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    
    var message: String!
    var rejectBid: BidStatusInfo?

    var okTappedAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func styleUI() {
        self.lblAcceptBidTitle.text = message
        self.lblAcceptBidTitle.textColor = _theme.textColor
        self.lblAcceptBidTitle.font = _theme.muliFont(size: 14, style: .muliSemiBold)
        self.lblAcceptBidTitle.textColor = _theme.textGreyColor
        
        self.setButton(self.btnCancel, backgroundColor: ColorConstant.greyColor8, textColor: _theme.textColor)
        self.setButton(self.btnOK, backgroundColor: ColorConstant.accentColor, textColor: UIColor.white)
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

    func setButton(_ button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
        button.layer.cornerRadius = 12
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnOKAction(_ sender: UIButton) {
        self.okTappedAction?()
//        viewModel?.rejectBid(requestId: self.rejectBid!.bidRequestId, reason: self.reasonToReject, comment: self.txtCommentView.text) { [weak self] in
//            DispatchQueue.main.async {
//                self?.dismiss(animated: false, completion: nil)
//                self?.delegate?.rejectionCompleted()
//            }
//        }
    }
    
}
