//
//  CalendarPickerViewController.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 25/05/22.
//

import UIKit
import FSCalendar
import ProgressHUD

protocol Event { }

class CalendarEventHeader: Event {
    var id: Int
    var title: String
    var fromDate: Date
    var toDate: Date
    var isExpanded: Bool
    var isEnabled: Bool
    var bookedSlots: [BookedSlot]
    var isLoading: Bool
    
    init(id: Int, title: String, fromDate: Date, toDate: Date, isExpanded: Bool, isEnabled: Bool, bookedSlots: [BookedSlot], isLoading: Bool) {
        self.id = id
        self.title = title
        self.fromDate = fromDate
        self.toDate = toDate
        self.isExpanded = isExpanded
        self.isEnabled = isEnabled
        self.bookedSlots = bookedSlots
        self.isLoading = isLoading
    }
}

class CalendarPickerViewController: BaseViewController {
    @IBOutlet weak var lblCalendarTitle: UILabel!
    @IBOutlet weak var btnAllServices: UIButton!
    @IBOutlet weak var btnAllBranches: UIButton!
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var calendarContainerView: UIView!
    @IBOutlet weak var btnSwitch: UISwitch!
    
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblSwitchToModify: UILabel!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var slotTableViewContainer: UIView!
    @IBOutlet weak var calendarTimeLineTableView: UITableView!
    
    @IBOutlet weak var timeLineHeightConstraint: NSLayoutConstraint!
    
    private var firstDate: Date?
    private var secondDate: Date?
    
    private var dateSelected: [Date]?
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    private var calendarEventHeaders: [Event] = []
    
    var viewModel: CalendarPickerViewModel? {
        didSet {
            setDataToUI()
        }
    }
    
    var dashboardViewModel: DashboardViewModel?
    
    static func create() -> CalendarPickerViewController {
        let controller = CalendarPickerViewController()
        
        let viewModel = CalendarPickerViewModelContainer()
        controller.viewModel = viewModel
        
        return controller
    }
    
    override func viewDidLoad() {
        self.calendarTimeLineTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        super.viewDidLoad()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        calendarTimeLineTableView.layer.removeAllAnimations()
        timeLineHeightConstraint.constant = calendarTimeLineTableView.contentSize.height
        
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.customizeBackButton()
        //        self.setNavBar(hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //        self.setNavBar(hidden: false)
    }
    
    func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func styleUI() {
        self.title = "Calendar"
        
        self.lblCalendarTitle.font = _theme.muliFont(size: 20, style: .muliBold)
        self.lblCalendarTitle.textColor = _theme.textColor
        
        self.lblSwitchToModify.font = _theme.muliFont(size: 16, style: .muliSemiBold)
        self.lblSwitchToModify.textColor = _theme.textColor
        
        self.btnAllServices.setBorderedButton(textColor: _theme.textColor)
        self.btnAllBranches.setBorderedButton(textColor: _theme.textColor)
        
        self.lblMonth.font = _theme.muliFont(size: 18, style: .muliSemiBold)
        self.lblMonth.textColor = _theme.textColor
        
        self.btnPrevious.setTitle("l", for: .normal)
        self.btnPrevious.setTitleColor(_theme.textColor, for: .normal)
        self.btnPrevious.titleLabel?.font = _theme.smfFont(size: 18)
        self.btnPrevious.backgroundColor = .clear
        
        self.btnNext.setTitle("r", for: .normal)
        self.btnNext.setTitleColor(_theme.textColor, for: .normal)
        self.btnNext.titleLabel?.font = _theme.smfFont(size: 18)
        self.btnNext.backgroundColor = .clear
        
        self.calendarTimeLineTableView.delegate = self
        self.calendarTimeLineTableView.dataSource = self
        
        self.calendarTimeLineTableView.register(UINib.init(nibName: String.init(describing: CalendarTimeLineTableViewCell.self), bundle: nil), forCellReuseIdentifier: "timeLineCell")
        self.calendarTimeLineTableView.register(UINib.init(nibName: String.init(describing: CalendarExpandCollapseTableViewCell.self), bundle: nil), forCellReuseIdentifier: "expandCollapseCell")
        self.calendarTimeLineTableView.register(UINib.init(nibName: String.init(describing: CalendarEmptyDataTableViewCell.self), bundle: nil), forCellReuseIdentifier: "emptyDataCell")
        self.calendarTimeLineTableView.rowHeight = UITableView.automaticDimension
        self.calendarTimeLineTableView.estimatedRowHeight = 50
        
        self.setUpCalendar()
        self.calendarContainerView.setBorderedView(radius: 12)
        
        self.btnSwitch.onTintColor = _theme.primaryColor
    }
    
