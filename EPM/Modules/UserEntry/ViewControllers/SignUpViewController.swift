//
//  SignUpViewController.swift
//  EPM
//
//  Created by lavanya on 02/11/21.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
      
    @IBOutlet weak var segmentedControl: SegmentedControl!
    {
        didSet {
            //Set this booleans to adapt control
            segmentedControl.itemsWithText = true
            segmentedControl.setSegmentedWith(items: ["Event Organizer", "Service Provider"])
            segmentedControl.bottomLineThumbView = true
            segmentedControl.fillEqually = true
            segmentedControl.titleFont = UIFont.init(name: "Montserrat-Medium", size: 18)
            segmentedControl.selectedTitleFont = UIFont.init(name: "Montserrat-Bold", size: 18)
            segmentedControl.padding = 3
            segmentedControl.selectedTextColor = #colorLiteral(red: 0.1790349483, green: 0.1902797818, blue: 0.3714042902, alpha: 1)
            segmentedControl.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            segmentedControl.thumbViewColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            segmentedControl.buttonColorForNormal =  #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            segmentedControl.buttonColorForSelected = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
   
    private var userDetailsViewModel : UserDetailsViewModel!
    private var dataSource : UserDetailsTableViewDataSource<UserDetailsTableViewCell,UserEntry>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableview.separatorStyle = UITableViewCell.SeparatorStyle.none
        //callToViewModelForUIUpdate()
        updateDataSource()
     }
    
    
    func callToViewModelForUIUpdate(){
        
        self.userDetailsViewModel =  UserDetailsViewModel()
        self.userDetailsViewModel.bindUserEntryViewModelToController = {
            self.updateDataSource()
        }
    }
    
    func updateDataSource(){
        
        self.dataSource = UserDetailsTableViewDataSource(configureCell: { (cell, evm) in
            print("done")
           })
        self.tableview.dataSource = self.dataSource
        self.tableview.reloadData()
    }
    

}
