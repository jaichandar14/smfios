//
//  OrderDetailViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/23/22.
//

import UIKit
import ProgressHUD

class OrderDetailViewController: BaseViewController {

    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblServiceID: UILabel!
    @IBOutlet weak var lblEventDateTitle: UILabel!
    @IBOutlet weak var lblEventValue: UILabel!
    @IBOutlet weak var lblVenueZipTitle: UILabel!
    @IBOutlet weak var lblVenueZipValue: UILabel!
    
    @IBOutlet weak var orderDetailsView: UIView!
    @IBOutlet weak var serviceInfoTableView: UITableView!
    @IBOutlet weak var questionAnsTableView: UITableView!
    @IBOutlet weak var questionAnsTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblServices: UILabel!
    @IBOutlet weak var lblQuestions: UILabel!
    @IBOutlet weak var serviceTableViewHeightConstraint: NSLayoutConstraint!
    
    var eventId: Int?
    var eventServiceDescId: Int?
    var eventName: String?
    var eventDate: String?
    
    var viewModel: BidInfoDetailViewModel? {
        didSet {
            setDataToUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.serviceInfoTableView.tag = 100
        self.serviceInfoTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.questionAnsTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        styleUI()
        setDataToUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let tableView = object as? UITableView, tableView.tag == 100 {
            serviceInfoTableView.layer.removeAllAnimations()
            serviceTableViewHeightConstraint.constant = serviceInfoTableView.contentSize.height
        } else {
            questionAnsTableView.layer.removeAllAnimations()
            questionAnsTableViewHeightConstraint.constant = questionAnsTableView.contentSize.height
        }
        
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavBar(hidden: false)
        self.setNavigationBarColor(_theme.primaryColor, color: .white)
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func styleUI() {
        self.title = "Order Details"
        self.setUpViewShadow(self.orderDetailsView, backgroundColor: UIColor.white, radius: 11, shadowRadius: 10, isHavingBorder: false)
        self.customizeBackButton()
        
        
//        self.lblControllerTitle.textColor = _theme.primaryColor
//        self.btnBack.backgroundColor = .clear//roundCorners([.allCorners], radius: 45 / 2)
//        self.btnBack.setTitleColor(_theme.primaryColor, for: .normal)
//        self.btnBack.titleLabel?.font = _theme.smfFont(size: 28)
        
        self.serviceInfoTableView.delegate = self
        self.serviceInfoTableView.dataSource = self
        
        self.serviceInfoTableView.register(UINib.init(nibName: String.init(describing: EventDetailsTableViewCell.self), bundle: nil), forCellReuseIdentifier: "serviceDetail")
        
        self.questionAnsTableView.delegate = self
        self.questionAnsTableView.dataSource = self
        self.questionAnsTableView.rowHeight = UITableView.automaticDimension
        self.questionAnsTableView.estimatedRowHeight = 50
        self.questionAnsTableView.register(UINib.init(nibName: String.init(describing: QuestionAnsTableViewCell.self), bundle: nil), forCellReuseIdentifier: "qaCell")
        
        self.lblServiceID.textColor = _theme.eventIDTextColor
        
        self.lblServices.text = "Service Details"
        self.lblServices.font = _theme.muliFont(size: 16, style: .muliBold)
        self.lblServices.textColor = _theme.textColor
        
        self.lblQuestions.text = "Questions"
        self.lblQuestions.font = _theme.muliFont(size: 16, style: .muliBold)
        self.lblQuestions.textColor = _theme.textColor
    }
    
    func setDataToUI() {
        
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }

        viewModel.orderDetails.bindAndFire { [weak self] orderDetail in
            self?.updateView(with: orderDetail)
        }
        
        viewModel.serviceList.bindAndFire { [weak self] infoList in
            self?.updateServiceList()
        }
        
        viewModel.bidStatusInfoLoading.bindAndFire { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.orderDetailsView.isHidden = true
                    ProgressHUD.show()
                    print("Show Loader")
                } else {
                    self?.orderDetailsView.isHidden = false
//                    ProgressHUD.dismiss()
                    print("Hide Loader")
                }
            }
        }

                
        updateData()
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    func updateView(with model: QuestionareWrapperDTO?) {
        DispatchQueue.main.async {
            self.lblEventTitle.text = self.eventName
            self.lblServiceID.text = model?.eventServiceDescriptionId.description ?? ""
            self.lblEventValue.text = self.eventDate?.toSMFFullFormatDate()
            self.lblVenueZipValue.text = model?.venueAddress?.zipCode
            self.questionAnsTableView.reloadData()
            
            self.lblQuestions.isHidden = self.viewModel?.getQuestionDTO()?.count ?? 0 == 0
        }
    }
    
    func updateData() {
        viewModel?.fetchOrderDescription(eventId: eventId!, eventServiceDescId: eventServiceDescId!)
    }
    
    func updateServiceList() {
        DispatchQueue.main.async {
            self.serviceInfoTableView.reloadData()
        }
    }
    
    func updateQAList() {
        DispatchQueue.main.async {
            self.questionAnsTableView.reloadData()
            self.lblQuestions.isHidden = self.viewModel?.getQuestionDTO()?.count ?? 0 == 0
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.serviceInfoTableView {
            return viewModel?.serviceList.value.count ?? 0
        } else {
            return viewModel?.getQuestionDTO()?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.serviceInfoTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "serviceDetail") as? EventDetailsTableViewCell else {
                return UITableViewCell()
            }
            
            cell.backgroundColor = .clear
            
            let item = viewModel!.serviceList.value[indexPath.row]
            cell.lblTitle.text = item.title
            cell.lblValue.text = item.subTitle
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "qaCell") as? QuestionAnsTableViewCell else {
                return UITableViewCell()
            }
            
            let item: QuestionAns = viewModel!.getQuestionDTO()![indexPath.row]
            
            cell.lblQuestion.text = "Q\(indexPath.row + 1): \(item.questionMetadata.question)"
            cell.lblAnswer.text = "Answer: - \(item.questionMetadata.answer)"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.serviceInfoTableView {
            return UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension
        }
    }
}