    func setUpCalendar() {
        self.fsCalendar.allowsMultipleSelection = true
        self.fsCalendar.select(Date(), scrollToDate: true)
        
        self.fsCalendar.dataSource = self
        self.fsCalendar.delegate = self
        self.fsCalendar.register(CalendarDateCollectionViewCell.self, forCellReuseIdentifier: "cell")
        
        self.lblMonth.text = Date().toString(with: "MMMM yyyy")
        
        self.fsCalendar.headerHeight = 0
        self.fsCalendar.reloadData()
    }
    
    func setDataToUI() {
        if !isViewLoaded {
            return
        }
        
        guard let viewModel = viewModel else {
            return
        }
        
        dashboardViewModel?.selectedService.bindAndFire { service in
            self.btnAllServices.setTitle((service?.serviceName ?? "All Services") + "   ", for: .normal)
            self.calendarTimeLineTableView.reloadData()
        }
        
        dashboardViewModel?.selectedBranch.bindAndFire { branch in
            self.btnAllBranches.setTitle((branch?.branchName ?? "All Branches") + "   ", for: .normal)
        }
        
        dashboardViewModel?.fetchServices()
        
        viewModel.calendarEvents.bindAndFire { dates in
            DispatchQueue.main.async {
                if !viewModel.bookedSlotsLoading.value {
                    self.calendarTimeLineTableView.removeBlurLoader()
                }
                if !viewModel.calendarEventLoading.value {
                    print("Hide loader")
                    self.view.removeBlurLoader()
                }
                
                self.calendarEventHeaders.removeAll()
                if self.segmentControl.selectedSegmentIndex == 0 {
                    for i in 0 ..< dates.count {
                        let model = CalendarEventHeader(id: i, title: dates[i].date.toString(with: "MMM dd - EEEE"), fromDate: dates[i].date, toDate: dates[i].date, isExpanded: false, isEnabled: (i == 2) ? false : true, bookedSlots: [], isLoading: false)
                        self.calendarEventHeaders.append(model)
                    }
                } else if self.segmentControl.selectedSegmentIndex == 1 {
                    let firstDayOfMonth = Date().firstDayOfTheMonth()
                    let lastDayOfMonth = Date().lastDayOfMonth()
                    
                    var iteratorDate = firstDayOfMonth
                    
                    for i in 0 ..< 6 {
                        let (firstDayOfWeek, lastDayOfWeek) = self.firstAndLastDayOfWeek(date: iteratorDate)
                        if let firstDate = firstDayOfWeek, var lastDate = lastDayOfWeek {
                            let model = CalendarEventHeader(
                                id: i,
                                title: "\(firstDate.toString(with: "MMM dd EEE")) - \(lastDate.toString(with: "dd EEE"))",
                                fromDate: firstDate, toDate: lastDate, isExpanded: false, isEnabled: (i == 2) ? false : true, bookedSlots: [], isLoading: false)
                            self.calendarEventHeaders.append(model)
                            
                            lastDate.addDays(n: 1)
                            if lastDate > lastDayOfMonth {
                                break
                            } else {
                                iteratorDate = lastDate
                            }
                        }
                    }
                    
                    print("Check weeks")
                } else if self.segmentControl.selectedSegmentIndex == 2 {
                    let title = "\(Date().toString(with: "MMM dd EEE")) - \(Date().getAllDaysInMonth().last!.toString(with: "dd EEE"))"
                    let model = CalendarEventHeader(id: 0, title: title, fromDate: Date(), toDate: Date().getAllDaysInMonth().last!, isExpanded: false, isEnabled: true, bookedSlots: [], isLoading: false)
                    self.calendarEventHeaders.append(model)
                }
                
                self.fsCalendar.reloadData()
                self.calendarTimeLineTableView.reloadData()
            }
        }
        
//        viewModel.dayCount.bindAndFire { dayCount in
//            DispatchQueue.main.async {
//                self.segmentControl.setTitle("Day (\(dayCount))", forSegmentAt: 0)
//            }
//        }
//
//        viewModel.weekCount.bindAndFire { weekCount in
//            DispatchQueue.main.async {
//                self.segmentControl.setTitle("Week (\(weekCount))", forSegmentAt: 1)
//            }
//        }
//
//        viewModel.monthCount.bindAndFire { monthCount in
//            DispatchQueue.main.async {
//                self.segmentControl.setTitle("Month (\(monthCount))", forSegmentAt: 2)
//            }
//        }
        
        fetchCalendarEventsFor()
        
        viewModel.bookedSlots.bindAndFire { slots in
            DispatchQueue.main.async {
                if !viewModel.bookedSlotsLoading.value {
                    self.calendarTimeLineTableView.removeBlurLoader()
                }
                
                print("Set Data")
                var index = -1
                for i in 0 ..< self.calendarEventHeaders.count {
                    if let firstSlot = slots.first,
                       let calendarEvent = self.calendarEventHeaders[i] as? CalendarEventHeader {
                        firstSlot.parentId == calendarEvent.id
                        
                        calendarEvent.isLoading = false
                        calendarEvent.bookedSlots = slots
                        index = i
                    }
                }
                
                if index != -1 {
                    if let event = self.calendarEventHeaders[index] as? CalendarEventHeader {
                        self.calendarEventHeaders.removeAll(where: { slotEvent in
                            if let slotEvent = slotEvent as? BookedSlot, slotEvent.parentId == event.id {
                                return true
                            } else {
                                return false
                            }
                        })
                        event.bookedSlots[event.bookedSlots.count - 1].isLast = true
                        self.calendarEventHeaders.insert(contentsOf: event.bookedSlots, at: index + 1)
                    }
                }
                
                print("ReloadData")
                self.calendarTimeLineTableView.reloadData()
            }
        }
        
        viewModel.calendarEventLoading.bindAndFire { isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    print("Show loader")
                    self.view.showBlurLoader()
                }
            }
        }
        
        viewModel.bookedSlotsLoading.bindAndFire { isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self.calendarTimeLineTableView.showBlurLoader()
                }
            }
        }
    }
    
    func firstAndLastDayOfWeek(date: Date) -> (Date?, Date?) {
        return (date.startOfWeek, date.endOfWeek)
    }
    
    func fetchCalendarEventsFor() {
        let fromDate = Date()
        let toDate = Date().getAllDaysInMonth().last
        
        viewModel?.fetchCalendarEvents(
            categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId,
            onboardingVendorId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId,
            fromDate: fromDate, toDate: toDate)
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    @IBAction func btnAllServices(_ sender: UIButton) {
        var services = dashboardViewModel!.serviceList.value.map { $0.serviceName }
        services.insert("All Services", at: 0)
        showDropDown(on: sender, items: services) { [weak self] (index, item) in
            if index == 0 {
                self?.dashboardViewModel?.selectedService.value = nil
            } else {
                self?.dashboardViewModel?.selectedService.value = self?.dashboardViewModel?.getServiceItem(for: index - 1)
            }
            self?.dashboardViewModel?.fetchBranches()
            self?.fetchCalendarEventsFor()
        }
    }
    
    @IBAction func btnAllBranches(_ sender: UIButton) {
        var branches = dashboardViewModel!.branches.value.map { $0.branchName }
        branches.insert("All Branches", at: 0)
        showDropDown(on: sender, items: branches) { [weak self] (index, item) in
            if index == 0 {
                self?.dashboardViewModel?.selectedBranch.value = nil
            } else {
                self?.dashboardViewModel?.selectedBranch.value = self?.dashboardViewModel?.getBranchItem(for: index - 1)
            }
            self?.fetchCalendarEventsFor()
        }
    }
    
    @IBAction func btnPreviousAction(_ sender: UIButton) {
        if let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self.fsCalendar.currentPage) {
            self.fsCalendar.setCurrentPage(previousMonth, animated: true)
        }
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        if let previousMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.fsCalendar.currentPage) {
            self.fsCalendar.setCurrentPage(previousMonth, animated: true)
        }
    }
    
    @IBAction func btnSwitchAction(_ sender: UISwitch) {
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        self.fsCalendar.selectedDates.forEach { date in
            self.fsCalendar.deselect(date)
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.fsCalendar.select(Date(), scrollToDate: true)
            break
        case 1:
            self.fsCalendar.selectWeek()
            break
        case 2:
            self.fsCalendar.selectMonth()
            break
        default:
            break
        }
        
        self.fetchCalendarEventsFor()
        self.fsCalendar.reloadData()
    }
}

