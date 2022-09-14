//
//  CalendarPickerViewController.swift
//  SMF-iOS
//
//  Created by Swapnil Dhotre on 25/05/22.
//

import UIKit
import FSCalendar
import ProgressHUD

protocol Event {
    var parentId: Int { get set }
}

class CalendarEventHeader: Event {
    var parentId: Int = -1
    
    var id: Int
    var title: String
    var fromDate: Date
    var toDate: Date
    var isExpanded: Bool
    var isEnabled: Bool
    var bookedSlots: [Event]
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
    
    var manuallySelectedDate: Date!
    
    static func create() -> CalendarPickerViewController {
        let controller = CalendarPickerViewController()
        
        let viewModel = CalendarPickerViewModelContainer()
        controller.viewModel = viewModel
        
        return controller
    }
    
    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        self.calendarTimeLineTableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        self.manuallySelectedDate = Date()
        
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
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.rightBarButtonItem = closeNavigationIcon()
//        self.customizeBackButton()
//        self.setStatusBarColor(_theme.primaryColor)
        self.setNavigationBarColor(_theme.primaryColor, color: UIColor.white)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.clearNavigationBar()
    }
    
    // MARK: - Setup layer
    func closeNavigationIcon() -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setTitle("x", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = _theme.smfFont(size: 22)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(self.backButtonAction(_:)), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
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
        
        self.btnAllServices.backgroundColor = .clear
        self.btnAllBranches.backgroundColor = .clear
        self.btnAllServices.titleLabel?.font = _theme.muliFont(size: 16, style: .muli)
        self.btnAllServices.setTitleColor(_theme.textColor, for: .normal)
        self.btnAllBranches.titleLabel?.font = _theme.muliFont(size: 16, style: .muli)
        self.btnAllBranches.setTitleColor(_theme.textColor, for: .normal)
        
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
//        self.calendarContainerView.setBorderedView(radius: 12)
        
        let selectedSegAttr: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        let segAttr: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: _theme.textGreyColor
        ]
        self.segmentControl.setTitleTextAttributes(selectedSegAttr, for: .selected)
        self.segmentControl.setTitleTextAttributes(segAttr, for: .normal)
        if #available(iOS 13.0, *) {
            self.segmentControl.selectedSegmentTintColor = _theme.accentColor
        } else {
            self.segmentControl.tintColor = _theme.accentColor
        }
        
        self.btnSwitch.onTintColor = _theme.primaryColor
    }
    
    func setUpCalendar() {
        self.fsCalendar.allowsMultipleSelection = true
        self.fsCalendar.select(manuallySelectedDate, scrollToDate: true)
        self.fsCalendar.backgroundColor = .clear
        
        self.fsCalendar.dataSource = self
        self.fsCalendar.delegate = self
        self.fsCalendar.register(CalendarDateCollectionViewCell.self, forCellReuseIdentifier: "cell")
        
        self.lblMonth.text = manuallySelectedDate.toString(with: "MMMM yyyy")
        
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
                
        // Service dropdown update listener
        dashboardViewModel?.selectedService.bindAndFire { [weak self] service in
            DispatchQueue.main.async {
                self?.btnAllServices.setTitle((service?.serviceName ?? "All Services") + "   ", for: .normal)
                self?.calendarTimeLineTableView.reloadData()
            }
        }
        
        // Branch dropdown update listener
        dashboardViewModel?.selectedBranch.bindAndFire { [weak self] branch in
            DispatchQueue.main.async {
                self?.btnAllBranches.setTitle((branch?.branchName ?? "All Branches") + "   ", for: .normal)
                self?.fetchCalendarEventsFor()
            }
        }
        
        // Branches fetched listener
        dashboardViewModel?.branches.bindAndFire{ [weak self] branches in
            if !branches.isEmpty {
                self?.dashboardViewModel?.selectedBranch.value = branches.first
            }
        }
        
        dashboardViewModel?.fetchServices()
        
        if let dashboardViewModel = dashboardViewModel, !dashboardViewModel.serviceList.value.isEmpty {
            dashboardViewModel.selectedService.value = dashboardViewModel.serviceList.value.first
            self.dashboardViewModel?.fetchBranches()
        }
        
        if let dashboardViewModel = dashboardViewModel, !dashboardViewModel.branches.value.isEmpty {
            dashboardViewModel.selectedBranch.value = dashboardViewModel.branches.value.first
        }
        
        // Calendar events fetch update listener
        viewModel.calendarEvents.bindAndFire { dates in
            DispatchQueue.main.async {
                if !viewModel.bookedSlotsLoading.value {
                    self.calendarTimeLineTableView.removeBlurLoader()
                }
                if !viewModel.calendarEventLoading.value {
                    print("Hide loader")
                    self.view.removeBlurLoader()
                }
                
                if (self.btnSwitch.isOn) {
                    self.showAllDatesAvailability(dates: dates)
                } else {
                    self.showEventDatesOnTimeLine(dates: dates)
                }
                
                self.fsCalendar.reloadData()
            }
        }
                
        // Timeline bookedSlot fetch update listener
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
                        calendarEvent.isLoading = false
                        
                        if firstSlot.parentId == calendarEvent.id {
                            calendarEvent.bookedSlots = slots
                            index = i
                            break
                        }
                    }
                }
                
                if index != -1 {
                    if let event = self.calendarEventHeaders[index] as? CalendarEventHeader {
                        self.calendarEventHeaders.removeAll(where: { slotEvent in
                            if slotEvent.parentId == event.id {
                                return true
                            } else {
                                return false
                            }
                        })
                        
                        self.calendarEventHeaders.insert(contentsOf: event.bookedSlots, at: index + 1)
                        (event.bookedSlots[event.bookedSlots.count - 1] as? BookedSlot)?.isLast = true
                    }
                }
                
                print("ReloadData")
                self.calendarTimeLineTableView.reloadData()
            }
        }
        
        // Calendar event loading listener
        viewModel.calendarEventLoading.bindAndFire { isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    print("Show loader")
                    self.view.showBlurLoader()
                }
            }
        }
        
        // TimeLine slot loading listener
        viewModel.bookedSlotsLoading.bindAndFire { isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self.calendarTimeLineTableView.showBlurLoader()
                }
            }
        }
    }
    
    // MARK: - Utility Methods
    func getWeekName(for firstDate: Date, lastDate: Date) -> String {
        return "\(firstDate.toString(with: "MMM dd EEE")) - \(lastDate.toString(with: "dd EEE"))"
    }
    
    func getMonthName(for firstDate: Date, lastDate: Date) -> String {
        return "\(firstDate.toString(with: "MMM dd EEE")) - \(lastDate.toString(with: "dd EEE"))"
    }
    
    func showEventDatesOnTimeLine(dates: [CalendarEvent]) {
        self.calendarEventHeaders.removeAll()
        if self.segmentControl.selectedSegmentIndex == 0 {
            for i in 0 ..< dates.count {
                let model = CalendarEventHeader(id: i, title: dates[i].date.toString(with: "MMM dd - EEEE"), fromDate: dates[i].date, toDate: dates[i].date, isExpanded: false, isEnabled: true, bookedSlots: [], isLoading: false)
                self.calendarEventHeaders.append(model)
            }
        } else if self.segmentControl.selectedSegmentIndex == 1 {
            let firstDayOfMonth = manuallySelectedDate.firstDayOfTheMonth()
            let lastDayOfMonth = manuallySelectedDate.lastDayOfMonth()
            
            var iteratorDate = firstDayOfMonth
            
            for i in 0 ..< 6 {
                let (firstDayOfWeek, lastDayOfWeek) = self.firstAndLastDayOfWeek(date: iteratorDate)
                if let firstDate = firstDayOfWeek, var lastDate = lastDayOfWeek {
                    if lastDate.compare(Date()) == .orderedAscending {
                        lastDate.addDays(n: 1)
                        iteratorDate = lastDate
                        continue;
                    }
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
            updateTimeLine(forMonth: dates)
        }
        
        self.calendarTimeLineTableView.reloadData()
    }
    
    func showAllDatesAvailability(dates: [CalendarEvent]) {
        self.calendarEventHeaders.removeAll()
        
        if self.segmentControl.selectedSegmentIndex == 0 {
            self.updateTimeLine(forDay: dates)
        } else if self.segmentControl.selectedSegmentIndex == 1 {
            self.updateTimeLine(forWeek: dates)
        } else if self.segmentControl.selectedSegmentIndex == 2 {
            self.updateTimeLine(forMonth: dates)
        }
        
        self.calendarTimeLineTableView.reloadData()
    }
    
    func updateTimeLine(forDay events: [CalendarEvent]) {
        var i = 0
        if var currentDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: manuallySelectedDate)) {
            let lastDay = currentDate.lastDayOfMonth()
            while true {
                let model = CalendarEventHeader(id: i, title: currentDate.toString(with: "MMM dd - EEEE"), fromDate: currentDate, toDate: currentDate, isExpanded: false, isEnabled: true, bookedSlots: [], isLoading: false)
                self.calendarEventHeaders.append(model)
                
                if currentDate.compare(lastDay) == .orderedSame {
                    break
                }
                
                currentDate.addDays(n: 1)
                i += 1
            }
        }
    }
    
    func updateTimeLine(forWeek events: [CalendarEvent]) {
        let currentDate = manuallySelectedDate
        let lastDayOfMonth = manuallySelectedDate.lastDayOfMonth()
        
        var iteratorDate: Date = currentDate!
        
        for i in 0 ..< 6 {
            let (firstDayOfWeek, lastDayOfWeek) = self.firstAndLastDayOfWeek(date: iteratorDate)
            if let firstDate = firstDayOfWeek, var lastDate = lastDayOfWeek {
                let model = CalendarEventHeader(
                    id: i,
                    title: self.getWeekName(for: firstDate, lastDate: lastDate),
                    fromDate: firstDate, toDate: lastDate, isExpanded: false, isEnabled: true, bookedSlots: [], isLoading: false)
                self.calendarEventHeaders.append(model)
                
                if lastDate > lastDayOfMonth {
                    break
                }
                lastDate.addDays(n: 1)
                iteratorDate = lastDate
            }
        }
    }
    
    func updateTimeLine(forMonth events: [CalendarEvent]) {
        let title = self.getMonthName(for: manuallySelectedDate, lastDate: manuallySelectedDate.lastDayOfMonth())
        let model = CalendarEventHeader(id: 0, title: title, fromDate: manuallySelectedDate, toDate: manuallySelectedDate.getAllDaysInMonth().last!, isExpanded: false, isEnabled: true, bookedSlots: [], isLoading: false)
        self.calendarEventHeaders.append(model)
    }
    
    func firstAndLastDayOfWeek(date: Date) -> (Date?, Date?) {
        return (date.startOfWeek, date.endOfWeek)
    }
    
    // MARK: - API Fetch
    func fetchCalendarEventsFor() {
        var fromDate: Date! = manuallySelectedDate
        var toDate: Date! = manuallySelectedDate
        
        var calendarHeaderId = 0
        
        if segmentControl.selectedSegmentIndex == 0 {
            fromDate = manuallySelectedDate
            toDate = manuallySelectedDate
            if (btnSwitch.isOn) {
                let firstItem = self.calendarEventHeaders.first { event in
                    if let calendarEvent = event as? CalendarEventHeader {
                        return calendarEvent.title == manuallySelectedDate.toString(with: "MMM dd - EEEE")
                    } else {
                        return false
                    }
                }
                (firstItem as! CalendarEventHeader).isExpanded = true
                calendarHeaderId = (firstItem as! CalendarEventHeader).id
            }
        } else if segmentControl.selectedSegmentIndex == 1 {
            (fromDate, toDate) = firstAndLastDayOfWeek(date: manuallySelectedDate)
            if (btnSwitch.isOn) {
                let firstItem = self.calendarEventHeaders.first { event in
                    if let calendarEvent = event as? CalendarEventHeader {
                        return calendarEvent.title == self.getWeekName(for: fromDate, lastDate: toDate)
                    } else {
                        return false
                    }
                }
                
                (firstItem as! CalendarEventHeader).isExpanded = true
                calendarHeaderId = (firstItem as! CalendarEventHeader).id
            }
        } else if segmentControl.selectedSegmentIndex == 2 {
            fromDate = manuallySelectedDate.firstDayOfTheMonth()
            toDate = manuallySelectedDate.lastDayOfMonth()
            if (btnSwitch.isOn) {
                let firstItem = self.calendarEventHeaders.first { event in
                    if let calendarEvent = event as? CalendarEventHeader {
                        return calendarEvent.title == self.getMonthName(for: manuallySelectedDate, lastDate: manuallySelectedDate.lastDayOfMonth())
                    } else {
                        return false
                    }
                }
                (firstItem as! CalendarEventHeader).isExpanded = true
                calendarHeaderId = (firstItem as! CalendarEventHeader).id
            }
        }
        
        if self.btnSwitch.isOn {
            viewModel?.fetchSlotsAvailability(
                calendarHeaderId: calendarHeaderId,
                categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId,
                onboardingVendorId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId,
                fromDate: fromDate,
                toDate: toDate,
                isMonth: segmentControl.selectedSegmentIndex == 2)
        } else {
            let firstDate = manuallySelectedDate.firstDayOfTheMonth()
            let lastDate = manuallySelectedDate.lastDayOfMonth()
            viewModel?.fetchCalendarEvents(
                categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId,
                onboardingVendorId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId,
                fromDate: firstDate, toDate: lastDate)
        }
    }
    
    func updateTimeLineEvent(isAvailable: Bool, slotTitle: String, fromDate: Date, toDate: Date) {
        var modifyFor: FetchDataForSegment
        switch segmentControl.selectedSegmentIndex {
        case 0:
            modifyFor = .day
            break
        case 1:
            modifyFor = .week
            break
        case 2:
            modifyFor = .month
            break
        default:
            modifyFor = .day
        }
        
        self.viewModel?.modifySlotAvailability(
            categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId,
            onboardingVendorId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId,
            fromDate: fromDate,
            toDate: toDate,
            fetchDataFor: modifyFor,
            isAvailable: isAvailable,
            modifiedSlot: slotTitle)
    }
    
    func networkChangeListener(connectivity: Bool, connectionType: String?) {
        //
    }
    
    // MARK: - Action Methods
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
            self.manuallySelectedDate = previousMonth
            self.showAllDatesAvailability(dates: [])
            self.fetchCalendarEventsFor()
        }
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        if let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: self.fsCalendar.currentPage) {
            self.fsCalendar.setCurrentPage(nextMonth, animated: true)
            self.manuallySelectedDate = nextMonth
            self.showAllDatesAvailability(dates: [])
            self.fetchCalendarEventsFor()
        }
    }
    
    @IBAction func btnSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            self.showAllDatesAvailability(dates: [])
        }
        self.fetchCalendarEventsFor()
    }
    
    @IBAction func segmentControlAction(_ sender: UISegmentedControl) {
        self.fsCalendar.selectedDates.forEach { date in
            self.fsCalendar.deselect(date)
        }
        
//        self.manuallySelectedDate = Date()
        switch sender.selectedSegmentIndex {
        case 0:
            self.fsCalendar.select(self.manuallySelectedDate, scrollToDate: true)
            break
        case 1:
            self.fsCalendar.selectWeek(date: self.manuallySelectedDate)
            break
        case 2:
            self.fsCalendar.selectMonth(date: self.manuallySelectedDate)
            break
        default:
            break
        }
        
        if self.btnSwitch.isOn {
            self.showAllDatesAvailability(dates: [])
        }
        
        self.fetchCalendarEventsFor()
        self.fsCalendar.reloadData()
    }
}

