//
////
//  EmergencyViewController .swift
//  FeverApp ios
//
//  Created by user on 9/9/24.
//

import UIKit
class EmergencyViewController:UIViewController{
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var emergencyTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emergencyTitle.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.EMERGENCY.TITLE.1", defaultText: "Emergency")
        
        
        // Round the corners for topView
        topView.layer.cornerRadius = 25
        topView.layer.masksToBounds = true
        // Setup the emergency info view
             setupEmergencyInfoView()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
      }

      @objc func backButtonTapped() {
          let viewController = self.storyboard?.instantiateViewController(withIdentifier: "rhfyjf")
          viewController?.modalPresentationStyle = .fullScreen
          self.present(viewController!, animated: true, completion: nil)
      }
    
    
    private func setupEmergencyInfoView() {
            let emergencyInfoView = EmergencyInfoView()
            emergencyInfoView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(emergencyInfoView)
            
            // Add constraints to position it within the view controller
            NSLayoutConstraint.activate([
                emergencyInfoView.topAnchor.constraint(equalTo:  topView.bottomAnchor, constant: 20), // Adjust this based on your layout
                emergencyInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                emergencyInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                emergencyInfoView.heightAnchor.constraint(greaterThanOrEqualToConstant: 420)
            ])
        }
    }

class EmergencyInfoView: UIView {

    // Title labels
    private let emergencyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.EMERGENCY.HEADING.1", defaultText: "Where to turn in an emergency?")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()

    private let pediatricianTitleLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.EMERGENCY.HEADING.2", defaultText: "Your pediatrician:")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    // Emergency info labels
    private let allOverGermanyLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.EMERGENCY.TEXT.1", defaultText: "YAll over Germany")
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let medicalServiceLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.EMERGENCY.TEXT.2", defaultText: "Medical on-call service:116 117").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)
        
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private let additionalInfoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        let text1 = TranslationsViewModel.shared.getTranslation(key: "SHELL.EMERGENCY.TEXT.3", defaultText: "Information about a doctor on duty near you")
        let text2 = TranslationsViewModel.shared.getTranslation(key: "SHELL.EMERGENCY.TEXT.4", defaultText: "(always free of charge: mobile and landline - without area code)")
        let text3 = TranslationsViewModel.shared.getTranslation(key: "SHELL.EMERGENCY.TEXT.5", defaultText: "Search for a medical on-call service: www.116117.de").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)

        let fullText = "\(text1) \(text2)\n\(text3)"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let linkRange = (fullText as NSString).range(of: "www.116117.de")
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: linkRange)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)
        
        label.attributedText = attributedString
        return label
    }()

    private let emergencyNumberLabel: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "SHELL.EMERGENCY.TEXT.6", defaultText: "Emergency number (life-threatening cases): 112")
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    private let emergencySeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    private let pediatricianNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Frank-Peter Drobnitzky"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let pediatricianAddressLabel: UILabel = {
        let label = UILabel()
        label.text = "Carl-Bertelsmann-Str. 71"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    private let addressSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    // Icons
    private let eBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "E-box")
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()

    private let locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "location")
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()
    
    private let pediatricianImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "E-box") // Assuming you want the same icon for consistency
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return imageView
    }()

    // Pediatrician info - vertically aligned with icon
    private lazy var pediatricianInfoStackView: UIStackView = {
        let addressStackView = UIStackView(arrangedSubviews: [locationImageView, pediatricianAddressLabel])
        addressStackView.axis = .horizontal
        addressStackView.spacing = 8
        addressStackView.alignment = .center

        let nameStackView = UIStackView(arrangedSubviews: [pediatricianImageView, pediatricianNameLabel])
        nameStackView.axis = .horizontal
        nameStackView.spacing = 8
        nameStackView.alignment = .center
        
        let verticalStackView = UIStackView(arrangedSubviews: [nameStackView, addressStackView])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.alignment = .leading // Align the items to the left
        return verticalStackView
    }()

    // Main stack view
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            emergencyTitleLabel,
            allOverGermanyLabel, // New text added here
            medicalServiceLabel,
            additionalInfoLabel,
            emergencyNumberLabel,
            emergencySeparatorView, // Small bar under "Emergency number"
            pediatricianTitleLabel,
            pediatricianInfoStackView, // Pediatrician info stacked vertically with icon
            addressSeparatorView // Small bar under "Carl-Bertelsmann-Str. 71"
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor

        addSubview(mainStackView)

        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}
