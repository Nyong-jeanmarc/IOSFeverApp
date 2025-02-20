//
//  documentFeverCrampsViewController.swift
//  FeverApp ios
//
//  Created by NEW on 17/09/2024.
//
import UIKit

// Custom UITableViewCell
class DocumentFeverCell: UITableViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        // Set transparent background or same color as table view background
        view.backgroundColor = .white
        return view
    }()
    
    let expandedTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Some descriptive text."
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true // Initially hidden
        return label
    }()
    
    var isExpanded = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupTapGesture()
        // Set the cell's background color to be transparent
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func findTableView() -> UITableView? {
        var view = self.superview
        while let superview = view {
            if let tableView = superview as? UITableView {
                return tableView
            }
            view = superview.superview
        }
        return nil
    }

    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(dateLabel)
        containerView.addSubview(conditionLabel)
        containerView.addSubview(expandedTextLabel)
        
        // ContainerView constraints
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 2)
        ])
        
        // DateLabel constraints
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
        ])
        
        let expandedBottomConstraint = expandedTextLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        expandedBottomConstraint.priority = .defaultLow // Allows it to collapse
        
        // ConditionLabel constraints
        NSLayoutConstraint.activate([
            conditionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            conditionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16)
        ])
        
        // ExpandedTextLabel constraints
        NSLayoutConstraint.activate([
            expandedTextLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            expandedTextLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            expandedTextLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
//            expandedTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -16)
            
            expandedBottomConstraint

        ])
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleExpansion))
        containerView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleExpansion() {
        isExpanded.toggle()
        expandedTextLabel.isHidden = !isExpanded
        // Notify the table view to update the row height
        UIView.animate(withDuration: 0.3) {
            self.superview?.superview?.layoutIfNeeded()
        }
        
        if let tableView = findTableView(), let indexPath = tableView.indexPath(for: self) {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
       
    }
}

// ViewController that contains the UITableView
class DocumentFeverViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    
    @IBOutlet weak var documentTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    let tableView = UITableView()

    // Sample data (This would usually come from a database or API)
//    let entries: [String] = []
    
    var feverCramps: [FeverCrampsEntity] = []
    var languageCode: String? = ""
    
    
    @IBAction func documentFeverCrampsButtonClicked(_ sender: Any) {
        // Get a reference to the storyboard
           let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" if your storyboard name is different
           
           // Instantiate the view controller using its storyboard ID
           let newViewController = storyboard.instantiateViewController(withIdentifier: "secondFeverDocViewController")
           
           // Add the new view controller's view as a subview
           self.addChild(newViewController) // Notify the parent-child relationship
           newViewController.view.frame = self.view.bounds // Set the frame to match the current view
           self.view.addSubview(newViewController.view) // Add the new view to the current view
           newViewController.didMove(toParent: self) // Notify the child that it has moved to the parent
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        documentTitle.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.FEVER_SEIZURE", defaultText: "Document fever cramps")
        
        // Set the navigation title
        navigationItem.title = "Document fever"
        
        // Set table view background color to match your design, such as light gray
        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .clear
        
        // Setup the table view
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none // To remove separator lines between cells
        tableView.register(DocumentFeverCell.self, forCellReuseIdentifier: "DocumentFeverCell")
        
        // TableView constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        
        // Add empty state view
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130),
            emptyStateView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])

        emptyStateView.isHidden = true // Hide initially
        
        // Fetch data from Core Data
            fetchFeverCrampsData()
    }
    @objc func backButtonTapped() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "rhfyjf")
        viewController?.modalPresentationStyle = .fullScreen
        self.present(viewController!, animated: true, completion: nil)
    }
    
    func fetchFeverCrampsData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        guard let profileId = appDelegate.fetchProfileId() else { return }
        
        feverCramps = fetchFeverCramps(profileId: profileId) ?? []
        (languageCode, _) = appDelegate.fetchUserLanguage()
        
        print("Fetched \(feverCramps.count) records") // Debugging Log

        DispatchQueue.main.async {
            self.emptyStateView.isHidden = !self.feverCramps.isEmpty
            self.tableView.isHidden = self.feverCramps.isEmpty
            self.tableView.reloadData()
        }
    }

    
    // TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feverCramps.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentFeverCell", for: indexPath) as! DocumentFeverCell
        
        let feverCramp = feverCramps[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"

        // Pass the stored locale code
        dateFormatter.locale = Locale(identifier: languageCode ?? "en")

        let dateString = feverCramp.feverCrampsDate != nil ? dateFormatter.string(from: feverCramp.feverCrampsDate!) : "No Date"
        print(dateString) // If "fr", output: "05 mai, 2022"

        
        cell.dateLabel.text = "\(dateString) \(feverCramp.feverCrampsTime ?? "")"
        cell.conditionLabel.text = TranslationsViewModel.shared.getTranslation(key: "SEIZURE.TEXT.1", defaultText: "Fever cramps")
        // Set expandedTextLabel to feverCrampsDescription
            cell.expandedTextLabel.text = feverCramp.feverCrampsDescription ?? "No Description"
        
        return cell
    }
    
//    // Adjust the row height
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cell = tableView.cellForRow(at: indexPath) as? DocumentFeverCell
        return cell?.isExpanded == true ? UITableView.automaticDimension : 50
    }

    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // Reduced initial button height
    }
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = TranslationsViewModel.shared.getTranslation(key: "SEIZURE.TEXT.2", defaultText: "Record a fever cramp by clicking on the pen in the upper right corner!")
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)

        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        return view
    }()

    
}