// MARK: - TableView Methods
extension CalendarPickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
            cell.btnChangeBooking.backgroundColor = .clear
            
            var title = ""
            event.slotEventDetails?.forEach({ slotEventDetail in
                if (title != "") {
                    title += "\n"
                }
                title += slotEventDetail.eventDate.formatDateStringTo(format: "MMM dd")
                title += ", \(slotEventDetail.eventName) Event"
                title += ", \(slotEventDetail.branchName)"
            })
            cell.setData(time: event.serviceSlot, bookedDescription: title, isLast: event.isLast)
            
            return cell
        } else if let event = self.calendarEventHeaders[indexPath.row] as? SlotAvailability {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "timeLineCell") as? CalendarTimeLineTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.delegate = self
            cell.btnChangeBooking.backgroundColor = .clear
            
            cell.indexPath = indexPath
            var bookedDesc: String?
            if (!event.slotEvents.isEmpty) {
                event.slotEvents.forEach { event in
                    if (bookedDesc != nil && bookedDesc != "") {
                        bookedDesc! += "\n"
                    }
                    var bookedDate = ""
                    if segmentControl.selectedSegmentIndex != 0 {
                        bookedDate = event.eventDate.formatDateStringTo(format: "MMM dd, ")
                    }
                    
                    bookedDesc = (bookedDesc ?? "") + bookedDate + event.eventName + " Event\n" + event.branchName
                }
            }

            cell.setData(time: event.serviceSlot, bookedDescription: bookedDesc, isLast: event.isLast, slotAvailable: event.isAvailable)
            
            return cell
        } else if let event = self.calendarEventHeaders[indexPath.row] as? EmptyData {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "emptyDataCell") as? CalendarEmptyDataTableViewCell else {
                return UITableViewCell()
            }
            
            cell.selectionStyle = .none
            cell.title.text = event.title
            
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
                    return bookedEvent.parentId == event.id                    
                }
                event.isExpanded = false
                self.calendarTimeLineTableView.reloadData()
            } else {
                self.calendarEventHeaders.insert(contentsOf: event.bookedSlots, at: indexPath.row + 1)
                event.isExpanded = true
                
                if self.btnSwitch.isOn {
                    let isMonth = self.segmentControl.selectedSegmentIndex == 2
                    self.viewModel?.fetchSlotsAvailability(calendarHeaderId: event.id,
                        categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId,
                        onboardingVendorId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId,
                        fromDate: event.fromDate,
                        toDate: event.toDate,
                        isMonth: isMonth)
                } else {
                    self.viewModel?.fetchBookedServiceSlots(
                        calendarHeaderId: event.id,
                        categoryId: dashboardViewModel?.selectedService.value?.serviceCategoryId,
                        onboardingVendorId: dashboardViewModel?.selectedBranch.value?.serviceVendorOnboardingId,
                        fromDate: event.fromDate, toDate: event.toDate)
                }
            }
        }
    }
    
    func collapseAllExpanded() {
        self.calendarEventHeaders.forEach { event in
             if let headerEvent = event as? CalendarEventHeader, headerEvent.isExpanded {
                self.calendarEventHeaders.removeAll { bookedEvent in
                    return bookedEvent.parentId == headerEvent.id
                }
                headerEvent.isExpanded = false
            }
        }
        self.calendarTimeLineTableView.reloadData()
    }
}

