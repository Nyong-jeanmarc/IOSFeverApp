//
//  AddYourPediatricianViewController.swift
//  FeverApp ios
//
//  Created by NEW on 13/08/2024.
//
import UIKit
class AddYourPediatricianViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UISearchBarDelegate {

    required init?(coder: NSCoder) {
        self.tableView = UITableView()
        super.init(coder: coder)
        // Additional setup if needed
    }
    

    @IBAction func dropDown(_ sender: Any) {
        tableView.isHidden = !tableView.isHidden
    }
    
    @IBOutlet weak var dropDown: UIButton!
    
    @IBOutlet weak var textField1: UITextField!
    
    @IBOutlet weak var textField2: UITextField!
    
    @IBOutlet weak var textField3: UITextField!
    
    @IBOutlet weak var textField4: UITextField!
    
    @IBOutlet weak var textField5: UITextField!
    
    @IBOutlet weak var textField6: UITextField!
    
    @IBOutlet weak var textField7: UITextField!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var middleView: UIView!
    
    @IBOutlet weak var buttomView: UIView!
    
    let countries = ["Afghanistan", "Albania", "Algeria", "American Samoa", "Andorra", "Angola", "Anguilla", "Antigua and Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria", "Azerbaijan",     "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "British Virgin Islands", "Brunei", "Bulgaria", "Burkina Faso", "Burundi",
                     "Cabo Verde", "Cambodia", "Cameroon", "Canada", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic",
                     "Denmark", "Djibouti", "Dominica", "Dominican Republic",
                     "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini", "Ethiopia",
                     "Fiji", "Finland", "France",
                     "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana",
                     "Haiti", "Honduras", "Hungary",
                     "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy",
                     "Jamaica", "Japan", "Jordan",
                     "Kazakhstan", "Kenya", "Kiribati", "Kuwait", "Kyrgyzstan",
                     "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg",
                     "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar",
                     "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Korea", "North Macedonia", "Norway",
                     "Oman",
                     "Pakistan", "Palau", "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal",
                     "Qatar",
                     "Romania", "Russia", "Rwanda",
                     "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Sweden", "Switzerland", "Syria",
                     "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu",
                     "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States", "Uruguay", "Uzbekistan",
                     "Vanuatu", "Vatican City", "Venezuela", "Vietnam",
                     "Yemen",
                     "Zambia", "Zimbabwe"]

    var filteredCountries: [String] = []
   
    var tableView : UITableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredCountries = countries
        button.backgroundColor = .gray
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        textField1.delegate = self
                textField2.delegate = self
                textField3.delegate = self
                textField4.delegate = self
                textField5.delegate = self
                textField6.delegate = self
                textField7.delegate = self
        tableView.isHidden = true
        
        topView.layer.borderColor = UIColor.white.cgColor
        topView.layer.borderWidth = 1.0 // Border width in points
                topView.layer.cornerRadius = 15.0
    middleView.layer.borderColor = UIColor.white.cgColor
        middleView.layer.borderWidth = 1.0 // Border width in points
                middleView.layer.cornerRadius = 5.0
        buttomView.layer.borderColor = UIColor.white.cgColor
        buttomView.layer.borderWidth = 1.0 // Border width in points
                buttomView.layer.cornerRadius = 10.0
        