extension CalendarPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var total = 0
//        self.calendarEventHeaders.forEach({ event in
//            if let event = event as? CalendarEventHeader {
//                if (event.isExpanded) {
//                    total += event.bookedSlots.count == 0 ? 1 : event.bookedSlots.count
//                }
//            }
//        })
        
        return self.calendarEventHeaders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let event = self.calendarEventHeaders[indexPath.row] as? CalendarEventHeader {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "expandCollapseCell") as? CalendarExpandCollapseTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.setData(title: event.title, isEnabled: event.isEnabled, isExpanded: event.isExpanded)
            
            return cell
        } else if let event = self.calendarEventHeaders[indexPath.row] as? BookedSlot {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell") as? CalendarTimeLineTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            var title = ""
            if let slotEventDetail = event.slotEventDetails?.first {
                title += slotEventDetail.eventDate.formatDateStringTo(format: "MMM dd")
                title += ", \(slotEventDetail.eventName) Event"
                title += ", \(slotEventDetail.branchName)"
            }
            cell.setData(time: event.serviceSlot, bookedDescription: title, isLast: event.isLast)
            
            return cell
        } else if let event = self.calendarEventHeaders[indexPath.row] as? EmptyData {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "emptyDataCell") as? CalendarEmptyDataTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.tit
            
            return cell
            
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let event = self.calendarEventHeaders[indexPath.row] as? CalendarEventHeader {
            if event.isExpanded {
                self.calendarEventHeaders.removeAll { bookedEvent in
                    if let bookedEvent = bookedEvent as? BookedSlot {
                        return bookedEvent.parentId == event.id
                    } else {
                        return false
                    }
                }
                event.isExpanded = false
                self.calendarTimeLineTableView.reloadData()
            } else {
                self.calendarEventHeaders.insert(contentsOf: event.bookedSlots, at: indexPath.row + 1)
                event.isExpanded = true
                self.viewModel?.fetchBookedServiceSlots(
                    calendarHeaderId: event.id,
                    categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId,
                    onboardingVendorId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId,
                    fromDate: event.fromDate, toDate: event.toDate)
            }
        }
    }
}

