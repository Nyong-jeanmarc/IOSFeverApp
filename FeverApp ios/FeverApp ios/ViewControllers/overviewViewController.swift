//
//  overviewViewController.swift
//  FeverApp ios
//
//  Created by NEW on 20/08/2024.
//

//
//  overviewViewController.swift
//  FeverApp ios
//
//  Created by NEW on 13/08/2024.
//

import UIKit
import DGCharts
import CoreData
extension Date {
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self)
    }
}
// Add the ListViewUI class here or import it if it's in a separate file
class ListViewUI: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    var groupData: [GroupData] = sampleGroupData // Use sample data
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: "GroupCell")
        view.addSubview(tableView)
    }
    
    // TableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let group = groupData[section]
        return group.feverPhases.count + group.entriesNotBelongingToAFeverPhase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
        let group = groupData[indexPath.section]
        
        if indexPath.row < group.feverPhases.count {
            let feverPhase = group.feverPhases[indexPath.row]
            cell.configureForFeverPhase(feverPhase)
        } else {
            let entryIndex = indexPath.row - group.feverPhases.count
            let entry = group.entriesNotBelongingToAFeverPhase[entryIndex]
            cell.configureForEntry(entry)
        }
        
        return cell
    }
}

// Cell class for Group Data
class GroupTableViewCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        subtitleLabel.font = UIFont.systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configureForFeverPhase(_ feverPhase: FeverPhase) {
        titleLabel.text = "Fever Phase \(feverPhase.feverPhaseId)"
        subtitleLabel.text = "Start Date: \(feverPhase.feverPhaseStartDate) - End Date: \(feverPhase.feverPhaseEndDate)"
    }
    
    func configureForEntry(_ entry: Entry) {
        titleLabel.text = "Entry \(entry.entryId)"
        subtitleLabel.text = "Entry Date: \(entry.entryDate)"
    }
}
// Custom formatter for temperature labels
class TemperatureValueFormatter: ValueFormatter {
    let yAxisValues: [String]

    init(yAxisValues: [String]) {
        self.yAxisValues = yAxisValues
    }

    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        // Get the integer part of the value as the index
        let index = Int(floor(value))
        let decimalPart = value - Double(index)
        
        // Check if index is within bounds of yAxisValues array
        if index >= 1 && index < yAxisValues.count - 1 {
            // Extract base temperatures
            let baseTemp = parseTemperature(from: yAxisValues[index])
            let nextTemp = parseTemperature(from: yAxisValues[index + 1])
            
            // If there's a decimal part, interpolate between the two values
            if decimalPart > 0 {
                let interpolatedTemp = baseTemp + (nextTemp - baseTemp) * decimalPart
                return String(format: "%.1f°C", interpolatedTemp)
            } else {
                // No decimal part, return the exact temperature
                return yAxisValues[index]
            }
        }
        
        return ""
    }
    
    // Helper function to parse temperature values from yAxisValues (e.g., "36°C" -> 36.0)
    private func parseTemperature(from label: String) -> Double {
        return Double(label.replacingOccurrences(of: "°C", with: "")) ?? 0.0
    }
}
class overviewViewController: UIViewController, UITextFieldDelegate, ProfileListDelegate , AddEntryDelegate, UITableViewDelegate, UITableViewDataSource, ChartViewDelegate{
    func didDismissAddEntryController() {
        print("AddEntryController was dismissed. Reloading data...")
        
        // Fetch the updated profile name and refresh the label
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        let profileId = appDelegate.fetchProfileId()
        profileNameLabel.text = profileName

        // Refresh other parts of the view if necessary
        setupScrollView()
//        setupYGradient()
//        configureCharts(numberOfCharts: 3) // Configure 3 charts for example
//        // Initial checkbox setup
//               updateCheckBox()
//               
//               // Add target for checkbox toggle
//               toggleCheckBox.addTarget(self, action: #selector(toggleCheckBoxAction), for: .touchUpInside)
        
        checkEntriesBelongingToFeverPhase()
        hasEntries = checkIfProfileHasEntries(profileId: profileId!)
        // Initial setup for listView
        setupListView()

    }
    
    
    func didDismissProfileList() {
        print("ProfileListViewController was dismissed. Reloading data...")
        
        // Fetch the updated profile name and refresh the label
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileName = appDelegate.fetchProfileName()
        profileNameLabel.text = profileName
        let profileId = appDelegate.fetchProfileId()
        hasEntries = checkIfProfileHasEntries(profileId: profileId!)
        // Refresh other parts of the view if necessary
        setupListView()
        
    }
    
    var chartViews: [UIView] = [] // Store references to multiple charts
    @IBOutlet var segmentControl: UISegmentedControl!
    
    @IBOutlet var graphViewScrollView: UIScrollView!
    
    @IBOutlet var graphButtonView: UIView!
    
    
    @IBOutlet var toggleCheckBox: UIButton!
    
    @IBOutlet var dateButton: UIButton!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var mainGraphView: UIView!
    
    @IBOutlet var listView: UIView!
    
    @IBOutlet var graphView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var nameView: UIView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    
    @IBOutlet var recoveredButton: UIButton!
    
    let customTabBar = CustomTabBarView()
    @IBAction func recoveredButtonTapped(_ sender: Any) {
        // Fetch the updated profile name and refresh the label
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let profileId = appDelegate.fetchProfileId()
    
        feverPhaseNetworkManager.shared.createNewFeverPhaseAndAssignEntries(profileId: profileId!)
        didDismissAddEntryController()
        // cancel notification
        LocalNotificationManager.shared.cancelNotifications()
    }
    

    @IBAction func profileListDropDownTapped(_ sender: UIButton) {
//        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "profileList")
//        viewController.modalPresentationStyle = .fullScreen
//        self.present(viewController, animated: true, completion: nil)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let AddProfileNameVC = storyboard.instantiateViewController(withIdentifier: "profileList") as? ProfileListViewController {
            AddProfileNameVC.delegate = self // Assign delegate
            let navigationController = UINavigationController(rootViewController: AddProfileNameVC)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var bottomView: UIView!
    
//    let profileName: String = "Sharon"
    
    
    @IBAction func addEntryTapped(_ sender: Any) {
        AddEntryNetworkManager.shared.createLocalEntry(){ isSuccesfull in
            if isSuccesfull{
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEntryViewController") as! AddEntryController
                viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Error", message: "Failed to create entry. Please try again.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        }
        // schedule notification
        LocalNotificationManager.shared.scheduleReminderNotifications(startingFrom: Date())
    }

    @objc func firstEntryTapped(){
        print("first entry button tapped")
        AddEntryNetworkManager.shared.createLocalEntry(){ isSuccesfull in
            if isSuccesfull{
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEntryViewController") as! AddEntryController
                viewController.delegate = self
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Error", message: "Failed to create entry. Please try again.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
        }
        // schedule notification
        LocalNotificationManager.shared.scheduleReminderNotifications(startingFrom: Date())
    }
       let feverPhaseButton = UIButton(type: .system)
       private let dropdownTableView = UITableView()
       private var isDropdownVisible = false
    // copy here
    private func updateFeverPhaseButtonTitle() {
        if let entriesWithoutFeverPhases = entriesWithoutFeverPhases, !entriesWithoutFeverPhases.isEmpty {
            // If `entriesWithoutFeverPhases` is not empty
            feverPhaseButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARY-CHART.TEXT.3", defaultText: "Ongoing fever phase"), for: .normal)
        } else if let firstFeverPhase = feverPhases?.first {
            // If `entriesWithoutFeverPhases` is empty, show the first fever phase
            let startDate = firstFeverPhase.feverPhaseStartDate?.formattedDate() ?? "N/A"
            let endDate = firstFeverPhase.feverPhaseEndDate?.formattedDate() ?? "N/A"
            feverPhaseButton.setTitle("Fever phase: \(startDate) - \(endDate)", for: .normal)
        } else {
            // Fallback in case `feverPhases` is also empty
            feverPhaseButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARY-CHART.TEXT.3", defaultText: "Ongoing fever phase"), for: .normal)
        }
    }
    
    @IBOutlet weak var moreIcon: UIImageView!
    
    private func setupFeverPhaseButton() {
        // Configure the button
        updateFeverPhaseButtonTitle()
           feverPhaseButton.setTitleColor(.darkGray, for: .normal)
           feverPhaseButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
           feverPhaseButton.backgroundColor = .clear
           feverPhaseButton.layer.cornerRadius = 8
           feverPhaseButton.layer.borderWidth = 1
        feverPhaseButton.layer.borderColor = UIColor.clear.cgColor
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .medium) // Adjust point size
           // Add the dropdown icon using an SF Symbol
        let dropdownIcon = UIImage(systemName: "arrowtriangle.down.fill", withConfiguration: iconConfig)
           feverPhaseButton.setImage(dropdownIcon, for: .normal)
           feverPhaseButton.tintColor = .darkGray

           // Position the icon to the right of the text
           feverPhaseButton.semanticContentAttribute = .forceRightToLeft
           feverPhaseButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
           // Add action for dropdown toggle
           feverPhaseButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
           // Add the button to the view
           feverPhaseButton.translatesAutoresizingMaskIntoConstraints = false
        graphView.addSubview(feverPhaseButton)
           // Button constraints
           NSLayoutConstraint.activate([
            feverPhaseButton.topAnchor.constraint(equalTo: dateButton.topAnchor, constant: 0),
               feverPhaseButton.trailingAnchor.constraint(equalTo: graphView.trailingAnchor, constant: -5),
               feverPhaseButton.widthAnchor.constraint(equalToConstant: 200),
               feverPhaseButton.heightAnchor.constraint(equalToConstant: 40)
           ])
       }
    let dropdownContainerView = UIView()
    private func setupDropdownTableView() {
        // Create a parent view to hold the table view
      
        dropdownContainerView.layer.shadowColor = UIColor.gray.cgColor
        dropdownContainerView.layer.shadowOpacity = 0.6
        dropdownContainerView.layer.shadowOffset = CGSize(width: 0, height: 3) // Shadow position
        dropdownContainerView.layer.shadowRadius = 3 // Blur radius of the shadow
        dropdownContainerView.layer.cornerRadius = 15 // Match the corner radius of the table view
        dropdownContainerView.layer.masksToBounds = false // Ensure shadow is visible
        dropdownContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the container to the parent view
        graphView.addSubview(dropdownContainerView)
      
        // Add the table view to the container
        dropdownTableView.layer.cornerRadius = 15 // Corner radius for the table view itself
        dropdownTableView.layer.masksToBounds = true // Clip content within the table view
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        dropdownTableView.separatorStyle = .none
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropdownContainerView.addSubview(dropdownTableView)

        // Constraints for the container view
        NSLayoutConstraint.activate([
            dropdownContainerView.topAnchor.constraint(equalTo: feverPhaseButton.bottomAnchor, constant: 4),
            dropdownContainerView.centerXAnchor.constraint(equalTo: feverPhaseButton.centerXAnchor, constant: -60),
            dropdownContainerView.widthAnchor.constraint(equalTo: feverPhaseButton.widthAnchor, constant: 50),
            dropdownContainerView.heightAnchor.constraint(equalToConstant: 90) // Adjust height as needed
        ])

        // Constraints for the table view within the container
        NSLayoutConstraint.activate([
            dropdownTableView.topAnchor.constraint(equalTo: dropdownContainerView.topAnchor),
            dropdownTableView.leadingAnchor.constraint(equalTo: dropdownContainerView.leadingAnchor),
            dropdownTableView.trailingAnchor.constraint(equalTo: dropdownContainerView.trailingAnchor),
            dropdownTableView.bottomAnchor.constraint(equalTo: dropdownContainerView.bottomAnchor)
        ])
        dropdownContainerView.isHidden = true
    }
    private func setupUI() {
           setupFeverPhaseButton()
           setupDropdownTableView()
       }

        /// Toggle the dropdown table view visibility
        @objc private func toggleDropdown() {
            isDropdownVisible.toggle()
            dropdownContainerView.isHidden = isDropdownVisible
        }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Add 1 extra row if `entriesWithoutFeverPhases` is not empty
        let extraRow = (entriesWithoutFeverPhases?.isEmpty == false) ? 1 : 0
        return (feverPhases?.count ?? 0) + extraRow
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        // Check if the current index is the last row (for "Ongoing fever phases")
        let isOngoingPhaseRow = indexPath.row == (feverPhases?.count ?? 0)
        
        if isOngoingPhaseRow && (entriesWithoutFeverPhases?.isEmpty == false) {
            // Display "Ongoing fever phases" in the last cell
            cell.textLabel?.text = TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARY-CHART.TEXT.2", defaultText: "Ongoing fever phase")
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            cell.textLabel?.textColor = .darkGray
        } else {
          
            // Display the fever phase details
            if let feverPhase = feverPhases?[indexPath.row] {
                let startDate = feverPhase.feverPhaseStartDate?.formattedDate() ?? "N/A"
                let endDate = feverPhase.feverPhaseEndDate?.formattedDate() ?? "N/A"
                cell.textLabel?.text = "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARY-CHART.TEXT.1", defaultText: "fever Phase")) \(startDate) - \(endDate)"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            }
        }
        
        return cell
    }

    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isOngoingPhaseRow = indexPath.row == (feverPhases?.count ?? 0)
        
        if isOngoingPhaseRow && (entriesWithoutFeverPhases?.isEmpty == false) {
            currentFeverPhaseEntries = entriesWithoutFeverPhases
            // Handle the selection of "Ongoing fever phases"
            feverPhaseButton.setTitle("Ongoing fever phases", for: .normal)
        } else if let feverPhase = feverPhases?[indexPath.row] {
            currentFeverPhase = feverPhases?[indexPath.row]
            // Extract the entries associated with the current fever phase
            guard let entriesSet = currentFeverPhase?.localEntry as? Set<LocalEntry> else {
                currentFeverPhaseEntries = [] // Clear if no entries are associated
                return
            }
            
            // Convert the NSSet to an array of LocalEntry
            currentFeverPhaseEntries = Array(entriesSet)
            // Handle the selection of a specific fever phase
            let startDate = feverPhase.feverPhaseStartDate?.formattedDate() ?? "N/A"
            let endDate = feverPhase.feverPhaseEndDate?.formattedDate() ?? "N/A"
            feverPhaseButton.setTitle("Fever phase: \(startDate) - \(endDate)", for: .normal)
        }
        reloadGraph()
        // Hide the dropdown
        toggleDropdown()
    }
    func clearChartViews(){
        for chartView in chartViews {
               // Remove all subviews explicitly
               for subview in chartView.subviews {
                   subview.removeConstraints(subview.constraints)
                   subview.removeFromSuperview()
                   subview.isHidden = true
               }
               // Remove the chart view itself
               chartView.removeFromSuperview()
           }
           chartViews.removeAll() // Clear the array
           mainGraphView.setNeedsLayout()
           mainGraphView.layoutIfNeeded()
    }
    func reloadGraph(){
        clearChartViews()
        let numberOfDays = calculateNumberOfDays(entries: currentFeverPhaseEntries!)
         if numberOfDays == 0 {
             mainGraphView.backgroundColor = UIColor(patternImage: UIImage(named: "graph_bg")!)
             gradientOverlayView.removeFromSuperview()
         }else{
             mainGraphView.backgroundColor = .white
             configureCharts(numberOfCharts: numberOfDays) // Configure 3 charts for example

         }
    }
    
    @IBOutlet var graphLabel: UILabel!
    var numberOfFeverPhases :Int?
    
    var hasEntries: Bool = true // Variable to track if there are entries
    
    private func checkIfProfileHasEntries(profileId: Int64) -> Bool {

        // Fetch data for the given profileId
        let entries = fetchProfileDashboardListView(profileId: profileId)
        return !entries.isEmpty
    }

