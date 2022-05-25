//
//  QuoteDetailsPopUpViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/4/22.
//

import UIKit
protocol QuoteDetailsPopUpDelegate {
    func cancelTapped()
    func okTapped()
    func chooseFileTapped()
}

class QuoteDetailsPopUpViewController: BaseViewController {
        
    var delegate: QuoteDetailsPopUpDelegate?
    
    @IBOutlet weak var lblQuoteTitle: UILabel!
    @IBOutlet weak var lblHavingQuoteDetails: UILabel!
    @IBOutlet weak var lblWillProvideLater: UILabel!
    
    @IBOutlet weak var btnHavingQuote: UIButton!
    @IBOutlet weak var btnWillProvideLater: UIButton!
    
    @IBOutlet weak var lblForkAndSpoon: UILabel!
    
    @IBOutlet weak var lblQuoteDetail: UILabel!
    @IBOutlet weak var lblCostEstimation: UILabel!
    
    @IBOutlet weak var btnCurrency: UIButton!
    @IBOutlet weak var btnChooseQuoteFile: UIButton!
    @IBOutlet weak var txtQuotePrice: UITextField!
  
    @IBOutlet weak var lblCommentTitle: UILabel!
    
    @IBOutlet weak var txtAreaContainer: UIView!
    @IBOutlet weak var txtAreaComment: UITextView!
   
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    
    @IBOutlet weak var arrowImgView: UIImageView!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var chooseFileStackView: UIStackView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomButtonStackTopView: NSLayoutConstraint!
        
    var isHavingQuoteSelected = true
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleUI()
        setDataToUI()
    }
    
    func styleUI() {
        
        self.lblQuoteTitle.textColor = _theme.textColor
        self.lblForkAndSpoon.font = _theme.ralewayFont(size: 20, style: .ralewaySemiBold)
        
        self.lblHavingQuoteDetails.textColor = _theme.textColor
        self.lblWillProvideLater.textColor = _theme.textColor
        
        self.lblForkAndSpoon.textColor = _theme.textColor
        self.lblForkAndSpoon.font = _theme.ralewayFont(size: 16, style: .ralewayBold)
        
        self.lblCostEstimation.textColor = _theme.textGreyColor
        self.lblCostEstimation.font = _theme.ralewayFont(size: 12, style: .ralewayRegular)
        
        self.lblQuoteDetail.textColor = _theme.textGreyColor
        self.lblQuoteDetail.font = _theme.ralewayFont(size: 12, style: .ralewayRegular)
        
        self.lblCommentTitle.textColor = _theme.textGreyColor
        self.lblCommentTitle.font = _theme.ralewayFont(size: 12, style: .ralewayRegular)
        
        self.txtAreaContainer.layer.borderColor = ColorConstant.greyColor8.cgColor
        self.txtAreaContainer.layer.borderWidth = 1
        self.txtAreaContainer.layer.cornerRadius = 10
        
        self.txtAreaComment.font = _theme.ralewayFont(size: 14, style: .ralewayRegular)
               
        self.btnHavingQuote.titleLabel?.font = UIFont(name: "smf_icon", size: 18)
        self.btnHavingQuote.backgroundColor = .clear
        self.btnWillProvideLater.titleLabel?.font = UIFont(name: "smf_icon", size: 18)
        self.btnWillProvideLater.backgroundColor = .clear
        self.updateQuoteSelection()
        
        self.btnCurrency.setTitleColor(ColorConstant.greyColor4, for: .normal)
        self.btnCurrency.titleLabel?.font = _theme.ralewayFont(size: 14, style: .ralewayRegular)
        self.btnCurrency.layer.borderColor = ColorConstant.greyColor7.cgColor
        self.btnCurrency.layer.borderWidth = 1
        self.btnCurrency.layer.cornerRadius = 5
        self.btnCurrency.backgroundColor = .clear
        
        self.setButton(self.btnChooseQuoteFile, backgroundColor: ColorConstant.greyColor9, textColor: ColorConstant.greyColor3)
        self.btnChooseQuoteFile.titleLabel?.font = _theme.ralewayFont(size: 14, style: .ralewayRegular)
        self.btnChooseQuoteFile.layer.borderColor = ColorConstant.greyColor7.cgColor
        self.btnChooseQuoteFile.layer.borderWidth = 1
        self.btnChooseQuoteFile.layer.cornerRadius = 5
        
        self.setButton(self.btnCancel, backgroundColor: ColorConstant.greyColor8, textColor: _theme.textColor)
        self.setButton(self.btnOK, backgroundColor: ColorConstant.greyColor4, textColor: UIColor.white)
        
        self.btnOK.titleLabel?.font = _theme.muliFont(size: 14, style: .muli)
        self.btnCancel.titleLabel?.font = _theme.muliFont(size: 14, style: .muli)
    }
    
    func updateQuoteSelection() {
        if isHavingQuoteSelected {
            self.btnHavingQuote.setTitle("A", for: .normal)
            self.btnHavingQuote.setTitleColor(_theme.primaryColor, for: .normal)
            self.btnWillProvideLater.setTitle("B", for: .normal)
            self.btnWillProvideLater.setTitleColor(ColorConstant.greyColor7, for: .normal)
            
            UIView.animate(withDuration: 0.3) {
                self.viewHeightConstraint.constant = 650
                self.bottomButtonStackTopView.priority = UILayoutPriority(650)
                self.view.layoutIfNeeded()
            } completion: { isCompleted in
                self.setVisibility(to: false)
                self.view.layoutIfNeeded()
            }
            
        } else {
            self.btnHavingQuote.setTitle("B", for: .normal)
            self.btnHavingQuote.setTitleColor(ColorConstant.greyColor7, for: .normal)
            self.btnWillProvideLater.setTitle("A", for: .normal)
            self.btnWillProvideLater.setTitleColor(_theme.primaryColor, for: .normal)
            self.viewHeightConstraint.constant = 350
            
            
            UIView.animate(withDuration: 0.3) {
                self.bottomButtonStackTopView.priority = UILayoutPriority(850)
                self.setVisibility(to: true)
                self.viewHeightConstraint.constant = 250
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func setVisibility(to value: Bool) {
        arrowImgView.isHidden = value
        priceStackView.isHidden = value
        chooseFileStackView.isHidden = value
        txtAreaContainer.isHidden = value
        lblCommentTitle.isHidden = value
        lblForkAndSpoon.isHidden = value
    }
    
    func setDataToUI() {
        // add Stubs
    }
    
    func setButton(_ button: UIButton, backgroundColor: UIColor, textColor: UIColor) {
        button.backgroundColor = backgroundColor
        button.setTitleColor(textColor, for: .normal)
        button.layer.cornerRadius = 20
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        print("NetworkChange")
    }
    
    @IBAction func btnChooseFile(_ sender: UIButton) {
        delegate?.chooseFileTapped()
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        delegate?.cancelTapped()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnOkAction(_ sender: UIButton) {
        delegate?.okTapped()
    }
    
    @IBAction func btnHavingQuote(_ sender: UIButton) {
        self.isHavingQuoteSelected = !self.isHavingQuoteSelected
        self.updateQuoteSelection()
    }
    
    @IBAction func btnWillProvideLater(_ sender: UIButton) {
        self.isHavingQuoteSelected = !self.isHavingQuoteSelected
        self.updateQuoteSelection()
    }
    
    
}