extension CalendarPickerViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        self.configure(cell: cell, for: date, at: position)
    }
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let result = self.viewModel?.calendarEvents.value.contains(where: { event in
            return event.date.isSameDay(date: date)
        })
        return (result ?? false) ? 1 : 0
    }
    
    // MARK:- FSCalendarDelegate
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.lblMonth.text = calendar.currentPage.toString(with: "MMMM yyyy")
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame.size.height = bounds.height
        //            self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(date.toString(with: "dd/MMM/yyyy"))")
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did deselect date \(date.toString(with: "dd/MMM/yyyy"))")
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.orange]
        }
        if self.fsCalendar.selectedDates.contains(date) {
            return [UIColor.white]
        }
        return [appearance.eventDefaultColor]
    }
    
    private func configureVisibleCells() {
        //        fsCalendar.calendarHeaderView.collectionView.visibleCells.forEach { cell in
        //            cell.isHidden = true
        //        }
        fsCalendar.visibleCells().forEach { (cell) in
            let date = fsCalendar.date(for: cell)
            let position = fsCalendar.monthPosition(for: cell)
            self.configure(cell: cell, for: date!, at: position)
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        
        let dateCell = (cell as! CalendarDateCollectionViewCell)
        // Custom today circle
        //        dateCell.circleImageView.isHidden = !self.gregorian.isDateInToday(date)
        // Configure selection layer
        if position == .current {
            
            var selectionType = SelectionType.none
            if fsCalendar.selectedDates.contains(date) {
                let previousDate = self.gregorian.date(byAdding: .day, value: -1, to: date)!
                let nextDate = self.gregorian.date(byAdding: .day, value: 1, to: date)!
                if fsCalendar.selectedDates.contains(date) {
                    if fsCalendar.selectedDates.contains(previousDate) && fsCalendar.selectedDates.contains(nextDate) {
                        selectionType = .middle
                    } else if fsCalendar.selectedDates.contains(previousDate) && fsCalendar.selectedDates.contains(date) {
                        selectionType = .rightBorder
                    } else if fsCalendar.selectedDates.contains(nextDate) {
                        selectionType = .leftBorder
                    } else {
                        selectionType = .single
                    }
                }
            } else {
                selectionType = .none
            }
            if selectionType == .none {
                dateCell.selectionLayer.isHidden = true
                return
            }
            dateCell.selectionLayer.isHidden = false
            dateCell.selectionType = selectionType
            
        } else {
            //            dateCell.circleImageView.isHidden = true
            dateCell.selectionLayer.isHidden = true
        }
    }
}