//    var profileName:String = "Test"
    
        private func setupScrollView() {
          
            dateButton.layer.shadowColor = UIColor.lightGray.cgColor
            dateButton.layer.shadowOpacity = 0.5
            dateButton.layer.shadowRadius = 5
            dateButton.layer.shadowOffset = CGSize(width: 0, height: 2)
            dateButton.layer.cornerRadius = 6
            scrollView.layer.shadowColor = UIColor.lightGray.cgColor
            scrollView.layer.shadowOpacity = 0.7
            scrollView.layer.shadowRadius = 5
            scrollView.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    // Property to track checked state
    var isChecked = false
    func generateYAxisLabels(for entries: [LocalEntry]) -> [[String]] {
        // Fetch the user's selected language
           let appDelegate = UIApplication.shared.delegate as? AppDelegate
           let userLanguageCode = appDelegate?.fetchUserLanguage().languageCode ?? "en" // Default to English
        // Step 1: Group entries by date
        let groupedEntries = Dictionary(grouping: entries) { entry -> Date in
            guard let entryDate = entry.entryDate else { return Date.distantPast }
            return Calendar.current.startOfDay(for: entryDate)
        }
        // Step 2: Sort dates
        let sortedDates = groupedEntries.keys.sorted()
        
        // Step 3: Prepare Y-axis labels
        var xAxisLabels: [[String]] = []
        
        for (index, date) in sortedDates.enumerated() {
            // Generate time labels
            var timeLabels: [String] = ["       03:00", "       06:00", "       09:00", "       12:00", "       15:00", "       18:00", "       21:00"]
            
            // Add the date as the first label
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d"
            dateFormatter.locale = Locale(identifier: userLanguageCode) // Use the
            let dateLabel = "      " + dateFormatter.string(from: date)
            timeLabels.insert(dateLabel, at: 0)
            
            // Check if this is the last day
            if index == sortedDates.count - 1 {
                timeLabels.append("00") // Add "00:00" for the last day
            } else {
                timeLabels.append("") // Add empty string for other days
            }
            
            xAxisLabels.append(timeLabels)
        }
        
        return xAxisLabels
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBOutlet var mainGraphViewWidth: NSLayoutConstraint!
    
    
        private func configureCharts(numberOfCharts: Int) {
            guard let currentEntries = currentFeverPhaseEntries else { return }
            // prepare y axis labels
            let xAxisLabels = generateYAxisLabels(for: currentFeverPhaseEntries ?? [])
            // Prepare unique dates for filtering entries
            let uniqueDates: Set<Date> = Set(currentEntries.compactMap { entry in
                guard let entryDate = entry.entryDate else { return nil }
                return Calendar.current.startOfDay(for: entryDate)
            })
            // Sort unique dates to ensure charts align with chronological order
              let sortedDates = uniqueDates.sorted()
            var totalWidth: CGFloat = 0
            var gradientLineHeight : CGFloat = 0
            // Date formatter for converting dates to strings like "27.08.2024"
                let dateFormatter = DateFormatter()
          
                dateFormatter.dateFormat = "dd.MM.yyyy"
            // Update mainGraphView frame
            // Update the width constraint of mainGraphView
            mainGraphViewWidth.constant = CGFloat(numberOfCharts) * (scrollView.frame.size.width - 35)

            // Ensure the contentSize of the scrollView matches
            scrollView.contentSize = CGSize(width: mainGraphViewWidth.constant, height: scrollView.frame.size.height)

            // Apply layout updates
            view.layoutIfNeeded()
       
           
          // Update the contentSize of the scrollView
        

              for i in 0..<numberOfCharts {
                  
                  guard i < sortedDates.count else { continue } // Safety check to avoid index out of bounds
                  let date = sortedDates[i]
                  // Format the date to the desired string format
                        let formattedDate = dateFormatter.string(from: date)

                          // Filter entries for this specific day
                          let entriesForDay = currentEntries.filter { entry in
                              guard let entryDate = entry.entryDate else { return false }
                              return Calendar.current.isDate(entryDate, inSameDayAs: date)
                          }
                  // Extract temperature values for the current day
                        let temperatureValues = extractTemperatureValues(from: entriesForDay)
                  // Extract temperatureDateTime values for the current day
                  let temperatureDateTimes = extractTemperatureDateTimes(from: entriesForDay)
                  
                  let xAxisLabel = xAxisLabels[i]
                  let viewWidth: CGFloat = scrollView.frame.width - 20
                  let viewHeight: CGFloat = mainGraphView.frame.height
                  // Position each view horizontally
                  let xPosition = totalWidth
                  totalWidth += viewWidth - 40
                  let chartView = UIView(frame: CGRect(x: xPosition, y: 0, width: viewWidth, height: viewHeight))
                  let chartViewHeight = chartView.bounds.height
                  // Set the height to 65% of the chartView's height
                  let lineChartHeight = chartViewHeight * 0.5
                  // Configure each chart with specific settings
                  let lineChartFrame = CGRect(x: 10, y: 30, width: chartView.bounds.width - 20, height: lineChartHeight)
                  if i == 0{
                      gradientLineHeight = lineChartHeight
                  }
                  let lineChartView = LineChartView(frame: lineChartFrame)
                          lineChartView.delegate = self // Set the delegate for interaction
                          lineChartView.translatesAutoresizingMaskIntoConstraints = false
                  lineChartView.isUserInteractionEnabled = true
                  
                  chartView.addSubview(lineChartView)
                  // Add the title as a UILabel
                      let chartTitleLabel = UILabel()
                      chartTitleLabel.text = formattedDate
                      chartTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
                      chartTitleLabel.textAlignment = .center
                      chartTitleLabel.textColor = .black
                      chartTitleLabel.translatesAutoresizingMaskIntoConstraints = false
                      // Add the title label to the chart's parent view
                      chartView.addSubview(chartTitleLabel)
                  // Add constraints for the title
                    NSLayoutConstraint.activate([
                        chartTitleLabel.topAnchor.constraint(equalTo: chartView.topAnchor, constant: 0),
                        chartTitleLabel.leadingAnchor.constraint(equalTo: chartView.leadingAnchor),
                        chartTitleLabel.trailingAnchor.constraint(equalTo: chartView.trailingAnchor),
                        chartTitleLabel.heightAnchor.constraint(equalToConstant: 20)
                    ])
                  mainGraphView.addSubview(chartView)
                  // Configure chart appearance and data
                  configureChart(lineChartView: lineChartView, title: formattedDate, chartView: chartView, xLabels: xAxisLabel, temperatureValues: temperatureValues, temperatureDateTimes: temperatureDateTimes, entries: entriesForDay)
                  chartViews.append(chartView)
              }
              
          
            
            
            setupYGradient(height: gradientLineHeight)
        }
    
    func extractTemperatureValues(from entries: [LocalEntry]) -> [Float] {
        // Use compactMap to extract temperature values from the entries
        return entries.compactMap { entry in
            // Access the temperature object and its temperatureValue property
            entry.temperature?.temperatureValue
        }
    }
    private func extractTemperatureDateTimes(from entries: [LocalEntry]) -> [Date] {
        return entries.map { entry in
            // Check if the entry has a temperature object
            if let temperatureDateTime = entry.temperature?.temperatureDateTime {
                return temperatureDateTime
            } else {
                // Use the entry's date or current date if entryDate is also missing
                let fallbackDate = entry.entryDate ?? Date()
                return Calendar.current.startOfDay(for: fallbackDate) // Set to midnight
            }
        }
    }
    private var buttonToEntryMap: [UIButton: LocalEntry] = [:] // Map buttons to LocalEntry objects
    private func addButtonsOnDataPointsAndBelow(dataPoints: [ChartDataEntry], entries: [LocalEntry], lineChartView: LineChartView, chartView: UIView) {
        guard dataPoints.count == entries.count else { return } // Ensure data points and entries align

        for (index, dataPoint) in dataPoints.enumerated() {
            let entry = entries[index]
            let point = lineChartView.getTransformer(forAxis: .left).pixelForValues(x: dataPoint.x, y: dataPoint.y )
            
            // Add button on the data point
            let buttonOnDataPoint = UIButton(frame: CGRect(x: point.x, y: point.y + 6, width: 30, height: 30))
            buttonOnDataPoint.backgroundColor = .clear
            buttonOnDataPoint.layer.cornerRadius = 15
            buttonOnDataPoint.isUserInteractionEnabled = true
            buttonOnDataPoint.addTarget(self, action: #selector(dataPointButtonTapped(_:)), for: .touchUpInside)
         

            // Store the button-entry relationship
            buttonToEntryMap[buttonOnDataPoint] = entry
            chartView.addSubview(buttonOnDataPoint)
            chartView.bringSubviewToFront(buttonOnDataPoint)
         
            // Determine the icons based on entry attributes
            var iconsData: [String] = []
            var attributeKeys: [String] = []
            
            if entry.stateOfHealth != nil {
                iconsData.append("ic_state_new")
                attributeKeys.append("stateOfHealth")
            }
            if entry.pains != nil {
                iconsData.append("ic_pain_graph")
                attributeKeys.append("pains")
            }
            if entry.liquids != nil {
                iconsData.append("ic_liquid_graph")
                attributeKeys.append("liquids")
            }
            if entry.diarrhea != nil {
                iconsData.append("ic_diaarhea_graph")
                attributeKeys.append("diarrhea")
            }
            if entry.warningSigns != nil {
                iconsData.append("ic_warning_new")
                attributeKeys.append("warningSigns")
            }
            if entry.measures != nil {
                iconsData.append("ic_measure_new")
                attributeKeys.append("measures")
            }
            if let confidenceLevel = entry.confidenceLevel?.confidenceLevel {
                iconsData.append("ic_confident_new")
                attributeKeys.append("confidenceLevel")
            }
            if entry.contactWithDoctor != nil {
                iconsData.append("ic_doctor_new")
                attributeKeys.append("contactWithDoctor")
            }
            if iconsData.isEmpty {
                iconsData.append("default_icon")
                attributeKeys.append("default")
            }

            // Add buttons below the chart for the determined icons
            let buttonSize = CGSize(width: 18, height: 18)
            let spacing: CGFloat = 10 // Spacing between buttons
            let startingY = lineChartView.frame.maxY + 20 // Position below the chart view
            
            for (i, icon) in iconsData.enumerated() {
                let buttonBelow = UIButton(frame: CGRect(x: point.x, y: startingY + CGFloat(i) * (buttonSize.height + spacing), width: buttonSize.width, height: buttonSize.height))
                buttonBelow.setImage(UIImage(named: icon), for: .normal)
                buttonBelow.layer.cornerRadius = 5
                buttonBelow.tag = i // Assign tag based on the index
                buttonBelow.addTarget(self, action: #selector(extraButtonTapped(_:)), for: .touchUpInside)
                chartView.clipsToBounds = true
                // Store the button-entry relationship
                buttonToEntryMap[buttonBelow] = entry
                chartView.addSubview(buttonBelow)
            }

            // Store the attribute keys for the current entry
            entryToAttributesMap[entry] = attributeKeys
        }
    }

    private var entryToAttributesMap: [LocalEntry: [String]] = [:] // Map entries to their attributes
    func transformPainResponsesToDescription(_ rawValues: [String]) -> String {
        // Map raw values to PainResponses enum and extract descriptions
        let descriptions = rawValues.compactMap { rawValue in
            PainResponses(rawValue: rawValue)?.userFriendlyDescription
        }
        
        // Join the descriptions into a single comma-separated string
        return descriptions.joined(separator: ", ")
    }
    func transformDehydrationResponses(_ responses: [String]) -> String {
        // Convert raw values to their descriptions
        let descriptions = responses.compactMap { rawValue in
            DehydrationResponses(rawValue: rawValue)?.userFriendlyDescription
        }
        // Join descriptions into a single string separated by commas
        return descriptions.joined(separator: ", ")
    }
    // Function to transform an array of warning signs
    func transformWarningSignsResponses(_ responses: [String]) -> String {
        // Map the raw values to user-friendly descriptions and join them with commas
        return responses.compactMap { WarningSignsResponses(rawValue: $0)?.userFriendlyDescription }
                        .joined(separator: ", ")
    }
    // Function to transform an array of MeasuresEnum raw values
    func transformMeasuresResponses(_ responses: [String]) -> String {
        // Map the raw values to user-friendly descriptions and join them with commas
        return responses.compactMap { MeasuresEnum(rawValue: $0)?.userFriendlyDescription }
                        .joined(separator: ", ")
    }
    func getDoctorContactedText(hasHadMedicalContact: String?) -> String {
        switch hasHadMedicalContact {
        case "NO":
            return "No doctor's visit"
        case "SPOKE_WITH_OUR_DOCTOR":
            return "Our doctor"
        case "SPOKE_WITH_ANOTHER_DOCTOR":
            return "Substitute doctor"
        case "WITH_EMERGENCY_SERVICES":
            return "Emergency services"
        default:
            return "Unknown contact status"
        }
    }
    func getReasonsForContact(reasonsForContactValue: [String]) -> [String] {
        var reasonsForContact = [String]()

        if reasonsForContactValue.contains("NO") {
            reasonsForContact.append("No other warning signs")
        } else {
            if reasonsForContactValue.contains("WORRY_AND_INSECURITY") {
                reasonsForContact.append("Worry and insecurity")
            }
            if reasonsForContactValue.contains("HIGH_FEVER") {
                reasonsForContact.append("High level of fever")
            }
            if reasonsForContactValue.contains("WARNING_SIGNS") {
                reasonsForContact.append("Warning signs (as documented in the app)")
            }
            if reasonsForContactValue.contains("GET_ATTESTATION") {
                reasonsForContact.append("To get an attestation/sick note")
            }
            if reasonsForContactValue.contains("OTHER") {
                reasonsForContact.append("Other")
            }
        }

        return reasonsForContact
    }

    func getConfidenceLevelText(confidenceLevel: String?, profileName: String) -> String {
      switch confidenceLevel {
      case "ONE":
        return "When \(profileName) has a fever, you feel very insecure."
      case "TWO":
        return "When \(profileName) has a fever, you feel insecure."
      case "THREE":
        return "When \(profileName) has a fever, you feel neither very secure nor very insecure."
      case "FOUR":
        return "When \(profileName) has a fever, you feel secure."
      case "FIVE":
        return "When \(profileName) has a fever, you feel very secure."
      default:
        return "Confidence level unknown"
      }
    }
    @objc private func extraButtonTapped(_ sender: UIButton) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
         
            return
        }
        let profileName = appDelegate.fetchProfileName()
        guard let tappedEntry = buttonToEntryMap[sender] else { return }
        guard let attributes = entryToAttributesMap[tappedEntry], sender.tag < attributes.count else { return }
        
        let attributeKey = attributes[sender.tag]
        
        switch attributeKey {
        case "stateOfHealth":
            if let stateOfHealth = tappedEntry.stateOfHealth {
                var stateOfHealthDescription : String = ""
                if let state = StateOfHealthResponse(rawValue: stateOfHealth.stateOfHealth ?? "") {
                    stateOfHealthDescription = state.userFriendlyDescription
                      print(state.userFriendlyDescription) // Use this to display on the view
                  } else {
                      print("Unknown state of health")
                  }
                let infoText = "State of health\n \(stateOfHealthDescription)"
                presentBottomSheet(iconName: "ic_state_new", infoDescription: infoText, Entry: tappedEntry)
            }
        case "pains":
            if let pains = tappedEntry.pains {
              var painSeverity : String = ""
                // Convert raw value to PainLevel and get its description
                if let painLevel = PainLevel(rawValue: pains.painSeverityScale ?? "") {
                      painSeverity = painLevel.userFriendlyDescription
                  }
                
                // Example usage
                let retrievedRawValues = pains.painValue as? [String] ?? [""]
                let userFriendlyString = transformPainResponsesToDescription(retrievedRawValues)
                let infoText = "\(TranslationsViewModel.shared.getTranslation(key: "ADMINISTRATION_FORM.REASON.5", defaultText: "Pain"))\n" + userFriendlyString + "," +  painSeverity
                presentBottomSheet(iconName: "ic_pain_graph", infoDescription: infoText, Entry: tappedEntry)
            }
        case "liquids":
            if let liquids = tappedEntry.liquids {
                print("Liquids: \(liquids.description)")
                let userFriendlyString = transformDehydrationResponses(liquids.dehydrationSigns as? [String] ?? [""])
                let isDehydrationSignsEmpty : Bool = userFriendlyString.isEmpty
                var additionalMeasures : String = ""
                if isDehydrationSignsEmpty{
                    additionalMeasures = ""
                }else{
                    additionalMeasures = TranslationsViewModel.shared.getTranslation(key: "DIARY.DRINK.DRINK.ANALYSIS.HINT.1.TEXT", defaultText: "{{name}} shows signs of dehydration. Please try to frequently offer liquid in small quantities. Warmed fluids are often better accepted. Please seek medical advice.").replacingOccurrences(of: "{{name}}", with: profileName!)
                }
                let infoText = "Liquids\n" + "dehydration signs: \(userFriendlyString)\n" + additionalMeasures
                presentBottomSheet(iconName: "ic_liquid_graph", infoDescription: infoText, Entry: tappedEntry)
            }
        case "diarrhea":
            if let diarrhea = tappedEntry.diarrhea {
                let diarrheaResponse =  DiarrheaResponses(rawValue: diarrhea.diarrheaAndOrVomiting ?? "")?.userFriendlyDescription ?? ""
        var isDiarrheaEmpty : Bool = diarrheaResponse.isEmpty
                var additionalMeasures : String = ""
                if isDiarrheaEmpty{
                    additionalMeasures = ""
                }else{
                    additionalMeasures = TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARRHEA.DIARRHEA.ANALYSIS.HINT.1.TEXT", defaultText: "Diarrhea and vomiting cause the body to lose fluid and this can lead to dehydration. Please seek medical advice if the vomiting and/or diarrhea is severe or including blood.")
                }
               var infoText = "Diarrhea\n" + diarrheaResponse + "\n" + additionalMeasures
                presentBottomSheet(iconName: "ic_diaarhea_graph", infoDescription: infoText, Entry: tappedEntry)
            }
        case "warningSigns":
            if let warningSigns = tappedEntry.warningSigns {
                let userFriendlyString = transformWarningSignsResponses(warningSigns.warningSigns as? [String] ?? [""])
            var infoText = "Warning signs\n" + userFriendlyString
                presentBottomSheet(iconName: "ic_warning_new", infoDescription: "", Entry: tappedEntry)
            }
        case "measures":
            if let measures = tappedEntry.measures {
                let userFriendlyMeasuresString = transformMeasuresResponses(measures.measures as? [String] ?? [""])
                var infoText = "Measures\n" + "Measure:\((measures.takeMeasures ?? "").capitalized)" + "\n" + "Measure: \(userFriendlyMeasuresString)"
                presentBottomSheet(iconName: "ic_measure_new", infoDescription: infoText, Entry: tappedEntry)
            }
        case "confidenceLevel":
            if let confidenceLevel = tappedEntry.confidenceLevel?.confidenceLevel {
                
                var infoText = "Feeling confident\n \(getConfidenceLevelText(confidenceLevel: confidenceLevel, profileName: profileName ?? ""))"
                presentBottomSheet(iconName: "ic_confident_new", infoDescription: "", Entry: tappedEntry)
            }
        case "contactWithDoctor":
            if let contact = tappedEntry.contactWithDoctor {
                let diagnosis = contact.doctorDiagnoses as? [String]
                let prescriptions = contact.doctorsPrescriptionsIssued as? [String]
                var infoText = "Contact with the Doctor\nContact: \(getDoctorContactedText(hasHadMedicalContact: contact.hasHadMedicalContact))\nReason: \(getReasonsForContact(reasonsForContactValue: contact.reasonForContact as? [String] ?? [""]))\nDiagnosis: \(diagnosis?.joined(separator: ", ") ?? "no diagnosis")\nPrescription: \(prescriptions?.joined(separator: ", ") ?? "no prescriptions")"
                presentBottomSheet(iconName: "ic_doctor_new", infoDescription: infoText, Entry: tappedEntry)
            }
        case "default":
            print("No specific information available for this entry.")
        default:
            print("Unknown attribute tapped.")
        }
    }
   
    func presentBottomSheet(iconName : String,infoDescription : String, Entry: LocalEntry ){
        // Example: Present a bottom sheet or perform other actions
        let bottomSheetVC = CustomBottomSheetViewController(iconName: iconName, infoDescription: infoDescription, Entry: Entry)
        bottomSheetVC.reloadGraph = {
            self.fetchAndReloadGraphData()
        }
        bottomSheetVC.modalPresentationStyle = .pageSheet

        if let sheet = bottomSheetVC.sheetPresentationController {
            // Calculate the height as 35% of the screen height
            let screenHeight = UIScreen.main.bounds.height
            let targetHeight = screenHeight * 0.45 // Adjust as needed (e.g., 0.3 for 30%)

            // Define a custom detent
            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return targetHeight
            }
            sheet.detents = [customDetent] // Set the custom detent
            sheet.prefersGrabberVisible = true // Optional: show the grabber handle at the top
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false // Optional: prevent auto-expansion
        }

        present(bottomSheetVC, animated: true, completion: nil)
    }
   
    @objc private func dataPointButtonTapped(_ sender: UIButton) {
        print("button tapped")
        guard let tappedEntry = buttonToEntryMap[sender] else { return }
        var temperatureComparism : String = ""
        var temperaturePlace : String = ""
        
        if let rawValue = tappedEntry.temperature?.temperatureComparedToForehead ,
           let temperatureComparison = TemperatureComparedToForehead(rawValue: rawValue) {
            temperatureComparism = temperatureComparison.description
       
        }
        if let rawValue = tappedEntry.temperature?.temperatureMeasurementLocation, // e.g., "IN_THE_MOUTH"
           let measurementLocation = TemperatureMeasurementLocations(rawValue: rawValue) {
            // Use the description for display
            temperaturePlace = measurementLocation.description
        }
        let infoText = "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TITLE", defaultText: "Temperature"))\n" + temperatureComparism + "\n\(TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TITLE", defaultText: "Temperature")): \(tappedEntry.temperature?.temperatureValue ?? 0)°C\n" + TranslationsViewModel.shared.getTranslation(key: "DIARY.TEMPERATURE.TEMPERATURE_LOCATION.DISPLAY", defaultText: "Place: {{value}}").replacingOccurrences(of: "{{name}}", with: temperaturePlace)
        presentBottomSheet(iconName: "ic_temperature", infoDescription: infoText, Entry: tappedEntry)
    
    }

    @IBOutlet weak var overviewItem: UITabBarItem!
    
    @IBAction func alarmButton(_ sender: Any) {
        AlarmNetworkManager.shared.requestNotificationPermission{ granted in
              if granted {
                  DispatchQueue.main.async {
                      self.presentReminderViewController()
                  }
              } else {
                  print("User did not grant notification permission.")
              }
          }
    }
    func presentReminderViewController(){
        let bottomSheetVC = CustomAlarmBottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheetVC.sheetPresentationController {
            let customDetent = UISheetPresentationController.Detent.custom { context in
                    return context.maximumDetentValue * 0.85 // 75% of the screen height
                }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
        }
        present(bottomSheetVC, animated: true, completion: nil)
    }
    @IBOutlet weak var timelineLabel: UILabel!
    @IBOutlet weak var overviewText: UILabel!
    @IBOutlet weak var createEntryLabel: UIButton!
    func checkEntriesBelongingToFeverPhase() {
        // Access the NSManagedObjectContext from the shared persistent container
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        // Create a fetch request for LocalEntry
        let fetchRequest: NSFetchRequest<LocalEntry> = LocalEntry.fetchRequest()
        // Add a compound predicate to filter by isdeleted == false or isdeleted == nil
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "belongsToAFeverPhase == nil"),
                NSPredicate(format: "belongsToAFeverPhase == %@", NSNumber(value: false))
            ]),
            NSPredicate(format: "isdeleted == nil OR isdeleted == %@", NSNumber(value: false))
        ])

        do {
            // Perform the fetch request
            let entriesNotBelongingToFeverPhase = try context.fetch(fetchRequest)

            if !entriesNotBelongingToFeverPhase.isEmpty {
                print("Found \(entriesNotBelongingToFeverPhase.count) entries not belonging to a fever phase.")
                // Call the function to show the recovered button
                setupRecoveredButtonUI()
            } else {
                print("No entries found that do not belong to a fever phase.")
                // Call the function to hide the recovered button
                hideRecoveredButtonUI()
            }
        } catch {
            print("Failed to fetch LocalEntry objects: \(error.localizedDescription)")
        }
    }
    // Placeholder function to set up the recovered button UI
    func setupRecoveredButtonUI() {
        if recoveredButton.isHidden == false{
            
        }else{
            recoveredButton.isHidden = false
           
            // Add code to display the recovered button
            print("Displaying the recovered button.")
        }
       
    }

    
    @IBOutlet var addEntryTopConstraint: NSLayoutConstraint!
    
    // Placeholder function to hide the recovered button UI
    func hideRecoveredButtonUI() {
        recoveredButton.isHidden = true
        // Increase the top constraint value to push the button down
        
       
          // Ensure layout updates
          nameView.layoutIfNeeded()
        // Add code to hide the recovered button
        print("Hiding the recovered button.")
    }
    override func viewWillAppear(_ animated: Bool) {
        // Set the title for all states
          let translatedText = TranslationsViewModel.shared.getAdditionalTranslation(
              key: "PROFILE.ADD_ENTRY",
              defaultText: "Add Entry"
          )
          createEntryLabel.setTitle(translatedText, for: .normal)
          createEntryLabel.setTitle(translatedText, for: .highlighted) // Optional if needed
          createEntryLabel.setTitle(translatedText, for: .selected)    // Optional if needed
          
          // Set the font
          createEntryLabel.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        let attributedTitle = NSAttributedString(
            string: TranslationsViewModel.shared.getAdditionalTranslation(
                key: "PROFILE.ADD_ENTRY",
                defaultText: "Add Entry"
            ),
            attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor.black
            ]
        )
        createEntryLabel.setAttributedTitle(attributedTitle, for: .normal)
        createEntryLabel.contentEdgeInsets = .zero
        createEntryLabel.titleEdgeInsets = .zero


        fetchAndReloadGraphData()
    }
    func fetchAndReloadGraphData(){
        clearChartViews()
        fetchEntryAndFeverPhaseData()
        dropdownTableView.reloadData()
        displayGraph()
    }
    func fetchEntryAndFeverPhaseData(){
        // fetch all feverphase and their corresponding enntries
        // Get the Core Data context
           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
           
           // Fetch fever phases
        feverPhases = feverPhaseNetworkManager.shared.fetchAllFeverPhases(context: context)
           print("Fetched \(feverPhases?.count ?? 0) fever phases.")
           
           // Fetch entries with fever phases
         entriesWithFeverPhases =  AddEntryNetworkManager.shared.fetchEntriesWithFeverPhases(context: context)
           print("Fetched \(entriesWithFeverPhases?.count ?? 0) entries with fever phases.")
           
           // Fetch entries without fever phases
         entriesWithoutFeverPhases = AddEntryNetworkManager.shared.fetchEntriesWithoutFeverPhases(context: context)
           print("Fetched \(entriesWithoutFeverPhases?.count ?? 0) entries without fever phases.")
     
    }
    func showAppTour() {
        if let window = view.window {
            let popupVC = TourPopupViewController()
            popupVC.modalPresentationStyle = .overFullScreen
            popupVC.modalTransitionStyle = .crossDissolve // Optional fade-in effect
            let buttonFrameInWindow = createEntryLabel.convert(createEntryLabel.bounds, to: window)
            let segmentControlFrame = segmentControl.convert(segmentControl.bounds, to: window)
               let segmentWidth = segmentControlFrame.width / CGFloat(segmentControl.numberOfSegments)

               let listButtonFrame = CGRect(
                   x: segmentControlFrame.origin.x,
                   y: segmentControlFrame.origin.y,
                   width: segmentWidth,
                   height: segmentControlFrame.height
               )

               let graphButtonFrame = CGRect(
                   x: segmentControlFrame.origin.x + segmentWidth,
                   y: segmentControlFrame.origin.y,
                   width: segmentWidth,
                   height: segmentControlFrame.height
               )
            if let tabBar = customTabBar.subviews.first(where: { $0 is UITabBar }) as? UITabBar,
               let tabBarButtons = tabBar.subviews.filter({ NSStringFromClass(type(of: $0)).contains("UITabBarButton") }) as? [UIView],
               let window = view.window {

                // Ensure we have the correct number of tab buttons
                guard tabBarButtons.count >= 4 else { return }

                // Get frames of tab bar buttons at fixed indices
                let infoLibraryFrame = tabBarButtons[1].convert(tabBarButtons[1].bounds, to: window)
                let moreFrame = tabBarButtons[2].convert(tabBarButtons[2].bounds, to: window)

                // Assuming popupVC is your other view controller and it has a property called highlightFrames
                popupVC.highlightFrames = [
                    1: buttonFrameInWindow,
                    2: listButtonFrame,
                    3: graphButtonFrame,
                    4: nameView.frame,
                    5: moreFrame, // Fixed index for More
                    6: infoLibraryFrame // Fixed index for Info Library
                ]
            }

            present(popupVC, animated: true)
        }
    }

        override func viewDidLoad() {
            super.viewDidLoad()
          
//            saveFirstProfileToCoreData()
            
            graphLabel.text = TranslationsViewModel.shared.getTranslation(key: "OVERVIEW.GRAPH", defaultText: "Graph")
            fetchEntryAndFeverPhaseData()
          createEntryLabel.translatesAutoresizingMaskIntoConstraints = false

            // Fetch profileId from AppDelegate

//            InternetConnectionManager.shared.stopMonitoring()
            InternetConnectionManager.shared.startMonitoringForSync()
            
            // Fetch the current profile name from Core Data
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let profileName = appDelegate.fetchProfileName()
            
            guard let profileId = appDelegate.fetchProfileId() else { return }
            
            // Make the moreIcon clickable
            moreIcon.isUserInteractionEnabled = true
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleMoreIconTap))
            moreIcon.addGestureRecognizer(tapGestureRecognizer)
            
            // Call the function to fetch profile dashboard list view data
