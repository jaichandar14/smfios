//
//  OrderDetailViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 5/23/22.
//

import UIKit

class OrderDetailViewController: BaseViewController {

    @IBOutlet weak var lblControllerTitle: UILabel!
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblServiceID: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblEventDateTitle: UILabel!
    @IBOutlet weak var lblEventValue: UILabel!
    @IBOutlet weak var lblVenueZipTitle: UILabel!
    @IBOutlet weak var lblVenueZipValue: UILabel!
    
    @IBOutlet weak var orderDetailsView: UIView!
    @IBOutlet weak var serviceInfoTableView: UITableView!
    @IBOutlet weak var questionAnsTableView: UITableView!
    @IBOutlet weak var questionAnsTableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var serviceTableViewHeightConstraint: NSLayoutConstraint!
    
    var bidRequestId: Int?
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
        
        setNavBar(hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        setNavBar(hidden: false)
    }
    
    func styleUI() {
        setUpViewShadow(self.orderDetailsView, backgroundColor: UIColor.white, radius: 15, shadowRadius: 10, isHavingBorder: false)
        
        self.btnBack.roundCorners([.allCorners], radius: 45 / 2)
        
        self.serviceInfoTableView.delegate = self
        self.serviceInfoTableView.dataSource = self
        
        self.serviceInfoTableView.register(UINib.init(nibName: String.init(describing: EventDetailsTableViewCell.self), bundle: nil), forCellReuseIdentifier: "serviceDetail")
        
        self.questionAnsTableView.delegate = self
        self.questionAnsTableView.dataSource = self
        self.questionAnsTableView.rowHeight = UITableView.automaticDimension
        self.questionAnsTableView.estimatedRowHeight = 50
        self.questionAnsTableView.register(UINib.init(nibName: String.init(describing: QuestionAnsTableViewCell.self), bundle: nil), forCellReuseIdentifier: "qaCell")
    }
    
    func setDataToUI() {
        
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }

        viewModel.bidStatus.bindAndFire { [weak self] bidStatusInfo in
            self?.updateView(with: bidStatusInfo)
        }
        
        viewModel.serviceList.bindAndFire { [weak self] infoList in
            self?.updateServiceList()
        }
        
        viewModel.bidStatusInfoLoading.bindAndFire { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.orderDetailsView.isHidden = true
                    self?.showLoader()
                } else {
                    self?.orderDetailsView.isHidden = false
                    self?.hideLoader()
                }
            }
        }
        
        viewModel.questionAnsList.bindAndFire { [weak self] infoList in
            self?.updateQAList()
        }
                
        updateData()
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    func updateView(with model: BidStatusInfo?) {
        DispatchQueue.main.async {
            self.lblEventTitle.text = model?.eventName
            self.lblServiceID.text = model?.eventServiceDescriptionId.description ?? ""
            self.lblEventValue.text = model?.eventDate.toSMFDateFormat()
            self.lblVenueZipValue.text = model?.serviceAddressDto.zipCode
        }
    }
    
    func updateData() {
        viewModel?.fetchBidDetailsList(bidRequestId: self.bidRequestId!)
    }
    
    func updateServiceList() {
        DispatchQueue.main.async {
            self.serviceInfoTableView.reloadData()
        }
    }
    
    func updateQAList() {
        DispatchQueue.main.async {
            self.questionAnsTableView.reloadData()
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
            return viewModel?.questionAnsList.value.count ?? 0
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
            
            let item = viewModel!.questionAnsList.value[indexPath.row]
            cell.lblQuestion.text = item.question
            cell.lblAnswer.text = item.ans
            
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
