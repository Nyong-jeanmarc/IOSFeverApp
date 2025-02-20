//
//  basicPrincipleViewController.swift
//  FeverApp ios
//
//  Created by Bar Bie  on 09/09/2024.
//

import UIKit


class basicPrinciplesViewController: UIViewController{
    
    @IBOutlet var topView: UIView!
  
    @IBOutlet var middleView: UIView!
    @IBAction func backBtnTapAction(_ sender: UIButton) {
        backButtonTapped()
    }
    
    // Back button action
    @objc private func backButtonTapped() {
        // Perform action for the back button, like dismissing the view controller
        // If you're not using a navigation controller, just dismiss
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var titlelabel: UILabel!
    
    @IBOutlet weak var drugsTitle: UILabel!
    
    @IBOutlet weak var drugsText1: UILabel!
    
    @IBOutlet weak var drugsText2: UILabel!
    
    @IBOutlet weak var drugsText3: UILabel!
    
    @IBOutlet weak var drugsSubText: UILabel!
    
    
    @IBOutlet weak var doctorTitle: UILabel!
    
    @IBOutlet weak var doctorText1: UILabel!
    
    @IBOutlet weak var doctorText2: UILabel!
    
    @IBOutlet weak var doctorText3: UILabel!
    
    @IBOutlet weak var doctorText4: UILabel!
    
    @IBOutlet weak var doctorText5: UILabel!
    
    @IBOutlet weak var doctorSubText: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
        middleView.layer.cornerRadius = 10
        middleView.layer.masksToBounds = true
        titlelabel.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-LIST.TEXT.3", defaultText: "Basic principles")
        
        drugsTitle.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.1", defaultText: "Drugs")
        drugsText1.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.2", defaultText: "Antipyretic drugs are not necessary as long as")
        drugsText2.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.3", defaultText: "no severe pain exists and")
        drugsText3.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.4", defaultText: "well-being is in the green range and")
        drugsSubText.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.5", defaultText: "This also applies if the temperature rises above 38.5 °C.")

        doctorTitle.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.6", defaultText: "Doctor's contact")
        doctorText1.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.7", defaultText: "A doctor's contact is not necessary as long as you are")
        doctorText2.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.8", defaultText: "Feeling confident")
        doctorText3.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.9", defaultText: "there are no warning signs")
        doctorText4.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.10", defaultText: "there is no lack of taken fluids")
        doctorText5.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.11", defaultText: "the fever does not persist for more than 3 days")
        doctorSubText.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.BASIC_PRINCIPLES.TEXT.12", defaultText: "<strong>Caution:</strong> For babies under 3 months of age, a visit to the doctor should already take place if the temperature exceeds 38 °C.").replacingOccurrences(of: "<strong>", with: "").replacingOccurrences(of: "</strong>", with: "")
        
    }
}
