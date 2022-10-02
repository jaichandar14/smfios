//
//  QuoteDetailsPopUpViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/4/22.
//

import UIKit
protocol QuoteDetailsPopUpDelegate {
    func cancelTapped()
    func okTapped(bidInfo: BidStatusInfo, cost: String, comment: String, isQuoteSelected: Bool)
    func chooseFileTapped()
}

enum ActiveField {
    case none
    case amountField
    case commentField
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
    
    @IBOutlet weak var arrowImgView: UILabel!
    @IBOutlet weak var priceStackView: UIStackView!
    @IBOutlet weak var chooseFileStackView: UIStackView!
    @IBOutlet weak var bottomButtonStackTopView: NSLayoutConstraint!
        
    @IBOutlet weak var popUpCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var forkSpoonTopConstraint: NSLayoutConstraint!
    var bidInfo: BidStatusInfo?
    var isHavingQuoteSelected = true
    
    var activeField: ActiveField = .none
    
    @IBOutlet weak var quoteLaterStack: UIStackView!
    var quoteAlreadySubmitted: Bool = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleUI()
        setDataToUI()
        
        // call the 'keyboardWillShow' function when the view controller receive the notification that a keyboard is going to be shown
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
       
           // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
         NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
     }

     @objc func keyboardWillShow(notification: NSNotification) {
         if self.activeField == .amountField {
             UIView.animate(withDuration: 1.0) {
                 self.popUpCenterConstraint.constant = -80
             }
         } else if self.activeField == .commentField {
             UIView.animate(withDuration: 1.0) {
                 self.popUpCenterConstraint.constant = -180
             }
         } else {
             UIView.animate(withDuration: 1.0) {
                 self.popUpCenterConstraint.constant = -180
             }
         }
     }

     @objc func keyboardWillHide(notification: NSNotification) {
         UIView.animate(withDuration: 1.0) {
             self.popUpCenterConstraint.constant = 0
         }
     }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func styleUI() {
        
        if self.quoteAlreadySubmitted {
            self.forkSpoonTopConstraint.priority = UILayoutPriority(850)
            self.quoteLaterStack.isHidden = true
        } else {
            self.forkSpoonTopConstraint.priority = UILayoutPriority(950)
            self.quoteLaterStack.isHidden = false
        }
        
        self.lblQuoteTitle.textColor = _theme.textColor
        
        self.lblHavingQuoteDetails.textColor = _theme.textColor
        self.lblWillProvideLater.textColor = _theme.textColor

        self.lblForkAndSpoon.text = bidInfo?.branchName
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
        self.setButton(self.btnOK, backgroundColor: ColorConstant.accentColor, textColor: UIColor.white)
        
        self.btnOK.titleLabel?.font = _theme.muliFont(size: 14, style: .muli)
        self.btnCancel.titleLabel?.font = _theme.muliFont(size: 14, style: .muli)
        
        self.addDoneButtonOnKeyboard(textField: self.txtQuotePrice)
        self.addDoneButtonOnKeyboard(textView: self.txtAreaComment)
        
        self.txtQuotePrice.delegate = self
        self.txtAreaComment.delegate = self
    }
    
    func updateQuoteSelection() {
        if isHavingQuoteSelected {
            self.btnHavingQuote.setTitle("A", for: .normal)
            self.btnHavingQuote.setTitleColor(_theme.primaryColor, for: .normal)
            self.btnWillProvideLater.setTitle("B", for: .normal)
            self.btnWillProvideLater.setTitleColor(ColorConstant.greyColor7, for: .normal)
            
            UIView.animate(withDuration: 0.3) {
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
            
            UIView.animate(withDuration: 0.3) {
                self.bottomButtonStackTopView.priority = UILayoutPriority(850)
                self.setVisibility(to: true)
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
        button.layer.cornerRadius = 12
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
        self.dismiss(animated: false, completion: nil)
        delegate?.okTapped(bidInfo: self.bidInfo!, cost: self.txtQuotePrice.text ?? "", comment: self.txtAreaComment.text, isQuoteSelected: self.isHavingQuoteSelected)
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

extension QuoteDetailsPopUpViewController: UITextFieldDelegate, UITextViewDelegate {
    // when user select a textfield, this method will be called
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // set the activeTextField to the selected textfield
        self.activeField = .amountField
    }
    
    // when user click 'done' or dismiss the keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = .none
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activeField = .commentField
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.activeField = .none
        return true
    }
}
