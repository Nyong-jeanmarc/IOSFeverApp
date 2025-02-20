//
//  ChooseCountryViewController.swift
//  FeverApp ios
//
//  Created by NEW on 29/07/2024.
//

import UIKit
import CoreData

/// custom UITableViewCell to display country options.
class CountryCell: UITableViewCell {
    // Label to display the country name
    let countryLabel = UILabel()
    // Button to display a checkbox
    let checkBox = UIButton()

    // Initializer for creating the cell programmatically
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // Ser up constraints and add subviews
        countryLabel.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(countryLabel)
        contentView.addSubview(checkBox)

        countryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        countryLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true

        checkBox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 24).isActive = true

        checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        checkBox.tintColor = UIColor.gray
    }

    // Required initializer for creating the cell from a storyboard
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// ViewController to allow the user to choose a country.
class ChooseCountryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    var selectedCountry = ""
    // MARK: - Outlets
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var buttomView: UIView!
    
    @IBOutlet weak var dropButton: UIButton!
    
    @IBOutlet var middleView: UIView!
    
    @IBAction func dropButtonAction(_ sender: Any) {
        tableView.isHidden = !tableView.isHidden
    }
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chooseYourCountryTitleLabel: UITextField!
    @IBOutlet weak var selectCountryLabel: UILabel!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    // MARK: - Properties
    let countries = ["Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo (Brazzaville)", "Congo (Kinshasa)", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Lithuania", "Luxembourg", "Macedonia (FYROM)", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar (Burma)", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Korea", "Norway", "Oman", "Pakistan", "Palau", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste (East Timor)", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe"]
    var countriesUsed: [String]!
    var checkedCountries: [Bool] = []
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        selectCountryLabel.text = TranslationsViewModel.shared.getTranslation(key: "NATIONALITY.PLACEHOLDER",defaultText: "Your country")
        nextBtn.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
        buttomView.layer.shadowColor = UIColor.lightGray.cgColor
        buttomView.layer.shadowOpacity = 0.3
        buttomView.layer.shadowRadius = 5
        buttomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        middleView.layer.shadowColor = UIColor.lightGray.cgColor
        middleView.layer.shadowOpacity = 0.3
        middleView.layer.shadowRadius = 5
        middleView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.3
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 18, height: 18))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = .gray
        // Create a custom UILabel for the title
            let navtitleLabel = UILabel()
        navtitleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "COUNTRY.BOTTOMSHEET.CHOOSE", defaultText: "Choose your country")
            navtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Customize the font as needed
            navtitleLabel.sizeToFit() // Adjust the size to fit the content

            // Create a left bar button item as a container for the titleLabel
            let leftTitleItem = UIBarButtonItem(customView: navtitleLabel)
        navigationItem.leftBarButtonItems = [backButton, leftTitleItem].compactMap { $0 }
           navigationItem.leftBarButtonItem = backButton
           navigationItem.hidesBackButton = false
        middleView.layer.cornerRadius = 16
        
        textField.isEnabled = false
        super.viewDidLoad()
        topView.layer.cornerRadius = 20
        buttomView.layer.cornerRadius = 20
        countriesUsed = countries
        checkedCountries = Array(repeating: false, count: countries.count)
        
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.delegate = self
        
        
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountryCell.self, forCellReuseIdentifier: "CountryCell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
        
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 120))
        headerView.backgroundColor = .white
        
        let topBar = UIView()
        topBar.backgroundColor = UIColor.gray
        headerView.addSubview(topBar)
        
        let titleLabel = UILabel(frame: CGRect(x: 16, y: 50, width: headerView.bounds.width - 32, height: 20))
        titleLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "COUNTRY.BOTTOMSHEET.CHOOSE", defaultText: "Choose your country")
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        headerView.addSubview(titleLabel)
        
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.darkGray
        closeButton.addTarget(self, action: #selector(hideTableView), for: .touchUpInside)
        headerView.addSubview(closeButton)
        
        let searchTextField = UITextField()
        searchTextField.delegate = self
        searchTextField.placeholder = TranslationsViewModel.shared.getAdditionalTranslation(key: "COUNTRY.BOTTOMSHEET.INPUT", defaultText: "Search country")
        searchTextField.borderStyle = .roundedRect
        headerView.addSubview(searchTextField)
        
        // Add constraints to the search text field and top bar
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchTextField.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        topBar.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 12).isActive = true
        topBar.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.12).isActive = true
        topBar.heightAnchor.constraint(equalToConstant: 4).isActive = true
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        closeButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 17).isActive = true
        
        
        tableView.tableHeaderView = headerView
        
        // Set the default country to the device country
        detectDeviceCountry()
        
        // Update button title
        updateChooseYourCountryTitleLabel()
    }
    // MARK: - Helper Methods
    /// Hides the table view.
    @objc func hideTableView() {
        tableView.isHidden = true
    }
    
    /// Sets the default country to the device's current locale.
    private func detectDeviceCountry() {
        let deviceCountryCode = Locale.current.region?.identifier ?? "DE"
        let locale = Locale(identifier: deviceCountryCode)
        let deviceCountry = locale.localizedString(forRegionCode: deviceCountryCode) ?? "Germany"
        ChooseCountryModel.shared.defaultCountry = deviceCountry
        
        if let index = countries.firstIndex(of: deviceCountry) {
            
            checkedCountries[index] = true

        }
    }
    
    /// Updates the "Choose your country" TitleLabel to the device's current country.
    private func updateChooseYourCountryTitleLabel() {
        let deviceCountryCode = Locale.current.region?.identifier ?? "DE"
        let locale = Locale(identifier: deviceCountryCode)
        let deviceCountry = locale.localizedString(forRegionCode: deviceCountryCode) ?? "Germany"
        
        chooseYourCountryTitleLabel.text = "\(deviceCountry)"
        
    }
    // MARK: - UITextFieldDelegate
    func textField(_ searchTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (searchTextField.text ?? "") + string
        if string.isEmpty {
            if (searchText.count == 1){
                // If search text is empty, display all countries
                countriesUsed = countries
            }else{
                let filteredCountries = countries.filter { $0.lowercased().hasPrefix(searchText.lowercased()) }
                countriesUsed = filteredCountries
            } }else {
                // Otherwise, filter countries based on search text
                let filteredCountries = countries.filter { $0.lowercased().hasPrefix(searchText.lowercased()) }
                countriesUsed = filteredCountries
            }
        
        tableView.reloadData()
        return true
    }
    func resizeImage(image: UIImage, to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    @objc func handleBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tableView.isHidden = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableView.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Dismiss the keyboard when the "Done" key is clicked
            textField.resignFirstResponder()
            return true
        }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesUsed.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as! CountryCell
        
        cell.countryLabel.text = countriesUsed[indexPath.row]
        
        if checkedCountries[indexPath.row] {
            cell.checkBox.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
        } else {
            cell.checkBox.setImage(UIImage(systemName: "square"), for: .normal)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCountry = countriesUsed[indexPath.row]
        textField.text = selectedCountry
        // Deselect all checkboxes
        for i in 0..<checkedCountries.count {
            checkedCountries[i] = false
        }
        
        // Select the current checkbox
        checkedCountries[indexPath.row] = true
        
        // Reload the table view to update the checkboxes
        tableView.reloadData()
        tableView.isHidden = true
    }
    
    func handleNavigationToWatchIntroVideoScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let VideoVC = storyboard.instantiateViewController(withIdentifier: "VideoViewController") as? PlayVideoViewController {
            self.navigationController?.pushViewController(VideoVC, animated: true)
        }
    }
    
    
    @IBAction func handleNextUIButtonclick(_ sender: Any) {
        // Save the selected country
        ChooseCountryModel.shared.saveCountry(selectedCountry)
        handleNavigationToWatchIntroVideoScreen()
    }
}
