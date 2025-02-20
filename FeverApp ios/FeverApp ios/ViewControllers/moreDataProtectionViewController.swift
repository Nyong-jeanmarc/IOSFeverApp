//
//  moreDataProtectionViewController.swift
//  FeverApp ios
//
//  Created by NEW on 16/09/2024.
//
//

//

import UIKit

class moreDataProtectionViewController:UIViewController{
   
    @IBOutlet var topView: UIView!
    
    @IBOutlet weak var dataProtectionTitle: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            topView.layer.cornerRadius = 20
            topView.layer.masksToBounds = true
            
            dataProtectionTitle.text = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TITLE", defaultText: "Data protection")
     
                    // Scroll View
                    let scrollView = UIScrollView()
                    scrollView.translatesAutoresizingMaskIntoConstraints = false
                    view.addSubview(scrollView)
                    
                    // Content View
                    let contentView = UIView()
                    contentView.translatesAutoresizingMaskIntoConstraints = false
                    scrollView.addSubview(contentView)
                    
                    // Constraints for scroll view and content view
                    NSLayoutConstraint.activate([
                        scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20), // Scroll view below topView
                        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                        
                        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
                    ])
                    
                    // Full text based on the image
            let text1 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.HEADING.1", defaultText: "Introduction to data protection:")

            let text2 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.1", defaultText: "The FeverApp is an instrument of a register study on behalf of the Federal Ministry of Education and Research (BMBF) under the direction of the pediatrician Prof. Dr. med. David Martin from the University of Witten/Herdecke. The aim of this study is to understand as precisely as possible how fever phases develop in children and generally in infectious diseases. In addition, the FeverApp is intended to support communication between parents/patients and the pediatrician/doctor and to provide parents with advice on how to deal with their child's fever.")

            let text3 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.2", defaultText: "The following sources of information are relevant for this:")

            let text4 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.3", defaultText: "The documentation of the fever phases by the users (in children by the caregivers) in the app, in order to be able to follow all fever phases and acute infectious diseases as closely as possible and not only the fever phases and diseases with doctor's visit.")

            let text5 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.6", defaultText: "Your contact information (postal address, e-mail, and telephone), in order to enable individual enquiries for the exact clarification of the fever phases.")

            let text6 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.7", defaultText: "If your doctor has given you or you have informed him/her about your personal family code, the following applies: By using the app, you agree that your medical information may be transferred from your doctor to us and linked to your app entries.")

            let text7 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.HEADING.2", defaultText: "Anonymity:")

            let text8 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.9", defaultText: "Your family code, as well as the optionally provided mobile phone number and email, is personally identifiable, i.e. not anonymous. However, only the FeverApp team of Prof. Dr. med. David Martin has access to this personal data. However, if you lose your unique family code, you have the possibility to request the family code via this mobile phone number or email. Otherwise, we are not able to reassign the family code to you. We otherwise store your personally identifying data offline on external, locked and encrypted data carriers in order to prevent access by third parties. Your data may only be passed on to other parties, such as other research teams, in anonymous form and with the prior consent of Martin Rützler, the data protection officer of the University of Witten/Herdecke. Data will only be published in aggregated and anonymized form.")

            let text9 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.HEADING.3", defaultText: "Voluntarity:")

            let text10 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.10", defaultText: "The use of the FeverApp is voluntary at any time. If you do not answer certain questions or stop using FeverApp, you will not suffer any disadvantages.")
            let text11 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.HEADING.4", defaultText: "Storage duration")

            let text12 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.11", defaultText: "Your identifying data will be stored offline for a maximum of 20 years for research purposes on an external, locked and encrypted data carrier and protected from unauthorized access. The other data will be stored long-term.")
            
            let text13 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.HEADING.5", defaultText: "Your children's consent")

            let text14 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.12", defaultText: "If one of your children is older than 13 years old, you must ask your child's consent before using the app for that child. For children up to 14 years, you make this decision on behalf of your children.")

            let text15 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.HEADING.6", defaultText: "Possibility of revocation and deletion:")

            let text16 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.13", defaultText: "You have the option of revoking and deleting all data yourself. First delete all child profiles. Then go to User profile - Delete user profile and you can also irrevocably delete your installation data. This will erase all data stored on the server. You can also contact us at any time by email (info@feverapp.de) or by phone (02302 926 38080) to request the deletion of all or part of your identifying data. These are then deleted from the external data carriers within a maximum of one month.").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)

            let text17 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.HEADING.7", defaultText: "Collection of smartphone data")

            let text18 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.14", defaultText: "Apart from the information that you enter into the app yourself, as well as the times at which this information is entered, only the device manufacturer and the model (to identify possible errors) are recorded. For example, no motion information or similar is stored.")

            let text19 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.HEADING.8", defaultText: "Summary")

            let text20 = TranslationsViewModel.shared.getTranslation(key: "PRIVACY.TEXT.15", defaultText: "If you have any questions, you can contact the FeverApp support team at any time by email at info@feverapp.de or by phone at 02302 926 38080.").replacingOccurrences(of: "<.*?>", with: "", options: .regularExpression)


            let fullText = "\(text1)\n\n\(text2)\n\n\(text3)\n\n\(text4)\n\n\(text5)\n\n\(text6)\n\n\(text7)\n\n\(text8)\n\n\(text9)\n\n\(text10)\n\n\(text11)\n\n\(text12)\n\n\(text13)\n\n\(text14)\n\n\(text15)\n\n\(text16)\n\n\(text17)\n\n\(text18)\n\n\(text19)\n\n\(text20)"
                    
                    // Create a label with attributed text
            // Translation keys for bold text
            let boldKeys = [
                "PRIVACY.HEADING.1",
                "PRIVACY.TEXT.2",
                "PRIVACY.HEADING.2",
                "PRIVACY.HEADING.3",
                "PRIVACY.HEADING.4",
                "PRIVACY.HEADING.5",
                "PRIVACY.HEADING.6",
                "PRIVACY.HEADING.7",
                "PRIVACY.HEADING.8"
            ]

            // Fetch translations dynamically for bold text
            let boldTexts = boldKeys.map { TranslationsViewModel.shared.getTranslation(key: $0, defaultText: "") }

            // Create attributed label with dynamically bolded translations
            let label = createAttributedLabel(withText: fullText, boldText: boldTexts, blueUnderlinedText: [
                "info@feverapp.de", "02302 926 38080", "info@feverapp.de", "02302 926 38080"
            ])

                    label.translatesAutoresizingMaskIntoConstraints = false
                    contentView.addSubview(label)
                    
                    // Constraints for the label
                    NSLayoutConstraint.activate([
                        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
                    ])
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
         }

         @objc func backButtonTapped() {
             let viewController = self.storyboard?.instantiateViewController(withIdentifier: "rhfyjf")
             viewController?.modalPresentationStyle = .fullScreen
             self.present(viewController!, animated: true, completion: nil)
         }
                
                // Function to create an attributed label with bold and blue underlined text
                func createAttributedLabel(withText text: String, boldText: [String], blueUnderlinedText: [String]) -> UILabel {
                    let label = UILabel()
                    label.numberOfLines = 0
                    label.font = UIFont.systemFont(ofSize: 16)
                    
                    let attributedString = NSMutableAttributedString(string: text)
                    
                    // Apply bold style to the specified parts
                    for boldPart in boldText {
                        if let boldRange = text.range(of: boldPart) {
                            attributedString.addAttributes([
                                .font: UIFont.boldSystemFont(ofSize: 14)
                            ], range: NSRange(boldRange, in: text))
                        }
                    }
                    
                    // Apply blue and underlined style to the specified parts
                    for bluePart in blueUnderlinedText {
                        if let blueRange = text.range(of: bluePart) {
                            attributedString.addAttributes([
                                .foregroundColor: UIColor.blue,
                                .underlineStyle: NSUnderlineStyle.single.rawValue
                            ], range: NSRange(blueRange, in: text))
                        }
                    }
                    
                    // Apply the attributed string to the label
                    label.attributedText = attributedString
                    return label
                }
            }

