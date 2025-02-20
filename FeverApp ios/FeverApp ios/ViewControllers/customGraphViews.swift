//
//  customGraphViews.swift
//  FeverApp ios
//
//  Created by NEW on 05/12/2024.
//

import Foundation
import UIKit
import UIKit

class CustomBottomSheetViewController: UIViewController {
    
    // MARK: - UI Components
    
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("×", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.INFO", defaultText: "Entry info")
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        
        return label
    }()
    
    private let temperatureCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.5
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    var iconName : String?
    var infoDescription : String?
    var entry : LocalEntry?
 
    init(iconName: String?, infoDescription : String?, Entry: LocalEntry) {
          self.iconName = iconName
        self.infoDescription = infoDescription
        self.entry = Entry
          super.init(nibName: nil, bundle: nil)
      }
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    private lazy var temperatureIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: iconName ?? "temperature_icon")
        imageView.tintColor = .systemBlue
        return imageView
    }()
    private lazy var temperatureInfoLabel: UILabel = {
        let label = UILabel()
        label.text = infoDescription 
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private let entrySummaryButton: UIButton = createActionButton(title: TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.SUMMARY", defaultText: "Entry summary"), iconName: "more_icon", chevron: true)
    private let editEntryButton: UIButton = createActionButton(title: TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.EDIT", defaultText: "Edit entry"), iconName: "pen", chevron: true)
    private let deleteSummaryButton: UIButton = createActionButton(title: TranslationsViewModel.shared.getAdditionalTranslation(key: "ENTRY.BOTTOMSHEET.DELETE", defaultText: "Delete summary"), iconName: "trash_can_icon", chevron: true)
    
   
   
    
    @objc func entrySummaryButtonTapped(){
        // Date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        let simpleDateFormatter = DateFormatter()
        simpleDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        let simpleTimeFormatter = DateFormatter()
        simpleTimeFormatter.dateFormat = "HH:mm:ss"
        let entrySummaryVC = EntrySummaryViewController()
        entrySummaryVC.entryInfo = mapEntry(entry: entry!, dateFormatter: dateFormatter, timeFormatter: timeFormatter)
        entrySummaryVC.modalPresentationStyle = .fullScreen

        // Embed in a UINavigationController
        let navigationController = UINavigationController(rootViewController: entrySummaryVC)
        navigationController.modalPresentationStyle = .fullScreen

        // Dismiss the current view controller and present the navigation controller
      
            self.present(navigationController, animated: true, completion: nil)
        
    }
    // Helper to add borders
    private static func createActionButton(title: String, iconName: String, chevron: Bool) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.setImage(UIImage(named: iconName), for: .normal)
        button.tintColor = UIColor.lightGray
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        if chevron {
            let chevronImage = UIImageView(image: UIImage(systemName: "chevron.right"))
            chevronImage.tintColor = .darkGray
            chevronImage.translatesAutoresizingMaskIntoConstraints = false
            button.addSubview(chevronImage)
            
            NSLayoutConstraint.activate([
                chevronImage.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                chevronImage.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16)
            ])
        }
        return button
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    var reloadGraph: (()->Void)?
    @objc func deleteEntry(){
        guard let entryId = self.entry?.entryId else {
              print("Entry ID is nil. Cannot proceed with deletion.")
              return
          }
        let deleteSummaryVC = DeleteSummaryBottomSheet(entryId: Int(entry!.entryId))
           deleteSummaryVC.onDeleteConfirmed = { [weak self] in
               AddEntryNetworkManager.shared.markEntryAsDeleted(entryId: entryId){isMarked in
                   if isMarked {
                       self?.reloadGraph?()
                       // Close the bottom sheet after deletion
                       deleteSummaryVC.dismiss(animated: true, completion: nil)
                   }else{
                       let alertController = UIAlertController(title: "Error", message: "failed to delete entry please try again", preferredStyle: .alert)
                       let cancelAction = UIAlertAction(title: "ok", style: .cancel)
                       alertController.addAction(cancelAction)
                       self?.present(alertController, animated: true)
                   }
                   
               }
              
           }
       present(deleteSummaryVC, animated: true, completion: nil)
    }
    @objc func editEntry(){
        guard let entryId = self.entry?.entryId else {
              print("Entry ID is nil. Cannot proceed with deletion.")
              return
          }
        editEntryNetworkManager.shared.editEntry(entryId: entryId){ success, objectIds in
            if success {
                let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEntryViewController") as! AddEntryController
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
                print("Associated object IDs: \(objectIds)")
            } else {
                let alertController = UIAlertController(title: "Error", message: "Failed to edit entry please try again", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ok", style: .cancel)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true)
                print("Failed to fetch entry or its associated objects.")
            }
        }
    }
    // MARK: - Setup View
    private func setupView() {
        entrySummaryButton.addTarget(self, action: #selector(entrySummaryButtonTapped) , for: .touchUpInside)
        deleteSummaryButton.addTarget(self, action: #selector(deleteEntry) , for: .touchUpInside)
        editEntryButton.addTarget(self, action: #selector(editEntry) , for: .touchUpInside)
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 16
        
        // Add subviews
    
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(temperatureCardView)
        view.addSubview(entrySummaryButton)
        view.addSubview(editEntryButton)
        view.addSubview(deleteSummaryButton)
        
        temperatureCardView.addSubview(temperatureIconImageView)
        temperatureCardView.addSubview(temperatureInfoLabel)
        
        layoutUIComponents()
    }
    
    private func layoutUIComponents() {
        // Top Bar
     
        
        // Close Button
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            closeButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        // Title Label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Temperature Card View
        temperatureCardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureCardView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            temperatureCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            temperatureCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            temperatureCardView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        temperatureIconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureIconImageView.trailingAnchor.constraint(equalTo: temperatureCardView.trailingAnchor, constant: -12),
            temperatureIconImageView.topAnchor.constraint(equalTo: temperatureCardView.topAnchor,constant: 20),
            temperatureIconImageView.widthAnchor.constraint(equalToConstant: 24),
            temperatureIconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        temperatureInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            temperatureInfoLabel.leadingAnchor.constraint(equalTo: temperatureCardView.leadingAnchor, constant: 25),
            temperatureInfoLabel.trailingAnchor.constraint(equalTo: temperatureCardView.trailingAnchor, constant: -12),
            temperatureInfoLabel.centerYAnchor.constraint(equalTo: temperatureCardView.centerYAnchor)
        ])
        
        // Buttons
        entrySummaryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            entrySummaryButton.topAnchor.constraint(equalTo: temperatureCardView.bottomAnchor, constant: 16),
            entrySummaryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            entrySummaryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            entrySummaryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        addBottomBorder(to: entrySummaryButton)
        
        editEntryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editEntryButton.topAnchor.constraint(equalTo: entrySummaryButton.bottomAnchor),
            editEntryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editEntryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editEntryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        addBottomBorder(to: editEntryButton)
        
        deleteSummaryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteSummaryButton.topAnchor.constraint(equalTo: editEntryButton.bottomAnchor),
            deleteSummaryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            deleteSummaryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteSummaryButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        addBottomBorder(to: deleteSummaryButton)
    }
    
    private func addBottomBorder(to view: UIView) {
        let border = UIView()
        border.backgroundColor = UIColor.systemGray4
        border.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(border)
        
        NSLayoutConstraint.activate([
            border.heightAnchor.constraint(equalToConstant: 1),
            border.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            border.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            border.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}
class DeleteSummaryBottomSheet: UIViewController {

    // MARK: - Properties
    private let entryId: Int
    var onDeleteConfirmed: (() -> Void)?

    // MARK: - Initializer
    init(entryId: Int) {
        self.entryId = entryId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white

        // Close Button
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = UIColor.darkGray
        closeButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        closeButton.addTarget(self, action: #selector(dismissBottomSheet), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = TranslationsViewModel.shared.getTranslation(
            key: "LOOP.DELETE.ALERT.HEADER",
            defaultText: "Delete records?"
        )
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Subtext Label
        let subtextLabel = UILabel()
        subtextLabel.text = TranslationsViewModel.shared.getTranslation(
            key: "LOOP.DELETE.ALERT.MESSAGE",
            defaultText: "Are you sure you want to delete the data?"
        )
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
        yesButton.setTitle(TranslationsViewModel.shared.getTranslation(
            key: "LOOP.ALERT.YES",
            defaultText: "Yes"
        ), for: .normal)
        yesButton.setTitleColor(.white, for: .normal)
        yesButton.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 252/255, alpha: 1.0)
        yesButton.layer.cornerRadius = 10
        yesButton.addTarget(self, action: #selector(confirmDeleteSummary), for: .touchUpInside)
        yesButton.translatesAutoresizingMaskIntoConstraints = false

        // Button Stack View
        let buttonStackView = UIStackView(arrangedSubviews: [noButton, yesButton])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 18
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        view.addSubview(closeButton)
        view.addSubview(titleLabel)
        view.addSubview(subtextLabel)
        view.addSubview(buttonStackView)

        // Constraints
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            subtextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            subtextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            buttonStackView.topAnchor.constraint(equalTo: subtextLabel.bottomAnchor, constant: 24),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -24),
            noButton.heightAnchor.constraint(equalToConstant: 44),
            yesButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        // Set the modal presentation style
        modalPresentationStyle = .pageSheet
        if let sheet = self.sheetPresentationController {
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

    }

    // MARK: - Actions
    @objc private func dismissBottomSheet() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func confirmDeleteSummary() {
        dismiss(animated: true) {
            self.onDeleteConfirmed?()
        }
    }
}