//            hasEntries = fetchProfileDashboardListView(profileId: profileId).isEmpty ? false : true
            hasEntries = checkIfProfileHasEntries(profileId: profileId)
            
            profileNameLabel.text = profileName
            timelineLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "OVERVIEW.TIMELINE",defaultText: "Timeline")
            overviewText.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.DIARY.LABEL", defaultText: "Overview")
          
            overviewItem.title = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.DIARY.LABEL", defaultText: "Overview")
            
         //   feverPhaseText.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "OVERVIEW.FEVERPHASE",defaultText: "Ongoing fever phase"), for: .normal)
            checkEntriesBelongingToFeverPhase()
            graphButtonView.layer.cornerRadius = 5 // Adjust the radius as needed
            graphButtonView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            graphButtonView.layer.masksToBounds = true
            // Set the font size for the button title
            feverPhaseButton.titleLabel?.font = UIFont.systemFont(ofSize: 8) // Adjust the font size as needed
            
            // Add target to the segmented control
            segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
            nameView.layer.shadowColor = UIColor.lightGray.cgColor
            nameView.layer.shadowOpacity = 0.5
            nameView.layer.shadowRadius = 5
            nameView.layer.shadowOffset = CGSize(width: 0, height: 2)
            navigationItem.hidesBackButton = true
            navigationItem.leftBarButtonItem = nil
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            topView.layer.cornerRadius = 20
            topView.layer.masksToBounds = true
            
            bottomView.layer.cornerRadius = 20
            bottomView.layer.masksToBounds = true
            
            nameView.layer.cornerRadius = 7
            setupUI()
           
            
     
            // Configure UI elements (topView, nameView, etc.) here...
            
            setupScrollView()
          
            
          
            // Initial checkbox setup
                   updateCheckBox()
                   
                   // Add target for checkbox toggle
                   toggleCheckBox.addTarget(self, action: #selector(toggleCheckBoxAction), for: .touchUpInside)
            
            // Initial setup for listView
            setupListView()
            setupCustomTabBar()
        }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Check if it's the first launch
        let firstLaunchDate = UserDefaults.standard.object(forKey: "firstLaunchDate")
        if firstLaunchDate == nil {
            // Set the current date as the first launch date
            UserDefaults.standard.set(Date(), forKey: "firstLaunchDate")
            // Set shouldShowTour to true for the first launch
            UserDefaults.standard.set(true, forKey: "shouldShowTour")
        } else {
    
        }

        // Check shouldShowTour and present the tour if true
        if UserDefaults.standard.bool(forKey: "shouldShowTour") {
            showAppTour()
            // Reset shouldShowTour to false after showing the tour
            UserDefaults.standard.set(false, forKey: "shouldShowTour")
        }
     fetchAndReloadGraphData()
        checkEntriesBelongingToFeverPhase()
    
    }
    @objc func handleMoreIconTap() {
        // Handle the tap on moreIcon here
        print("More icon tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "rhfyjf")

        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
  
    private func setupCustomTabBar() {
     
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.parentViewController = self // Assign the parent view controller
        view.addSubview(customTabBar)
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 88)
        ])
        
        customTabBar.updateTranslations()
        customTabBar.updateTabBarItemColors()
    }
    
    func addIconsBelowDataPoints(icons: [UIImage], lineChartView: LineChartView) {
        
           // Retrieve data points from the line chart
           guard let dataSet = lineChartView.data?.dataSets.first as? LineChartDataSet else { return }
           
        for (_, entry) in dataSet.entries.enumerated() {
               
               // Convert chart data points to screen coordinates
               let point = lineChartView.getTransformer(forAxis: dataSet.axisDependency)
                   .pixelForValues(x: Double(entry.x), y: Double(entry.y))
               // Display all icons for each entry
               for i in 0..<icons.count {
                           // Create an UIImageView for the icon
                           let iconView = UIImageView(image: icons[i])
                           iconView.contentMode = .scaleAspectFit
                           iconView.frame.size = CGSize(width: 20, height: 20)  // Customize size as needed
                           
                           // Position the icon below the data point with offset
                   iconView.center = CGPoint(x: point.x, y: mainGraphView.bounds.height - 250 + 67 + CGFloat((i * 30)))  // Offset by 25 points for each icon
                           
                           // Add icon view to the chart
                           lineChartView.addSubview(iconView)
                       }
           }
    }
    @objc func toggleCheckBoxAction(_ sender: UIButton) {
        isChecked.toggle()
        print("Checkbox toggled: \(isChecked)")
        updateCheckBox()

        for view in chartViews {
            if let lineChartView = view.subviews.first(where: { $0 is LineChartView }) as? LineChartView {
                updateLineVisibility(for: lineChartView)
            }
        }
    }
    private func updateLineVisibility(for lineChartView: LineChartView) {
        guard let lineChartData = lineChartView.data else {
               print("LineChartView data is nil")
               return
           }
           
           for case let dataSet as LineChartDataSet in lineChartData.dataSets {
               // Keep a reference to the original entries
               let originalEntries = dataSet.entries
               
               // Filter out the entries where y == 0 or y is nil
               let filteredEntries = originalEntries.filter { $0.y != 0 }
               
               // Temporarily update the dataset's entries
               dataSet.replaceEntries(filteredEntries)
               dataSet.lineWidth = isChecked ? 1.5 : 0.0
               print("Filtered \(originalEntries.count - filteredEntries.count) entries with y == 0 or nil")

               // After the update, if needed, restore the original entries
               // Uncomment the next line if you want the original dataset to be restored after visibility update
               // dataSet.replaceEntries(originalEntries)
           }
           
           // Refresh the chart view
           lineChartView.notifyDataSetChanged()
    }
       
       func updateCheckBox() {
           toggleCheckBox.layer.cornerRadius = 3
           // Unchecked state
           if !isChecked {
               toggleCheckBox.backgroundColor = .white
               toggleCheckBox.layer.borderColor = UIColor.gray.cgColor
               toggleCheckBox.layer.borderWidth = 1
               toggleCheckBox.tintColor = .gray
               toggleCheckBox.setTitle("", for: .normal)
           }
           // Checked state
           else {
               toggleCheckBox.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5) // Light blue
               toggleCheckBox.layer.borderColor = UIColor.gray.cgColor
               toggleCheckBox.layer.borderWidth = 1
               toggleCheckBox.tintColor = .black
               
               // Draw checkmark using Unicode character
               toggleCheckBox.setTitle("\u{2713}", for: .normal)
               toggleCheckBox.titleLabel?.font = .systemFont(ofSize: 20)
           }
       }
    var feverPhases : [FeverPhaseLocal]?
    var entriesWithFeverPhases : [LocalEntry]?
    var entriesWithoutFeverPhases : [LocalEntry]?
    var currentFeverPhase : FeverPhaseLocal?
    var currentFeverPhaseEntries : [LocalEntry]?
    
    func fetchCurrentFeverPhaseEntries(completion: @escaping (Bool) -> Void) {
        // Check if entriesWithoutFeverPhases is not empty
        if let entriesWithoutFeverPhases = entriesWithoutFeverPhases, !entriesWithoutFeverPhases.isEmpty {
            // Set current fever phase entries to entries without fever phases
            currentFeverPhaseEntries = entriesWithoutFeverPhases
            completion(true)
            return
        }
        if let feverPhases = feverPhases, !feverPhases.isEmpty {
            currentFeverPhase = feverPhases[0]
            // ...
        } else {
            currentFeverPhase = nil
            currentFeverPhaseEntries = []
            completion(true)
            return
        
       
        }
        
        // Extract the entries associated with the current fever phase
        guard let entriesSet = currentFeverPhase?.localEntry as? Set<LocalEntry> else {
            currentFeverPhaseEntries = [] // Clear if no entries are associated
            completion(true)
            return
        }
        
        // Convert the NSSet to an array of LocalEntry
        currentFeverPhaseEntries = Array(entriesSet)
        completion(true)
    }
