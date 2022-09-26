//
//  CountryPickerViewController.swift
//  SMF-iOS
//
//  Created by Swapnil_Dhotre on 8/23/22.
//

import UIKit

class CountryPickerViewController: BaseViewController {
    @IBOutlet weak var textFieldSearch: UITextField!
    @IBOutlet weak var tableViewCountryPicker: UITableView!
    
    var countryPicked: ((Country) -> Void)?
    
    var _searchedCountries: [Country] = []
    var _countries: [Country] = []
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._countries = LoginViewModel(loginModel: LoginModel()).countries;
        self._searchedCountries = self._countries
    }
    
    func styleUI() {
        self.tableViewCountryPicker.delegate = self
        self.tableViewCountryPicker.dataSource = self
        self.tableViewCountryPicker.register(UINib(nibName: "CountryFlagTableViewCell", bundle: nil), forCellReuseIdentifier: "country_flag_cell")
        
        self.textFieldSearch.delegate = self
        self.textFieldSearch.addTarget(self, action: #selector(self.searchTextDidChanged(_:)), for: .editingChanged)
    }
    
    @objc func searchTextDidChanged(_ textField: UITextField) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(self.delayedSearchText), userInfo: nil, repeats: false)
    }
    
    @objc func delayedSearchText() {
        let currentText = (self.textFieldSearch.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if currentText.isEmpty {
            self._searchedCountries = self._countries
        } else {
            self._searchedCountries = self._countries.filter { country in
                return country.title.containsIgnoringCase(find: currentText)
            }
        }
        
        self.tableViewCountryPicker.reloadData()
    }
    
    func setDataToUI() {
        //
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        //
    }
    
}

extension CountryPickerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

extension CountryPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._searchedCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let countryCell = tableView.dequeueReusableCell(withIdentifier: "country_flag_cell") as? CountryFlagTableViewCell else { return UITableViewCell() }
        
        countryCell.lblCountryName.text = self._searchedCountries[indexPath.row].title
        countryCell.imageViewFlag.image = Country.flag(forCountryCode: (self._searchedCountries[indexPath.row].iso2)).image()
        countryCell.selectionStyle = .none
        
        return countryCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.countryPicked?(self._searchedCountries[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