        textField1.layer.borderColor = UIColor.lightGray.cgColor
                textField1.layer.borderWidth = 1.0
                textField1.layer.cornerRadius = 6.0
        textField1.layer.shadowColor = UIColor.darkGray.cgColor
                textField1.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
                textField1.layer.shadowOpacity = 0.3
                textField1.layer.shadowRadius = 1.0
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField1.frame.height))
        textField1.leftView = paddingView
        textField1.leftViewMode = .always
        
        textField2.layer.borderColor = UIColor.lightGray.cgColor
                textField2.layer.borderWidth = 1.0
                textField2.layer.cornerRadius = 6.0
        textField2.layer.shadowColor = UIColor.darkGray.cgColor
                textField2.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
                textField2.layer.shadowOpacity = 0.3
                textField2.layer.shadowRadius = 1.0
        let paddingView2 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField1.frame.height))
        textField2.leftView = paddingView2
        textField2.leftViewMode = .always
        
        textField3.layer.borderColor = UIColor.lightGray.cgColor
                textField3.layer.borderWidth = 1.0
                textField3.layer.cornerRadius = 6.0
        textField3.layer.shadowColor = UIColor.darkGray.cgColor
                textField3.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
                textField3.layer.shadowOpacity = 0.3
                textField3.layer.shadowRadius = 1.0
        let paddingView3 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField1.frame.height))
        textField3.leftView = paddingView3
        textField3.leftViewMode = .always
        
        textField4.layer.borderColor = UIColor.lightGray.cgColor
                textField4.layer.borderWidth = 1.0
                textField4.layer.cornerRadius = 6.0
        textField4.layer.shadowColor = UIColor.darkGray.cgColor
                textField4.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
                textField4.layer.shadowOpacity = 0.3
                textField4.layer.shadowRadius = 1.0
        let paddingView4 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField1.frame.height))
        textField4.leftView = paddingView4
        textField4.leftViewMode = .always
        
        textField5.layer.borderColor = UIColor.lightGray.cgColor
                textField5.layer.borderWidth = 1.0
                textField5.layer.cornerRadius = 6.0
        textField5.layer.shadowColor = UIColor.darkGray.cgColor
                textField5.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
                textField5.layer.shadowOpacity = 0.3
                textField5.layer.shadowRadius = 1.0
        let paddingView5 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField1.frame.height))
        textField5.leftView = paddingView5
        textField5.leftViewMode = .always
        
        textField6.layer.borderColor = UIColor.lightGray.cgColor
                textField6.layer.borderWidth = 1.0
                textField6.layer.cornerRadius = 6.0
        textField6.layer.shadowColor = UIColor.darkGray.cgColor
                textField6.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
                textField6.layer.shadowOpacity = 0.3
                textField6.layer.shadowRadius = 1.0
        let paddingView6 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField1.frame.height))
        textField6.leftView = paddingView6
        textField6.leftViewMode = .always
        
        textField7.layer.borderColor = UIColor.lightGray.cgColor
                textField7.layer.borderWidth = 1.0
                textField7.layer.cornerRadius = 6.0
        textField7.layer.shadowColor = UIColor.darkGray.cgColor
                textField7.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
                textField7.layer.shadowOpacity = 0.3
                textField7.layer.shadowRadius = 1.0
        let paddingView7 = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField1.frame.height))
        textField7.leftView = paddingView7
        textField7.leftViewMode = .always
        view.addSubview(tableView)
        
        textField4.delegate = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 30, width: tableView.frame.width, height: 40))
       
        tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        tableView.layer.cornerRadius = 20// adjust the height as needed
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.cornerRadius = 10
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 120))
        headerView.backgroundColor = .white

        let topBar = UIView()
        topBar.backgroundColor = UIColor.gray
        headerView.addSubview(topBar)
        let titleLabel = UILabel(frame: CGRect(x: 215, y: 50, width: headerView.bounds.width - 200, height: 20))
        titleLabel.text = "Choose your country"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        headerView.addSubview(titleLabel)
        let closeButton = UIButton()
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.darkGray
        closeButton.addTarget(self, action: #selector(hidetableView), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(closeButton)
        let searchButton = UIButton()
            let searchbutton = UIButton(type: .system)
            searchbutton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
            searchButton.tintColor = UIColor.lightGray
            searchbutton.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview(searchButton)
        let searchTextField = UITextField()
        searchTextField.delegate = self
            searchTextField.placeholder = "Search country"
            searchTextField.borderStyle = .roundedRect
            headerView.addSubview(searchTextField)
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
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20).isActive = true
        searchButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 24).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
        tableView.tableHeaderView = headerView
        
    }

    @objc func doneTapped() {
        textField4.resignFirstResponder()
    }
    @objc func hidetableView() {
        tableView.isHidden = true
    }
    func textField(_ searchTextField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (searchTextField.text ?? "") + string
        if string.isEmpty {
            if (searchText.count == 1){
                // If search text is empty, display all countries
                filteredCountries = countries
            }else{
                let filteredCountries = countries.filter { $0.lowercased().hasPrefix(searchText.lowercased()) }
                self.filteredCountries = filteredCountries
            } }else {
            // Otherwise, filter countries based on search text
            let filteredCountries = countries.filter { $0.lowercased().hasPrefix(searchText.lowercased()) }
                self.filteredCountries = filteredCountries
        }
        
        tableView.reloadData()
        return true
    }

    func textFieldDidBeginEditing(_ textField4: UITextField) {
        tableView.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        if indexPath.row == 0 {
            cell.contentView.topAnchor.constraint(equalTo: cell.topAnchor, constant: -50).isActive = true
        }
        cell.textLabel?.text = filteredCountries[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textField4.text = filteredCountries[indexPath.row]
        textField4.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
        
        
    }
   
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textFields = [textField1, textField2, textField3, textField4, textField5, textField6, textField7]
        let filledTextFields = textFields.filter { $0?.text != "" }
        if filledTextFields.count == 7 {
            button.backgroundColor = UIColor(red: 168/255, green: 193/255, blue: 247/255, alpha: 1)
        } else {
            button.backgroundColor = .lightGray
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField === textField4 {
            // Show your tableView here
            // For example:
            tableView.isHidden = false
        } else {
            // Hide your tableView if it's already shown
            tableView.isHidden = true
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tableView.isHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tableView.isHidden = true
        return true
    }
   }