//

    func calculateNumberOfDays(entries: [LocalEntry]) -> Int {
        // Extract unique dates from the entries
        let uniqueDates: Set<Date> = Set(entries.compactMap { entry in
            // Extract the date ignoring time (to count by day)
            guard let entryDate = entry.entryDate else { return nil }
            return Calendar.current.startOfDay(for: entryDate)
        })
        
        // Return the count of unique dates
        return uniqueDates.count
    }
    func displayGraph(){
        fetchCurrentFeverPhaseEntries(){ [self] isFetched in
            if isFetched{
                let numberOfDays = calculateNumberOfDays(entries: currentFeverPhaseEntries!)
                print("theeeeee number of days gotten is \(numberOfDays)")
                 if numberOfDays == 0 {
                     mainGraphView.backgroundColor = UIColor(patternImage: UIImage(named: "graph_bg")!)
                     gradientOverlayView.removeFromSuperview()
                     
                 }else{
                     mainGraphView.backgroundColor = .white
                     configureCharts(numberOfCharts: numberOfDays) // Configure 3 charts for example
                 }
            }else{
                print("failed to fetch current entry data")
            }
        }
    }
   
    func configureChart(lineChartView: LineChartView, title: String, chartView: UIView,  xLabels: [String], temperatureValues: [Float], temperatureDateTimes: [Date], entries: [LocalEntry]) {
            // Chart setup
        lineChartView.isUserInteractionEnabled = false
            lineChartView.legend.enabled = false
        lineChartView.highlightPerTapEnabled = false
        lineChartView.highlightPerDragEnabled = false
            // X-axis setup
            // Increase interval between vertical gridlines

            lineChartView.xAxis.spaceMin = 10.0
            lineChartView.xAxis.spaceMax = 10.0
            lineChartView.xAxis.labelCount = 9 // 00:00 to 24:00
    
            // Ensure the X-axis starts at 0
            lineChartView.xAxis.gridColor = .lightGray // Set color for grid lines
           
            lineChartView.xAxis.axisMinimum = 0 // Set the minimum value of the X-axis to 0
            lineChartView.xAxis.axisMaximum = 8 // End value to match the data
            lineChartView.xAxis.granularity = 1.0 // Interval of 1 unit between grid lines
        // Provide default xLabels if empty
           let xAxisValues = xLabels.isEmpty ? ["", " ", " ", " ", " ", " ", " "] : xLabels
        
        lineChartView.xAxis.labelFont = UIFont.boldSystemFont(ofSize: 10) // Set bold font and larger size
        lineChartView.xAxis.labelTextColor = .black // Keep the text color as black
            lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xAxisValues)
            lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.centerAxisLabelsEnabled = false
        lineChartView.xAxis.drawGridLinesEnabled = false
 
            lineChartView.legend.enabled = false
            
        
            lineChartView.leftAxis.spaceMin = 0.5
            lineChartView.leftAxis.spaceMax = 0.5
            lineChartView.leftAxis.labelCount = 6 // 00:00 to 24:00
        lineChartView.leftAxis.gridColor = .lightGray       // Set the color of the grid lines
        lineChartView.leftAxis.gridLineWidth = 0.5          // Set the width of the grid lines
            // Ensure the y-axis starts at 0
            lineChartView.leftAxis.gridColor = .lightGray // Set color for grid lines
        // make y axis to be dotted
        lineChartView.leftAxis.axisLineDashLengths = [4, 4] // Dotted line [line length, space length]
            lineChartView.leftAxis.drawGridLinesEnabled = false // Enable grid lines
            lineChartView.rightAxis.enabled = false
            lineChartView.leftAxis.axisMinimum = 0 // Set the minimum value of the X-axis to 0
            lineChartView.leftAxis.axisMaximum = 6// End value to match the data
            lineChartView.leftAxis.granularity = 1.0 // Interval of 1 unit between grid lines
            lineChartView.leftAxis.labelFont = .systemFont(ofSize: 10) // Adjust label font size
            lineChartView.leftAxis.labelTextColor = .black
            let yAxisValues = ["","36°C", "37°C", "38°C", "39°C", "40°C", "41°C"]
            lineChartView.leftAxis.valueFormatter = IndexAxisValueFormatter(values: yAxisValues)
        lineChartView.leftAxis.drawLabelsEnabled = false
        // Map temperature values to y-axis points
          let yDataPoints = temperatureValues.map { temperature -> Double in
              return Double(temperature - 36.0) + 1.0 // Precise y-axis calculation
          }
        // Map temperatureDateTimes to x-axis points
         let xDataPoints = temperatureDateTimes.map { date -> Double in
             let startOfDay = Calendar.current.startOfDay(for: date)
             let elapsedSeconds = date.timeIntervalSince(startOfDay)
             let elapsedMinutes = elapsedSeconds / 60.0
             return elapsedMinutes / 180.0 // Precise x-axis calculation
         }



        // Create data points for the chart
        // Handle empty data
           var dataPoints: [ChartDataEntry] = []
           if !xDataPoints.isEmpty && !yDataPoints.isEmpty {
               dataPoints = zip(xDataPoints, yDataPoints).map { (x, y) -> ChartDataEntry in
                   ChartDataEntry(x: x, y: y)
               }
           } else {
               // Add a dummy entry to maintain chart structure
               dataPoints = [ChartDataEntry(x: 3, y: 1)]
           }
            
            // Data set and line chart data
            let dataSet = LineChartDataSet(entries: dataPoints, label: "Temperature")
           dataSet.lineWidth = 0.0
           dataSet.circleRadius = 9.0 // Outer circle radius
           dataSet.circleHoleRadius = 4.0 // Inner circle radius
           dataSet.circleHoleColor = .white // White color for inner circle
           dataSet.drawCirclesEnabled = true // Enable circles
           dataSet.drawCircleHoleEnabled = true // Enable inner circle
        dataSet.circleColors = [UIColor(red: 165/255, green: 195/255, blue: 260/255, alpha: 1)] // Custom circle color
        dataSet.colors = [UIColor(red: 165/255, green: 189/255, blue: 242/255, alpha: 1)] // Custom line color
        dataSet.valueFormatter = TemperatureValueFormatter(yAxisValues: yAxisValues)
                   lineChartView.data = LineChartData(dataSets: [dataSet])
           lineChartView.data = LineChartData(dataSets: [dataSet])
           lineChartView.notifyDataSetChanged()
           
            // add background image to line chart view
            addBackgroundImageToChart(lineChartView: lineChartView, chartView: chartView)
        let icons = [UIImage(named: "Blue heart")!, UIImage(named: "ic_pain_graph")!, UIImage(named: "ic_diaarhea_graph")!]
        // Add buttons over data points
      
        addButtonsOnDataPointsAndBelow(dataPoints: dataPoints, entries: entries, lineChartView: lineChartView, chartView: chartView)
       
        }
    // Step 1: Create the gradient overlay view
      let gradientOverlayView = UIView()
    func setupYGradient(height : CGFloat){
    
          gradientOverlayView.translatesAutoresizingMaskIntoConstraints = false
          
          // Step 2: Create a gradient layer
          let gradientLayer = CAGradientLayer()
          gradientLayer.colors = [
              UIColor.blue.cgColor,       // Blue (36°C)
              UIColor.green.cgColor,      // Green (37.5°C)
              UIColor.yellow.cgColor,     // Yellow (39°C)
              UIColor.red.cgColor         // Red (41°C)
          ]
          gradientLayer.locations = [0.0, 0.33, 0.66, 1.0]
          gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
          gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
          
          // Adjust the frame of the gradient to fit the Y-axis area
          gradientLayer.frame = CGRect(x: 1, y: 0, width: 2, height: height - 20)
          gradientOverlayView.layer.addSublayer(gradientLayer)
          
          // Step 3: Add temperature labels
          let yAxisValues = ["","36°C", "37°C", "38°C", "39°C", "40°C", "41°C"]
          let labelCount = yAxisValues.count
          for i in 0..<labelCount {
              let label = UILabel()
              label.text = yAxisValues[i]
              label.font = UIFont.boldSystemFont(ofSize: 8)
              label.textColor = .black
              label.textAlignment = .right
              
              // Calculate the y position of the label based on the gradient height
              let yPosition = gradientLayer.frame.height - CGFloat(i) * (gradientLayer.frame.height / CGFloat(labelCount - 1))
              label.frame = CGRect(x: -22, y: yPosition - 10, width: 25, height: 20) // Adjust width and alignment as needed
              gradientOverlayView.addSubview(label)
          }
          
          // Step 4: Add the overlay view to the chart's superview
          scrollView.addSubview(gradientOverlayView)
          
          // Step 5: Set up constraints for the overlay view
          NSLayoutConstraint.activate([
              gradientOverlayView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
              gradientOverlayView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 35),
              gradientOverlayView.widthAnchor.constraint(equalToConstant: 25),
              gradientOverlayView.heightAnchor.constraint(equalToConstant: 230)
          ])
     
    }
    func addBackgroundImageToChart(lineChartView: LineChartView, chartView: UIView) {
            let imageView = UIView()
            imageView.layer.frame = CGRect(x: 60, y: 12, width: lineChartView.frame.width - 25, height: mainGraphView.frame.height)
            
            let backgroundImage = UIImage(named: "graph_bg")
            let newSize = CGSize(width: imageView.frame.width , height: imageView.frame.height)
            let renderer = UIGraphicsImageRenderer(size: newSize)
            let resizedImage = renderer.image { _ in
                backgroundImage?.draw(in: CGRect(origin: .zero, size: newSize))
            }
            imageView.backgroundColor = UIColor(patternImage: resizedImage)
            // lineChartView.backgroundColor = UIColor(patternImage: resizedImage)
            // Insert the image view at the back of the stack view
            chartView.insertSubview(imageView, at: 0)
        }
    
    private func setupListView() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let profileId = appDelegate.fetchProfileId()
        
            listView.subviews.forEach { $0.removeFromSuperview() } // Clear any existing subviews
            
        if hasEntries {
            // Remove the `entryLabel` and add `TimelineViewController` instead
            let timelineViewController = TimelineViewController() // Initialize TimelineViewController
            timelineViewController.refreshListView = { [self] in
                hasEntries = checkIfProfileHasEntries(profileId: profileId!)
                setupListView() // Refresh listView content when switching to it
            }
            timelineViewController.presentAddEntryViewController = { [self] entry in
             
                editEntryNetworkManager.shared.editEntry(entryId: Int64(entry.entryId)){ success, objectIds in
                    if success {
                        timelineViewController.dismiss(animated: true) {
                            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEntryViewController") as! AddEntryController
                            viewController.delegate = self
                            viewController.modalPresentationStyle = .fullScreen
                            self.present(viewController, animated: true, completion: nil)
                           }
                       
                    } else {
                        let alertController = UIAlertController(title: "Error", message: "Failed to edit entry please try again", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "ok", style: .cancel)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true)
                        print("Failed to fetch entry or its associated objects.")
                    }
                }
            }
            // Set data for the timeline (use your actual data here)
            timelineViewController.profileDashboardListViewResponse = sampleGroupData// Make sure to replace 'yourData' with actual data.

            // Add TimelineViewController as a child view controller
            addChild(timelineViewController)
            listView.addSubview(timelineViewController.view)
            timelineViewController.view.frame = listView.bounds // Adjust frame to fit within listView
            timelineViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight] // To ensure it resizes with the parent view
            timelineViewController.didMove(toParent: self) // Notify TimelineViewController that it was added as a child
            
        } else {        // Display image
                let imageView = UIImageView(image: UIImage(named: "cropped_image"))
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                listView.addSubview(imageView)
                
                // Set image constraints
                NSLayoutConstraint.activate([
                    imageView.leadingAnchor.constraint(equalTo: listView.leadingAnchor, constant: 16), // Align to start with padding
                    imageView.topAnchor.constraint(equalTo: listView.topAnchor, constant: 20),        // Top padding
                    imageView.widthAnchor.constraint(equalToConstant: 100),                          // Fixed width
                    imageView.heightAnchor.constraint(equalToConstant: 100)                          // Fixed height
                ])
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let profileName  = appDelegate?.fetchProfileName()
                
            // Welcome text with clickable URL
            let welcomeText = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.DIARY-LIST.TEXT.1",
                defaultText: "Great, you have created basic information for {{name}}. You can correct these at any time by clicking on the name above. You can also get more information by clicking on me or on the <a href=https://www-feverapp-de.translate.goog/faq?_x_tr_sl=de&_x_tr_tl=en&_x_tr_hl=de> website </a>"
            ).replacingOccurrences(of: "{{name}}", with: profileName ?? "").replacingOccurrences(of: "{{ nombre }}", with: profileName ?? "")

            // Remove HTML tags
            let plainText = welcomeText.replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)

            let attributedString = NSMutableAttributedString(string: plainText)

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .justified
            paragraphStyle.lineBreakMode = .byWordWrapping

            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))

            // Make "website" clickable
            let websiteTextRange = (plainText as NSString).range(of: "website")
            attributedString.addAttribute(.link, value: "https://www.feverapp.de", range: websiteTextRange)

            let welcomeLabel = UILabel()
            welcomeLabel.attributedText = attributedString
            welcomeLabel.numberOfLines = 0
            welcomeLabel.font = UIFont.systemFont(ofSize: 14)
            welcomeLabel.textAlignment = .left
            welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
            listView.addSubview(welcomeLabel)

                        