extension CalendarPickerViewController: CalendarTimeLineActionDelegate {
    func tapOnChangeAvailability(indexPath: IndexPath) {
        if let availability = self.calendarEventHeaders[indexPath.row] as? SlotAvailability {
            self.updateTimeLineEvent(isAvailable: !availability.isAvailable, slotTitle: availability.serviceSlot, fromDate: availability.fromDate, toDate: availability.toDate)
        }
    }
}

// MARK: - Calendar Methods
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
        if segmentControl.selectedSegmentIndex == 2 {
            calendar.selectedDates.forEach { date in
                calendar.deselect(date)
            }
            
            let dates = calendar.currentPage.getAllDaysInMonth()
            dates.forEach { date in
                calendar.select(date)
            }
            
            self.configureVisibleCells()
        }
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame.size.height = bounds.height
        //            self.eventLabel.frame.origin.y = calendar.frame.maxY + 10
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let currentDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))
        
        return (date.compare(currentDate!) != .orderedAscending) && monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(date.toString(with: "dd/MMM/yyyy"))")
        self.manuallySelectedDate = date
        
        if segmentControl.selectedSegmentIndex == 0 {
            calendar.selectedDates.forEach { date in
                calendar.deselect(date)
            }
    
            self.collapseAllExpanded()
            calendar.select(date)
        } else if segmentControl.selectedSegmentIndex == 1 {
            calendar.selectedDates.forEach { date in
                calendar.deselect(date)
            }
            
            let dates = date.getAllDaysInWeek()
            dates.forEach { date in
                calendar.select(date)
            }
            self.collapseAllExpanded()
        }
        
        self.fetchCalendarEventsFor()
        self.configureVisibleCells()
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did deselect date \(date.toString(with: "dd/MMM/yyyy"))")
        // Do nothing here
//        self.configureVisibleCells()
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
        
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return ColorConstant.greyColor3
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return ColorConstant.greyColor1
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

        if position == .current {            
            if Calendar.current.isDate(Date(), inSameDayAs: date) {
                dateCell.currentDateSelectionLayer.isHidden = false
            } else {
                dateCell.currentDateSelectionLayer.isHidden = true
            }
            
            let result = self.viewModel?.calendarEvents.value.contains(where: { event in
                return event.date.isSameDay(date: date)
            })
            dateCell.eventDateSelectionLayer.isHidden = (result ?? false) ? false : true
            
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
            dateCell.selectionLayer.isHidden = true
            dateCell.currentDateSelectionLayer.isHidden = true
        }
    }
}