//                        let welcomeLabel = UILabel()
//                        welcomeLabel.attributedText = attributedString
//                        welcomeLabel.numberOfLines = 0
//                        welcomeLabel.font = UIFont.systemFont(ofSize: 14)
//                        welcomeLabel.textAlignment = .left
//                        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
//                        listView.addSubview(welcomeLabel)
                        
                        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openWebsite))
                        welcomeLabel.addGestureRecognizer(tapGesture)
                        welcomeLabel.isUserInteractionEnabled = true
                        
                        NSLayoutConstraint.activate([
                            welcomeLabel.leadingAnchor.constraint(equalTo: listView.leadingAnchor, constant: 16),
                            welcomeLabel.trailingAnchor.constraint(equalTo: listView.trailingAnchor, constant: -16),
                            welcomeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20)
                        ])
                        
                        // Secondary text
            let secondaryText = TranslationsViewModel.shared.getTranslation(
                key: "DIARY.DIARY-LIST.TEXT.2",
                defaultText: "I hope it'll help you deal with your child's fever.\n" +
                        "Now you can freely document all or single aspects by clicking the buttons on the top icons of the next page."
            )
                        
                        let secondaryLabel = UILabel()
                        secondaryLabel.text = secondaryText
                        secondaryLabel.numberOfLines = 0
                        secondaryLabel.font = UIFont.systemFont(ofSize: 14)
                        secondaryLabel.textAlignment = .left
                        secondaryLabel.translatesAutoresizingMaskIntoConstraints = false
                        listView.addSubview(secondaryLabel)
                        
                        NSLayoutConstraint.activate([
                            secondaryLabel.leadingAnchor.constraint(equalTo: listView.leadingAnchor, constant: 16),
                            secondaryLabel.trailingAnchor.constraint(equalTo: listView.trailingAnchor, constant: -16),
                            secondaryLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 10)
                        ])
                        
                        // First Entry Button
                        let firstEntryButton = UIButton(type: .system)
            firstEntryButton.setTitle(TranslationsViewModel.shared.getTranslation(
                key: "DIARY.DIARY-LIST.TEXT.3",
                defaultText: "First entry"), for: .normal)
                        firstEntryButton.layer.cornerRadius = 20
                        firstEntryButton.backgroundColor = UIColor(hex:"3263BB")
                        firstEntryButton.tintColor = .white
                        firstEntryButton.translatesAutoresizingMaskIntoConstraints = false
            firstEntryButton.addTarget(self, action: #selector(firstEntryTapped), for: .touchUpInside)
//                        firstEntryButton.addTarget(self, action: #selector(handleFirstEntry), for: .touchUpInside)
                        listView.addSubview(firstEntryButton)
                        
                        NSLayoutConstraint.activate([
                            firstEntryButton.widthAnchor.constraint(equalToConstant: 120),
                            firstEntryButton.heightAnchor.constraint(equalToConstant: 40),
                            firstEntryButton.leadingAnchor.constraint(equalTo: listView.leadingAnchor, constant: 16), // Align to start with padding
                            firstEntryButton.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 16),
                            firstEntryButton.bottomAnchor.constraint(lessThanOrEqualTo: listView.bottomAnchor, constant: -20)
                        ])
            }
        }
            
    // Opens the website link when the user taps on it
    @objc private func openWebsite() {
        if let url = URL(string: "https://www.feverapp.de") {
            UIApplication.shared.open(url)
        }
    }
            @objc func segmentChanged(_ sender: UISegmentedControl) {
                switch sender.selectedSegmentIndex {
                case 0:
                    
                    graphView.isHidden = true
                    graphViewScrollView.isHidden = true
                    // Fetch the updated profile name and refresh the label
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let profileName = appDelegate.fetchProfileName()
                    let profileId = appDelegate.fetchProfileId()
                    profileNameLabel.text = profileName

                    listView.isHidden = false
                    hasEntries = checkIfProfileHasEntries(profileId: profileId!)
                    
                    setupListView() // Refresh listView content when switching to it
                case 1:
                
                    graphView.isHidden = false
                    graphViewScrollView.isHidden = false
                    fetchAndReloadGraphData()
                    listView.isHidden = true
                default:
                    break
                }
            }
            
    


    
        }
        


// Timeline View Controller (integrated in overviewViewController.swift)
class TimelineViewController: UIViewController {
    
    var languageCodeProvider: (() -> String)?

    
    var scrollView: UIScrollView!
    var cardStackView: UIStackView!
    
    var profileDashboardListViewResponse: [GroupData] = []
    var feverPhaseEntries: [Int: [Entry]] = [:] // Dictionary to map feverPhaseId to its entries
    private var selectedEntry: Entry?
    var profileName:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch profileId from AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let profileId = appDelegate.fetchProfileId() else { return }
        profileName  = appDelegate.fetchProfileName()!
        
        // Call the function to fetch profile dashboard list view data
        profileDashboardListViewResponse = fetchProfileDashboardListView(profileId: profileId)
        print("\n\nList view response: \(profileDashboardListViewResponse)\n\n")
        
        setupScrollView()
        displayCards()
    }
    
    private func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true

        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        cardStackView = UIStackView()
        cardStackView.axis = .vertical
        cardStackView.spacing = 16
        cardStackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cardStackView)
        
        NSLayoutConstraint.activate([
            cardStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            cardStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            cardStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            cardStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            cardStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    override func viewDidAppear(_ animated: Bool) {
      /*  guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let profileId = appDelegate.fetchProfileId() else { return }
        profileName  = appDelegate.fetchProfileName()!
        // Call the function to fetch profile dashboard list view data
        profileDashboardListViewResponse = fetchProfileDashboardListView(profileId: profileId)
        displayCards() */
        
    }
    private func displayCards() {
        // Fetch the current selected language from Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, currentLanguage) = appDelegate.fetchUserLanguage()
        feverPhaseEntries.removeAll()  // Clear any previous data to avoid duplication

        for group in profileDashboardListViewResponse {
            // Create a date header
            let dateHeader = createDateHeader(for: group.groupDate, languageCode: languageCode!)
            cardStackView.addArrangedSubview(dateHeader)
            
            // Create cards for each fever phase
            for feverPhase in group.feverPhases {
                let feverPhaseCard = createFeverPhaseCard(for: feverPhase, languageCode: languageCode!)
                cardStackView.addArrangedSubview(feverPhaseCard)
                
                // Populate feverPhaseEntries dictionary with entries for each feverPhaseId
                feverPhaseEntries[feverPhase.feverPhaseId] = feverPhase.feverPhaseEntries
            }
            
            // Create cards for each entry not in a fever phase
            for entry in group.entriesNotBelongingToAFeverPhase {
                let entryCard = createEntryCard(for: entry, languageCode: languageCode!)
                cardStackView.addArrangedSubview(entryCard)
            }
        }
    }

    private func createDateHeader(for date: String, languageCode: String) -> UIView {
        let container = UIView()

        // Create and style the header label
        let headerLabel = UILabel()
        headerLabel.text = formatGroupDate(dateString: date, languageCode: languageCode) // Format date as required
        headerLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium) // Equivalent to `FontWeight.Medium`
        headerLabel.textColor = UIColor.darkGray // Adjust color as needed
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the divider line
        let dividerLine = UIView()
        dividerLine.backgroundColor = UIColor.systemGray // Adjust color as needed
        dividerLine.translatesAutoresizingMaskIntoConstraints = false

        // Stack the label and the divider line horizontally
        let stackView = UIStackView(arrangedSubviews: [headerLabel, dividerLine])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set the divider line's width to fill the remaining space
        dividerLine.widthAnchor.constraint(greaterThanOrEqualToConstant: 1).isActive = true
        dividerLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        // Add the stack view to the container
        container.addSubview(stackView)
        
        // Apply constraints for the stack view
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        
        return container
    }

    private func createFeverPhaseCard(for feverPhase: FeverPhase, languageCode: String) -> UIView {
        // Create a container view to hold the fever phase card and the shadow card views
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        // Create the main fever phase card
        let cardView = createCardView()
        
        // Add a tap gesture recognizer to the card view

//        let tapGestureRecognizer = FeverPhaseTapGestureRecognizer(target: self, action: #selector(handleCardTap(_:)))
//        tapGestureRecognizer.feverPhaseId = feverPhase.feverPhaseId // Assign the feverPhaseId directly
//        cardView.addGestureRecognizer(tapGestureRecognizer)
//        cardView.isUserInteractionEnabled = true


        // Store the entry object in the card view's tag
        cardView.tag = feverPhase.feverPhaseId
        
        cardView.layer.cornerRadius = 10
//        cardView.layer.shadowColor = UIColor.black.cgColor
//        cardView.layer.shadowOpacity = 0.1
//        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false

        // Icon Image
        let iconImageView = UIImageView(image: UIImage(named: "categoryrecovered_icon"))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit

        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "CHILD.RECOVERED", defaultText: "{{name}} has recovered").replacingOccurrences(of: "{{name}}", with: profileName)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Subtitle Label for date
        let subtitleLabel = UILabel()
        subtitleLabel.text = "\(TranslationsViewModel.shared.getTranslation(key: "DIARY.DIARY-CHART.TEXT.1", defaultText: "fever phase")): \(formatDateRange(startDate: feverPhase.feverPhaseStartDate, endDate: feverPhase.feverPhaseEndDate, languageCode: languageCode))"
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Stack view to hold title and subtitle labels
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.spacing = 4
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        // Chevron button for expansion
//        let chevronButton = UIButton(type: .system)
        let chevronButton = FeverPhaseButton(type: .system)
        let chevronImage = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        chevronButton.setImage(chevronImage, for: .normal)
        chevronButton.tintColor = UIColor.darkGray
        chevronButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//        chevronButton.addTarget(self, action: #selector(toggleFeverPhaseEntries(_:)), for: .touchUpInside)
      
        chevronButton.feverPhaseId = feverPhase.feverPhaseId // Assign the feverPhaseId directly
        chevronButton.addTarget(self, action: #selector(handleChevronTap(_:)), for: .touchUpInside)

        languageCodeProvider = { return languageCode }
        chevronButton.tag = feverPhase.feverPhaseId // Unique tag for each card
        chevronButton.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews to cardView
        cardView.addSubview(iconImageView)
        cardView.addSubview(textStackView)
        cardView.addSubview(chevronButton)

        // Constraints for cardView's subviews
        NSLayoutConstraint.activate([
            // Icon constraints
            iconImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),

            // Text StackView constraints
            textStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),

            // Chevron Button constraints
            chevronButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevronButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),

            // Ensure textStackView doesn't overlap chevronButton
            textStackView.trailingAnchor.constraint(lessThanOrEqualTo: chevronButton.leadingAnchor, constant: -8)
        ])

        // Create the two shadow card views
        let shadowCardView1 = UIView()
        shadowCardView1.backgroundColor = UIColor(red: 142/255, green: 148/255, blue: 167/255, alpha: 1.0)
        shadowCardView1.layer.cornerRadius = 3
        shadowCardView1.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // Bottom-left and bottom-right corners
        shadowCardView1.translatesAutoresizingMaskIntoConstraints = false
        shadowCardView1.tag = 1001 // Assign a unique tag

        let shadowCardView2 = UIView()
        shadowCardView2.backgroundColor = UIColor(red: 209/255, green: 213/255, blue: 219/255, alpha: 1.0)
        shadowCardView2.layer.cornerRadius = 3
        shadowCardView2.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // Bottom-left and bottom-right corners
        shadowCardView2.translatesAutoresizingMaskIntoConstraints = false
        shadowCardView2.tag = 1002 // Assign a unique tag

        // Initially set the visibility based on whether entries are shown (assuming entries are collapsed initially)
        shadowCardView1.isHidden = false
        shadowCardView2.isHidden = false

        // Add the views to the containerView
        containerView.addSubview(cardView)
        containerView.addSubview(shadowCardView1)
        containerView.addSubview(shadowCardView2)

        // Set up constraints
        NSLayoutConstraint.activate([
            // Constraints for cardView
            cardView.topAnchor.constraint(equalTo: containerView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            // Shadow card 1 directly below the main card
            shadowCardView1.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            shadowCardView1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            shadowCardView1.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            shadowCardView1.heightAnchor.constraint(equalToConstant: 5),

            // Shadow card 2 directly below shadow card 1
            shadowCardView2.topAnchor.constraint(equalTo: shadowCardView1.bottomAnchor),
            shadowCardView2.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 35),
            shadowCardView2.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -35),
            shadowCardView2.heightAnchor.constraint(equalToConstant: 5),

            // Bottom constraint for containerView
            shadowCardView2.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        return containerView
    }

//    private func formatDateRange(startDate: String, endDate: String, languageCode: String) -> String {
//        // Format start and end dates to "Oct 23, 2024"
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        guard let start = dateFormatter.date(from: startDate),
//              let end = dateFormatter.date(from: endDate) else { return "\(startDate) - \(endDate)" }
//        
//        dateFormatter.dateFormat = "MMM dd, yyyy"
//        return "\(dateFormatter.string(from: start)) - \(dateFormatter.string(from: end))"
//    }
    @objc private func handleCardTap(_ sender: FeverPhaseTapGestureRecognizer) {
        let idOfFeverPhase = sender.feverPhaseId
        toggleFeverPhaseEntries(sender, idOfFeverphase: idOfFeverPhase)
    }

    @objc private func handleChevronTap(_ sender: FeverPhaseButton) {
        let idOfFeverPhase = sender.feverPhaseId
        toggleFeverPhaseEntries(sender, idOfFeverphase: idOfFeverPhase)
    }

    private func formatDateRange(startDate: String, endDate: String, languageCode: String) -> String {
        // Input date format
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        // Attempt to parse the start and end dates
        guard let start = inputFormatter.date(from: startDate),
              let end = inputFormatter.date(from: endDate) else {
            return "\(startDate) - \(endDate)"
        }
        
        // Output date format based on languageCode
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMM dd, yyyy"
        outputFormatter.locale = Locale(identifier: languageCode) // Use the language code for localization
        
        // Format and return the date range
        return "\(outputFormatter.string(from: start)) - \(outputFormatter.string(from: end))"
    }

    
    private func createFeverPhaseEntryCard(for entry: Entry, languageCode: String) -> UIView {
        let cardView = createCardView()
        
        // Add a tap gesture recognizer to the card view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openBottomSheetForEntry(_:)))
        cardView.addGestureRecognizer(tapGestureRecognizer)
        cardView.isUserInteractionEnabled = true // Make sure the card view is interactive

        // Store the entry object in the card view's tag
        cardView.tag = entry.entryId
        
        // Determine the icon and title based on the state of health
        let (iconName, titleText) = getIconAndTitle(for: entry.stateOfHealth?.stateOfHealth)
        
        // Leading Icon Image
        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtitle Label for date and time
        let subtitleLabel = UILabel()
        subtitleLabel.text = "\(TranslationsViewModel.shared.getAdditionalTranslation(key: "ADMINISTRATION_FORM.DATE", defaultText: "Date")): \(formatEntryDate(dateString: entry.entryDate, languageCode: languageCode))"
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack view to hold title and subtitle labels
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.spacing = 4
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Chevron button for opening bottom sheet
        let chevronButton = UIButton(type: .system)
        let chevronImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        chevronButton.setImage(chevronImage, for: .normal)
        chevronButton.tintColor = UIColor.darkGray
        chevronButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // Scale the chevron size
        // Set the button action to open the bottom sheet with this entry
        chevronButton.addTarget(self, action: #selector(openBottomSheetForEntry(_:)), for: .touchUpInside)

        // Store the entry object in the button's tag
        chevronButton.tag = entry.entryId
        chevronButton.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews to cardView
        cardView.addSubview(iconImageView)
        cardView.addSubview(textStackView)
        cardView.addSubview(chevronButton)

        // Constraints for layout
        NSLayoutConstraint.activate([
            // Icon constraints
            iconImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            // Text StackView constraints (title and subtitle)
            textStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            // Chevron Button constraints
            chevronButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevronButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            // Ensure textStackView doesn't overlap chevronButton
            textStackView.trailingAnchor.constraint(lessThanOrEqualTo: chevronButton.leadingAnchor, constant: -8)
        ])
                // Add a special tag for identification
                cardView.tag = 999 // Unique tag for fever phase entry cards
        return cardView
    }

    // Helper function to get icon and title based on stateOfHealth
    private func getIconAndTitle(for state: String?) -> (String, String) {
        switch state {
        case "UNWELL":
            return ("vectorunwell", TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.1.TEXT", defaultText: "{{name}} feels unwell").replacingOccurrences(of: "{{name}}", with: profileName))
        case "FINE":
            return ("fine_icon", TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.3.TEXT", defaultText: "{{name}} feels fine").replacingOccurrences(of: "{{name}}", with: profileName))
        case "NEUTRAL":
            return ("categoryneither_well_icon", TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.2.TEXT", defaultText: "{{name}} feels neither well nor unwell").replacingOccurrences(of: "{{name}}", with: profileName) )
        case "EXCELLENT":
            return ("categoryhealthy_icon", TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.4.TEXT", defaultText: "{{name}} feels very well").replacingOccurrences(of: "{{name}}", with: profileName))
        case "VERY_SICK":
            return ("categoryunwell_icon", TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.WELLBEING_CHILD.ANALYSIS.TEXT.0.TEXT", defaultText: "{{name}} feels very unwell").replacingOccurrences(of: "{{name}}", with: profileName))
        default:
            return ("fever_app_logo",  "\("\(profileName)'s" + " " + TranslationsViewModel.shared.getTranslation(key: "DIARY.WELLBEING.TITLE", defaultText: "State of health"))")
        }
    }

    // Format the date and time as required
//    private func formatEntryDate(dateString: String, languageCode: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        guard let date = dateFormatter.date(from: dateString) else { return dateString }
//        
//        dateFormatter.dateFormat = "MMM dd, yy - hh:mm a"
//        return dateFormatter.string(from: date)
//    }

    private func formatEntryDate(dateString: String, languageCode: String) -> String {
        let dateFormatter = DateFormatter()
        
        // Parse the input date
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        // Format the output date and time
        dateFormatter.dateFormat = "MMM dd, yy - hh:mm a"
        dateFormatter.locale = Locale(identifier: languageCode) // Set locale for language code
        
        return dateFormatter.string(from: date)
    }

    // Action for chevron button to show the bottom sheet
    @objc private func showEntryBottomSheet(forFeverPhaseEntry: Bool) {
        
//        guard isViewLoaded, view.window != nil else {
//            print("overviewViewController's view is not in the window hierarchy.")
//            return
//        }
        
        let bottomSheetVC = UIViewController()
        bottomSheetVC.view.backgroundColor = .white
        
        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.darkGray // Set the color to dark gray
        closeButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // Scale down the button to 80% of its original size
        closeButton.addTarget(self, action: #selector(dismissBottomSheet), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.INFO", defaultText: "Entry info")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Stack view for options
        let optionsStackView = UIStackView()
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 6// Increase spacing between options
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false

        // Add options with dividers
        optionsStackView.addArrangedSubview(createOptionRow(iconName: "info.circle", title: TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.INFO", defaultText: "Entry info")))
        optionsStackView.addArrangedSubview(createDivider())
        optionsStackView.addArrangedSubview(createOptionRow(iconName: "ellipsis.circle", title: TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.SUMMARY", defaultText: "Entry summary")))
        
        // Conditionally add "Edit entry" and "Delete summary" options if not a fever phase entry
        if !forFeverPhaseEntry {
            optionsStackView.addArrangedSubview(createDivider())
            optionsStackView.addArrangedSubview(createOptionRow(iconName: "pencil", title: TranslationsViewModel.shared.getAdditionalTranslation(
                key: "ENTRY.BOTTOMSHEET.EDIT",
                defaultText: "Edit entry"
            )))
            optionsStackView.addArrangedSubview(createDivider())
            optionsStackView.addArrangedSubview(createOptionRow(iconName: "trash", title: TranslationsViewModel.shared.getAdditionalTranslation(
                key: "ENTRY.BOTTOMSHEET.DELETE",
                defaultText: "Delete summary"
            )))
        }

        // Add elements to the bottom sheet view
        bottomSheetVC.view.addSubview(closeButton)
        bottomSheetVC.view.addSubview(titleLabel)
        bottomSheetVC.view.addSubview(optionsStackView)
        print("optionsStackView added to bottomSheetVC.view") // Debugging
        
        // Constraints
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: bottomSheetVC.view.topAnchor, constant: 22),
            closeButton.trailingAnchor.constraint(equalTo: bottomSheetVC.view.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: bottomSheetVC.view.topAnchor, constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: bottomSheetVC.view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: closeButton.leadingAnchor, constant: -8),
            
            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            optionsStackView.leadingAnchor.constraint(equalTo: bottomSheetVC.view.leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: bottomSheetVC.view.trailingAnchor, constant: -16),
            optionsStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomSheetVC.view.bottomAnchor, constant: -10)
        ])
        let testGesture = UITapGestureRecognizer(target: self, action: #selector(testStackViewTap))
        optionsStackView.addGestureRecognizer(testGesture)

        bottomSheetVC.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheetVC.sheetPresentationController {
            // Calculate height as a percentage of the screen height
            let screenHeight = UIScreen.main.bounds.height
            let targetHeight = screenHeight * 0.35// 30% of screen height

            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return targetHeight
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true // Optional: show the grabber handle
        }
        present(bottomSheetVC, animated: true, completion: nil)
    }
    @objc private func testStackViewTap() {
        print("Stack view tapped")
    }

    // Helper to create an option row with an icon, label, and right chevron
    private func createOptionRow(iconName: String, title: String) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        // Leading icon
        let iconImageView = UIImageView(image: UIImage(systemName: iconName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor.lightGray // Set the icon color to light gray

        // Title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Right chevron icon
        let chevronImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.tintColor = UIColor.lightGray // Set chevron color to light gray

        // Add subviews to the container
        container.addSubview(iconImageView)
        container.addSubview(titleLabel)
        container.addSubview(chevronImageView)
        container.tag = title.hashValue // Tag for identification

        // Constraints for layout
        NSLayoutConstraint.activate([
                        // Icon constraints
                        iconImageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                        iconImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                        iconImageView.widthAnchor.constraint(equalToConstant: 24),
                        iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
                        // Title label constraints
                        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
                        titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
                        // Chevron icon constraints
                        chevronImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12),
                        chevronImageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                        chevronImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                        chevronImageView.widthAnchor.constraint(equalToConstant: 16),
                        chevronImageView.heightAnchor.constraint(equalToConstant: 16)
        ])

        // Add an invisible button to overlay the entire container
        let invisibleButton = UIButton(type: .system)
        invisibleButton.backgroundColor = .clear // Make the button transparent
        invisibleButton.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
        invisibleButton.translatesAutoresizingMaskIntoConstraints = false
        invisibleButton.tag = title.hashValue // Use tag for identification

        container.addSubview(invisibleButton)

        // Ensure the button covers the entire container
        NSLayoutConstraint.activate([
            invisibleButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            invisibleButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            invisibleButton.topAnchor.constraint(equalTo: container.topAnchor),
            invisibleButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        print("Invisible button added to \(title)")

        return container
    }

    // Helper to create a divider line
    private func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5) // Light gray color
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true // Divider thickness
        return divider
    }

//    @objc private func optionSelected(_ sender: UIButton) {
//        print("optionSelected triggered for button with tag: \(sender.tag)")
//
//        switch sender.tag {
//        case "Entry info".hashValue:
//            print("Entry info tapped")
//            if let entry = selectedEntry {
//                self.dismiss(animated: true) { [weak self] in
//                    self?.showEntryInfoBottomSheet(entry: entry)
//                }
//            }
//        case "Entry summary".hashValue:
//            print("Entry summary tapped")
//            if let entry = selectedEntry {
//                let entrySummaryVC = EntrySummaryViewController()
//                entrySummaryVC.entryInfo = entry
//                entrySummaryVC.modalPresentationStyle = .fullScreen
//                
//                // Embed in a UINavigationController
//                let navigationController = UINavigationController(rootViewController: entrySummaryVC)
//                navigationController.modalPresentationStyle = .fullScreen
//
//                // Dismiss the current view controller and present the navigation controller
//                self.dismiss(animated: true) {
//                    self.present(navigationController, animated: true, completion: nil)
//                }
//            }
//
//
//        case "Edit entry".hashValue:
//            print("Edit entry tapped")
//            // Handle Edit entry selection
//            break
//        case "Delete summary".hashValue:
//            print("Delete summary tapped")
//            // Handle Delete summary selection
//            if let entryId = selectedEntry?.entryId {
//                self.dismiss(animated: true) { [weak self] in
//                    self?.showDeleteSummaryBottomSheet(entryId: entryId)
//                }
//            }
//        default:
//            print("Unknown button tapped with tag:", sender.tag)
//            break
//        }
//    }

    private let optionsMap: [String: String] = [
        "Entry info": TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.INFO", defaultText: "Entry info"),
        "Entry summary": TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.SUMMARY", defaultText: "Entry summary"),
        "Edit entry": TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.EDIT", defaultText: "Edit entry"),
        "Delete summary": TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.DELETE", defaultText: "Delete summary")
    ]

    // Update `optionSelected` to compare against English keys
    @objc private func optionSelected(_ sender: UIButton) {
        print("optionSelected triggered for button with tag: \(sender.tag)")

        // Find the English key corresponding to the translated text
        let englishKey = optionsMap.first(where: { $0.value.hashValue == sender.tag })?.key

        switch englishKey {
        case "Entry info":
            print("Entry info tapped")
            if let entry = selectedEntry {
                self.dismiss(animated: true) { [weak self] in
                    self?.showEntryInfoBottomSheet(entry: entry)
                }
            }
        case "Entry summary":
            print("Entry summary tapped")
            if let entry = selectedEntry {
                let entrySummaryVC = EntrySummaryViewController()
                entrySummaryVC.entryInfo = entry
                entrySummaryVC.modalPresentationStyle = .fullScreen

                // Embed in a UINavigationController
                let navigationController = UINavigationController(rootViewController: entrySummaryVC)
                navigationController.modalPresentationStyle = .fullScreen

                // Dismiss the current view controller and present the navigation controller
                self.dismiss(animated: true) {
                    self.present(navigationController, animated: true, completion: nil)
                }
            }
        case "Edit entry":
            print("Edit entry tapped")
            self.presentAddEntryViewController?(self.selectedEntry!)
            // Handle Edit entry selection
            break
        case "Delete summary":
            print("Delete summary tapped")
            if let entryId = selectedEntry?.entryId {
                self.dismiss(animated: true) { [weak self] in
                    self?.showDeleteSummaryBottomSheet(entryId: entryId)
                }
            }
        default:
            print("Unknown button tapped with tag:", sender.tag)
            break
        }
    }
    var presentAddEntryViewController : ((_ entrySelected: Entry)->Void)?
    
    // Action to dismiss the bottom sheet
    @objc private func dismissBottomSheet() {
        self.dismiss(animated: true, completion: nil)
    }

//    @objc private func openBottomSheetForEntry(_ sender: Any) {
//        // Find the entry corresponding to the tapped button using its tag
//        if let entry = findEntryById((sender as AnyObject).tag) {
//            selectedEntry = entry
//            
//            print("Selected entry set:", selectedEntry as Any)
//            
//            // Dismiss the current bottom sheet (if open), and then show the new one
//            showEntryBottomSheet(forFeverPhaseEntry: entry.belongsToAFeverPhase)
////            self.dismiss(animated: true) { [weak self] in
////                self?.showEntryBottomSheet(forFeverPhaseEntry: entry.belongsToAFeverPhase)
////            }
//        }
//    }

    @objc private func openBottomSheetForEntry(_ sender: Any) {
        var entryId: Int?

        if let gestureRecognizer = sender as? UITapGestureRecognizer {
            let cardView = gestureRecognizer.view
            entryId = cardView?.tag
        } else if let button = sender as? UIButton {
            entryId = button.tag
        }

        if let entryId = entryId, let entry = findEntryById(entryId) {
            selectedEntry = entry

            print("Selected entry set:", selectedEntry as Any)

            // Dismiss the current bottom sheet (if open), and then show the new one
            showEntryBottomSheet(forFeverPhaseEntry: entry.belongsToAFeverPhase)
        }
    }
    
    
    private func findEntryById(_ entryId: Int) -> Entry? {
        for group in profileDashboardListViewResponse {
            // Search in fever phase entries
            for feverPhase in group.feverPhases {
                if let entry = feverPhase.feverPhaseEntries.first(where: { $0.entryId == entryId }) {
                    return entry
                }
            }
            
            // Search in entries not belonging to a fever phase
            if let entry = group.entriesNotBelongingToAFeverPhase.first(where: { $0.entryId == entryId }) {
                return entry
            }
        }
        return nil
    }


//    @objc private func toggleFeverPhaseEntries(_ sender: UIButton) {
//        guard let cardView = sender.superview else { return }
//        guard let containerView = cardView.superview else { return }
//        let isExpanded = sender.currentImage == UIImage(systemName: "chevron.up")
//
//        // Get the language code
//        guard let languageCode = languageCodeProvider?() else { return }
//        // Toggle chevron direction
//        let chevronDirection = isExpanded ? "chevron.down" : "chevron.up"
//        sender.setImage(UIImage(systemName: chevronDirection), for: .normal)
//
//        // Find the index of the containerView in the cardStackView
//        if let index = cardStackView.arrangedSubviews.firstIndex(of: containerView) {
//            if isExpanded {
//                // Collapse: Remove fever phase entries from stack view and show shadow card views
//                var i = index + 1
//                while i < cardStackView.arrangedSubviews.count {
//                    let subview = cardStackView.arrangedSubviews[i]
//                    if subview.tag == 999 { // Fever phase entry card
//                        cardStackView.removeArrangedSubview(subview)
//                        subview.removeFromSuperview()
//                        // Do not increment i because the arrangedSubviews array has shifted
//                    } else {
//                        break
//                    }
//                }
//                // Show shadow card views
//                if let shadowCardView1 = containerView.viewWithTag(1001),
//                   let shadowCardView2 = containerView.viewWithTag(1002) {
//                    shadowCardView1.isHidden = false
//                    shadowCardView2.isHidden = false
//                }
//            } else {
//                // Expand: Add fever phase entries and hide shadow card views
//                if let entries = feverPhaseEntries[sender.tag] { // Retrieve entries based on feverPhaseId
//                    for (j, entry) in entries.enumerated() {
//                        let entryCard = createFeverPhaseEntryCard(for: entry, languageCode: languageCode)
//                        cardStackView.insertArrangedSubview(entryCard, at: index + 1 + j)
//                        entryCard.isHidden = false
//                    }
//                }
//                // Hide shadow card views
//                if let shadowCardView1 = containerView.viewWithTag(1001),
//                   let shadowCardView2 = containerView.viewWithTag(1002) {
//                    shadowCardView1.isHidden = true
//                    shadowCardView2.isHidden = true
//                }
//            }
//        }
//    }
    
    @objc private func toggleFeverPhaseEntries(_ sender: Any, idOfFeverphase: Int) {
        print("\n\n\n\n\n\n\n\n Id of feverphase : \(idOfFeverphase)\n\n\n\n\n\n\n\n")
        var view: UIView?
        var feverphaseId: Int? = idOfFeverphase // Use the passed idOfFeverphase

        if let gestureRecognizer = sender as? UITapGestureRecognizer {
            view = gestureRecognizer.view
//            feverphaseId = view?.tag ?? view?.superview?.tag ?? view?.subviews[0].tag
             print("Fever phase ID from card or parent: \(feverphaseId ?? -1)")
            print("\n\n\n\n\n\n\n\nfever phase id : \(feverphaseId)\n\n\n\n\n\n\n\n")
        } else if let button = sender as? UIButton {
            view = button
//            feverphaseId = button.tag
            print("\n\n\n\n\n\n\n\nfever phase id : \(feverphaseId)\n\n\n\n\n\n\n\n")
        } else {
            return
        }

        guard let cardView = view?.superview else { return }
        guard let containerView = cardView.superview else { return }

        // Get the language code
        guard let languageCode = languageCodeProvider?() else { return }

        var isExpanded: Bool?
        var chevronButton: UIButton?

        // Check if the sender is a button or a gesture recognizer
        if let button = sender as? UIButton {
            isExpanded = button.currentImage == UIImage(systemName: "chevron.up")
            print("\n\n\n\n\n\n\n\n is expanded value : \(isExpanded)\n\n\n\n\n\n\n\n")
            chevronButton = button
        } else if let gestureRecognizer = sender as? UITapGestureRecognizer {
            // Find the chevron button in the view
            for subview in view?.subviews ?? [] {
                if let button = subview as? UIButton {
                    isExpanded = button.currentImage == UIImage(systemName: "chevron.up")
                    print("\n\n\n\n\n\n\n\n is expanded value : \(isExpanded)\n\n\n\n\n\n\n\n")
                    chevronButton = button
                    break
                }
            }
        }

        // Toggle chevron direction
        if let chevronButton = chevronButton {
            let chevronDirection = isExpanded ?? false ? "chevron.down" : "chevron.up"
            chevronButton.setImage(UIImage(systemName: chevronDirection), for: .normal)
        }

        // Find the index of the containerView in the cardStackView
        if let index = cardStackView.arrangedSubviews.firstIndex(of: containerView) {
            if isExpanded ?? false {
                // Collapse: Remove fever phase entries from stack view and show shadow card views
                var i = index + 1
                while i < cardStackView.arrangedSubviews.count {
                    let subview = cardStackView.arrangedSubviews[i]
                    if subview.tag == 999 { // Fever phase entry card
                        cardStackView.removeArrangedSubview(subview)
                        subview.removeFromSuperview()
                        // Do not increment i because the arrangedSubviews array has shifted
                    } else {
                        break
                    }
                }
                // Show shadow card views
                if let shadowCardView1 = containerView.viewWithTag(1001),
                   let shadowCardView2 = containerView.viewWithTag(1002) {
                    shadowCardView1.isHidden = false
                    shadowCardView2.isHidden = false
                }
            } else {
                // Expand: Add fever phase entries and hide shadow card views
                if let entries = feverPhaseEntries[idOfFeverphase ] { // Use idOfFeverphase
                    for (j, entry) in entries.enumerated() {
                        let entryCard = createFeverPhaseEntryCard(for: entry, languageCode: languageCode)
                        entryCard.tag = 999 // Mark as fever phase entry card
                        cardStackView.insertArrangedSubview(entryCard, at: index + 1 + j)
                        entryCard.isHidden = false
                    }
                }
                // Hide shadow card views
                if let shadowCardView1 = containerView.viewWithTag(1001),
                   let shadowCardView2 = containerView.viewWithTag(1002) {
                    shadowCardView1.isHidden = true
                    shadowCardView2.isHidden = true
                }
            }
        }
    }

    private func createEntryCard(for entry: Entry, languageCode: String) -> UIView {
        let cardView = createCardView()
        
        // Add a tap gesture recognizer to the card view
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openBottomSheetForEntry(_:)))
        cardView.addGestureRecognizer(tapGestureRecognizer)
        cardView.isUserInteractionEnabled = true // Make sure the card view is interactive

        // Store the entry object in the card view's tag
        cardView.tag = entry.entryId
        
        // Determine the icon and title based on the state of health
        let (iconName, titleText) = getIconAndTitle(for: entry.stateOfHealth?.stateOfHealth)
        
        // Leading Icon Image
        let iconImageView = UIImageView(image: UIImage(named: iconName))
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        
        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Subtitle Label for time
        let subtitleLabel = UILabel()
        subtitleLabel.text = "\(TranslationsViewModel.shared.getAdditionalTranslation(key: "OVERVIEW.TIME", defaultText: "Time")): \(formatTime(dateString: entry.entryDate, languageCode: languageCode))"
        subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        subtitleLabel.textColor = .gray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack view to hold title and subtitle labels
        let textStackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.spacing = 4
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Chevron button for opening bottom sheet
        let chevronButton = UIButton(type: .system)
        let chevronImage = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        chevronButton.setImage(chevronImage, for: .normal)
        chevronButton.tintColor = UIColor.darkGray
        chevronButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6) // Scale the chevron size
        // Set the button action to open the bottom sheet with this entry
        chevronButton.addTarget(self, action: #selector(openBottomSheetForEntry(_:)), for: .touchUpInside)

        // Store the entry object in the button's tag
        chevronButton.tag = entry.entryId
        chevronButton.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews to cardView
        cardView.addSubview(iconImageView)
        cardView.addSubview(textStackView)
        cardView.addSubview(chevronButton)

        // Constraints for layout
        NSLayoutConstraint.activate([
            // Icon constraints
            iconImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            // Text StackView constraints (title and subtitle)
            textStackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            // Chevron Button constraints
            chevronButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            chevronButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            // Ensure textStackView doesn't overlap chevronButton
            textStackView.trailingAnchor.constraint(lessThanOrEqualTo: chevronButton.leadingAnchor, constant: -8)
        ])
        
        return cardView
    }

    // Helper function to format time
//    private func formatTime(dateString: String, languageCode: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
//        guard let date = dateFormatter.date(from: dateString) else { return dateString }
//        
//        dateFormatter.dateFormat = "hh:mm a"
//        return dateFormatter.string(from: date)
//    }
    private func formatTime(dateString: String, languageCode: String) -> String {
        let dateFormatter = DateFormatter()
        
        // Parse the input date
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        // Format the output time
        dateFormatter.dateFormat = "hh:mm a" // Use 12-hour format with AM/PM
        dateFormatter.locale = Locale(identifier: languageCode) // Set locale for language-specific formatting
        
        return dateFormatter.string(from: date)
    }

    private func createCardView() -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set a fixed height for the card if needed (optional)
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80)
        ])
        
        return cardView
    }

    
    private func formatDate(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: dateString) else { return dateString }
        
        dateFormatter.dateFormat = "EEE MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
//    private func formatGroupDate(dateString: String) -> String {
//        let inputFormatter = DateFormatter()
//        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Input format
//        
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = "E MMM dd, yyyy" // Desired output format
//        
//        if let date = inputFormatter.date(from: dateString) {
//            return outputFormatter.string(from: date)
//        } else {
//            return dateString // Return the original string if parsing fails
//        }
//    }
    private func formatGroupDate(dateString: String, languageCode: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ" // Input format
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "E MMM dd, yyyy" // Desired output format
        outputFormatter.locale = Locale(identifier: languageCode) // Set the locale using languageCode
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString // Return the original string if parsing fails
        }
    }

    private func showEntryInfoBottomSheet(entry: Entry) {
        print("showEntryInfoBottomSheet called with entry:", entry)
        // Fetch the current selected language from Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, currentLanguage) = appDelegate.fetchUserLanguage()
        
        // Determine the icon and title based on the state of health
        let (iconName, titleText) = getIconAndTitle(for: entry.stateOfHealth?.stateOfHealth)

        let bottomSheetVC = UIViewController()
        bottomSheetVC.view.backgroundColor = .white

        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.darkGray
        closeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        closeButton.addTarget(self, action: #selector(dismissBottomSheet), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.INFO", defaultText: "Entry info")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Icon for state of health
            let stateIcon = UIImageView(image: UIImage(named: iconName))
            stateIcon.translatesAutoresizingMaskIntoConstraints = false
            stateIcon.contentMode = .scaleAspectFit
            stateIcon.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)


            // Health status label
            let healthStatusLabel = UILabel()
            healthStatusLabel.text = titleText
            healthStatusLabel.font = UIFont.boldSystemFont(ofSize: 12)
            healthStatusLabel.translatesAutoresizingMaskIntoConstraints = false

            // Container for stateIcon and healthStatusLabel
            let statusContainer = UIStackView(arrangedSubviews: [stateIcon, healthStatusLabel])
            statusContainer.axis = .horizontal
            statusContainer.alignment = .center
            statusContainer.spacing = 8
            statusContainer.translatesAutoresizingMaskIntoConstraints = false

            // Time label
            let timeLabel = UILabel()
        timeLabel.text = "\(formatTime(dateString: entry.entryDate, languageCode: languageCode!))"
            timeLabel.font = UIFont.systemFont(ofSize: 12)
            timeLabel.textColor = UIColor.lightGray
            timeLabel.translatesAutoresizingMaskIntoConstraints = false

            // Top row stack view (statusContainer + timeLabel)
            let topRowStackView = UIStackView(arrangedSubviews: [statusContainer, timeLabel])
            topRowStackView.axis = .horizontal
            topRowStackView.alignment = .center
            topRowStackView.spacing = 8
            topRowStackView.distribution = .equalSpacing
            topRowStackView.translatesAutoresizingMaskIntoConstraints = false

        // Options Stack View
        let optionsStackView = UIStackView()
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 12
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false

        // Add entry detail rows with dividers
        optionsStackView.addArrangedSubview(createEntryDetailRow(iconName: "thermometer", title: TranslationsViewModel.shared.getTranslation(
            key: "DIARY.TEMPERATURE.TITLE",
            defaultText: "Temperature"
        ), value: getTemperatureValue(entry: entry)))
        optionsStackView.addArrangedSubview(createDivider())

        optionsStackView.addArrangedSubview(createEntryDetailRow(iconName: "bolt", title: TranslationsViewModel.shared.getTranslation(
            key: "DIARY.PAIN.TITLE",
            defaultText: "Pain"
        ), value: getPainValue(entry: entry)))
        optionsStackView.addArrangedSubview(createDivider())

        optionsStackView.addArrangedSubview(createEntryDetailRow(iconName: "drop.fill", title: TranslationsViewModel.shared.getTranslation(
            key: "DIARY.DRINK.DRINK.DISPLAY",
            defaultText: "dehydration: {{value}}"
        ).replacingOccurrences(of: ": {{value}}", with: ""), value: getDehydrationValue(entry: entry)))
        optionsStackView.addArrangedSubview(createDivider())

        optionsStackView.addArrangedSubview(createEntryDetailRow(iconName: "bandage.fill", title: TranslationsViewModel.shared.getTranslation(key: "DIARY.RASH.TITLE", defaultText: "Rash"), value: getRashValue(entry: entry)))


        // Add subviews
        bottomSheetVC.view.addSubview(closeButton)
        bottomSheetVC.view.addSubview(titleLabel)
        bottomSheetVC.view.addSubview(topRowStackView)
        bottomSheetVC.view.addSubview(optionsStackView)

        // Constraints
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: bottomSheetVC.view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: bottomSheetVC.view.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: bottomSheetVC.view.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: bottomSheetVC.view.leadingAnchor, constant: 16),

            topRowStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            topRowStackView.leadingAnchor.constraint(equalTo: bottomSheetVC.view.leadingAnchor, constant: 16),
            topRowStackView.trailingAnchor.constraint(equalTo: bottomSheetVC.view.trailingAnchor, constant: -16),

            optionsStackView.topAnchor.constraint(equalTo: topRowStackView.bottomAnchor, constant: 16),
            optionsStackView.leadingAnchor.constraint(equalTo: bottomSheetVC.view.leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: bottomSheetVC.view.trailingAnchor, constant: -16),
            optionsStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomSheetVC.view.bottomAnchor, constant: -16)
        ])

        bottomSheetVC.modalPresentationStyle = .pageSheet
        if let sheet = bottomSheetVC.sheetPresentationController {
            // Calculate height as a percentage of the screen height
            let screenHeight = UIScreen.main.bounds.height
            let targetHeight = screenHeight * 0.35 // 40% of screen height

            let customDetent = UISheetPresentationController.Detent.custom { _ in
                return targetHeight
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true // Optional: show the grabber handle
        }

        self.present(bottomSheetVC, animated: true, completion: nil)
    }

    // Helper function to create each row
    private func createEntryDetailRow(iconName: String, title: String, value: String) -> UIView {
        let container = UIView()
        let icon = UIImageView(image: UIImage(systemName: iconName))
        icon.tintColor = .darkGray
        icon.translatesAutoresizingMaskIntoConstraints = false
        let titleLabel = UILabel()
        titleLabel.text = "\(title):"
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 12)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        let rowStack = UIStackView(arrangedSubviews: [icon, titleLabel, valueLabel])
        rowStack.spacing = 8
        rowStack.axis = .horizontal
        container.addSubview(rowStack)

        rowStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rowStack.topAnchor.constraint(equalTo: container.topAnchor),
            rowStack.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            rowStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            rowStack.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        return container
    }
    //Functions to get the values to be displayed on the entry info bottom sheet
    private func getTemperatureValue(entry: Entry) -> String {
        guard let temperature = entry.temperature?.temperatureValue else {
            return "?"
        }
        return String(format: "%.1f°C", temperature)
    }
    private func getPainValue(entry: Entry) -> String {
        guard let painValues = entry.pains?.painValue, !painValues.isEmpty else {
            return TranslationsViewModel.shared.getTranslation(
                key: "DIARY.PAIN.PAIN.OPTION.1.DISPLAYLABEL",
                defaultText: "No pains"
            )
        }

        var painDescriptions = [String]()

        if painValues.contains("NO") {
            return TranslationsViewModel.shared.getTranslation(
                key: "DIARY.PAIN.PAIN.OPTION.1.DISPLAYLABEL",
                defaultText: "No pains"
            )
        }
        if painValues.contains("YES_IN_LIMBS") {
            painDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.OPTION.2.DISPLAYLABEL",
                    defaultText: "Limb pain"
                )
            )
        }
        if painValues.contains("YES_IN_HEAD") {
            painDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.OPTION.3.DISPLAYLABEL",
                    defaultText: "Pains in the head"
                )
            )
        }
        if painValues.contains("YES_IN_NECK") {
            painDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.OPTION.4.DISPLAYLABEL",
                    defaultText: "Pains in the neck"
                )
            )
        }
        if painValues.contains("YES_IN_EARS") {
            painDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.OPTION.5.DISPLAYLABEL",
                    defaultText: "Pains in the ears"
                )
            )
        }
        if painValues.contains("YES_IN_STOMACH") {
            painDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.OPTION.6.DISPLAYLABEL",
                    defaultText: "Pains in the stomach"
                )
            )
        }
        if painValues.contains("YES_SOMEWHERE_ELSE") {
            painDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.PAIN.PAIN.OPTION.7.DISPLAYLABEL",
                    defaultText: "Pains somewhere else"
                )
            )
        }

        return painDescriptions.isEmpty ? "?" : painDescriptions.joined(separator: ", ")
    }

    private func getDehydrationValue(entry: Entry) -> String {
        guard let dehydrationSigns = entry.liquids?.dehydrationSigns, !dehydrationSigns.isEmpty else {
            return TranslationsViewModel.shared.getTranslation(
                key: "DIARY.DRINK.DRINK.OPTION.1.DISPLAYLABEL",
                defaultText: "No signs of dehydration"
            )
        }

        var dehydrationDescriptions = [String]()

        if dehydrationSigns.contains("NO") {
            return TranslationsViewModel.shared.getTranslation(
                key: "DIARY.DRINK.DRINK.OPTION.1.DISPLAYLABEL",
                defaultText: "No signs of dehydration"
            )
        }
        if dehydrationSigns.contains("YES_DRY_MUCOUS_MEMBRANES") {
            dehydrationDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.2.DISPLAYLABEL",
                    defaultText: "Dry mucous membranes"
                )
            )
        }
        if dehydrationSigns.contains("YES_DRY_SKIN") {
            dehydrationDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.3.DISPLAYLABEL",
                    defaultText: "Skin dry and flabby"
                )
            )
        }
        if dehydrationSigns.contains("YES_TIRED_APPEARANCE") {
            dehydrationDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.4.DISPLAYLABEL",
                    defaultText: "Tired appearance"
                )
            )
        }
        if dehydrationSigns.contains("YES_SUNKEN_EYE_SOCKETS") {
            dehydrationDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.5.DISPLAYLABEL",
                    defaultText: "Sunken eye sockets"
                )
            )
        }
        if dehydrationSigns.contains("YES_FEWER_WET_DIAPERS") {
            dehydrationDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.6.DISPLAYLABEL",
                    defaultText: "Fewer wet diapers"
                )
            )
        }
        if dehydrationSigns.contains("YES_SUNKEN_FONTANELLE") {
            dehydrationDescriptions.append(
                TranslationsViewModel.shared.getTranslation(
                    key: "DIARY.DRINK.DRINK.OPTION.7.DISPLAYLABEL",
                    defaultText: "Sunken fontanelle"
                )
            )
        }

        return dehydrationDescriptions.isEmpty ? "?" : dehydrationDescriptions.joined(separator: ", ")
    }

    private func getRashValue(entry: Entry) -> String {
        guard let rashValues = entry.rash?.rashes, !rashValues.isEmpty else {
            return TranslationsViewModel.shared.getTranslation(
                key: "DIARY.RASH.RASH.OPTION.1.DISPLAYLABEL",
                defaultText: "No rash"
            )
        }

        if rashValues.contains("NO") {
            return TranslationsViewModel.shared.getTranslation(
                key: "DIARY.RASH.RASH.OPTION.1.DISPLAYLABEL",
                defaultText: "No rash"
            )
        }
        if rashValues.contains("YES_REDNESS_CAN_BE_PUSHED_AWAY") {
            return TranslationsViewModel.shared.getTranslation(
                key: "DIARY.RASH.RASH.OPTION.2.DISPLAYLABEL",
                defaultText: "Rash can be pushed away"
            )
        }
        if rashValues.contains("YES_REDNESS_CANNOT_BE_PUSHED_AWAY") {
            return TranslationsViewModel.shared.getTranslation(
                key: "DIARY.RASH.RASH.OPTION.3.DISPLAYLABEL",
                defaultText: "Rash cannot be pushed away"
            )
        }

        return "?"
    }

    @objc private func showDeleteSummaryBottomSheet(entryId: Int) {
        let deleteBottomSheetVC = UIViewController()
        deleteBottomSheetVC.view.backgroundColor = .white

        // Store the entryId as an associated property
        deleteBottomSheetVC.view.tag = entryId

        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.darkGray
        closeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        closeButton.addTarget(self, action: #selector(dismissBottomSheet), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = TranslationsViewModel.shared.getTranslation(key: "LOOP.DELETE.ALERT.HEADER", defaultText: "Delete records?")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Subtext Label
        let subtextLabel = UILabel()
        subtextLabel.text = TranslationsViewModel.shared.getTranslation(key: "LOOP.DELETE.ALERT.MESSAGE", defaultText: "Are you sure you want to delete the data?")
        subtextLabel.font = UIFont.systemFont(ofSize: 14)
        subtextLabel.numberOfLines = 0
        subtextLabel.textAlignment = .left
        subtextLabel.translatesAutoresizingMaskIntoConstraints = false

        // No Button
        let noButton = UIButton(type: .system)
        noButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "LOOP.ALERT.NO", defaultText: "No"), for: .normal)
        noButton.setTitleColor(.gray, for: .normal)
        noButton.layer.borderColor = UIColor.gray.cgColor
        noButton.layer.borderWidth = 1
        noButton.layer.cornerRadius = 10
        noButton.backgroundColor = .white
        noButton.addTarget(self, action: #selector(dismissBottomSheet), for: .touchUpInside)
        noButton.translatesAutoresizingMaskIntoConstraints = false

        // Yes Button
        let yesButton = UIButton(type: .system)
        yesButton.setTitle(TranslationsViewModel.shared.getTranslation( key: "LOOP.ALERT.YES", defaultText: "Yes"), for: .normal)
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0) // Custom color
        yesButton.layer.cornerRadius = 10
        yesButton.addTarget(self, action: #selector(confirmDeleteSummary(_:)), for: .touchUpInside)
        yesButton.translatesAutoresizingMaskIntoConstraints = false
        yesButton.tag = entryId

        // Button Stack View
        let buttonStackView = UIStackView(arrangedSubviews: [noButton, yesButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 18
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        deleteBottomSheetVC.view.addSubview(closeButton)
        deleteBottomSheetVC.view.addSubview(titleLabel)
        deleteBottomSheetVC.view.addSubview(subtextLabel)
        deleteBottomSheetVC.view.addSubview(buttonStackView)

        // Constraints
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: deleteBottomSheetVC.view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: deleteBottomSheetVC.view.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: deleteBottomSheetVC.view.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: deleteBottomSheetVC.view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: deleteBottomSheetVC.view.trailingAnchor, constant: -16),

            subtextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtextLabel.leadingAnchor.constraint(equalTo: deleteBottomSheetVC.view.leadingAnchor, constant: 16),
            subtextLabel.trailingAnchor.constraint(equalTo: deleteBottomSheetVC.view.trailingAnchor, constant: -16),

            buttonStackView.topAnchor.constraint(equalTo: subtextLabel.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: deleteBottomSheetVC.view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: deleteBottomSheetVC.view.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(lessThanOrEqualTo: deleteBottomSheetVC.view.bottomAnchor, constant: -24),
            noButton.heightAnchor.constraint(equalToConstant: 44),
            yesButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Set the modal presentation style
        deleteBottomSheetVC.modalPresentationStyle = .pageSheet
        if let sheet = deleteBottomSheetVC.sheetPresentationController {
            // Custom detent that adapts to content height
            let customDetent = UISheetPresentationController.Detent.custom { context in
                // Calculate the height based on the content size, with a minimum height for better appearance
                let estimatedHeight = closeButton.frame.height + titleLabel.frame.height +
                                      subtextLabel.frame.height + buttonStackView.frame.height + 80
                return max(estimatedHeight, 180) // Ensure a minimum height of 180
            }
            sheet.detents = [customDetent]
            sheet.prefersGrabberVisible = true
        }

        self.present(deleteBottomSheetVC, animated: true, completion: nil)
    }
    var refreshListView: (()->Void)?

    @objc private func confirmDeleteSummary(_ sender: UIButton) {
        let entryId = sender.tag
        print("Yes button clicked - proceed with delete logic for entryId:", entryId)
    
        AddEntryNetworkManager.shared.markEntryAsDeleted(entryId: Int64(entryId)){isMarked in
            if isMarked {
                self.refreshListView?()
                // Close the bottom sheet after deletion
                self.dismiss(animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Error", message: "failed to delete entry please try again", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
            }
            
        }
        // TODO: Implement delete logic for the entry with the given entryId
        // Example: Delete entry from the data source or database

     
    }

}

class FeverPhaseTapGestureRecognizer: UITapGestureRecognizer {
    var feverPhaseId: Int = 0
}

class FeverPhaseButton: UIButton {
    var feverPhaseId: Int = 0
}
