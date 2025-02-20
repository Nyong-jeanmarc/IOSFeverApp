//
//  secondMeasureViewController.swift
//  FeverApp ios
//
//  Created by user on 9/10/24.
//

//
//  secondMeasureViewController.swift
//  FeverApp ios
//
//  Created by NEW on 06/09/2024.
//


import UIKit
class secondMeasureViewController: UIViewController{
    
    
    @IBOutlet var topView: UIView!
    
    
    @IBOutlet var bottomView: UIView!
    
    
    @IBOutlet var myImage: UIImageView!
    
    @IBOutlet var skipButton: UIButton!
    
    // Déclaration des variables et constantes
    let okButton = UIButton()
    let timePickerModalView = UIView()
    let timePicker = UIDatePicker()
    
    
    // Créer une vue arrière-plan semi-transparente
    let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5) // Assombri la vue arrière
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let calendarView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    
    
    // Créer une vue modale
    let modalView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view}()
    
    
    // ScrollView container
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    
    
    
    
    
    
    // Configuration properties
    let buttonWidth: CGFloat = 95
    let buttonHeight: CGFloat = 70
    let imageSize: CGFloat = 30
    let textSize: CGFloat = 14
    let containerHeight: CGFloat = 100
    let topPadding: CGFloat = 10
    
    
    // end of ScrollView container
    
    
    
    class CustomRoundedView: UIView {
        var corners: UIRectCorner = []
        
        override func layoutSubviews() {
            super.layoutSubviews()
            applyCornerRadius()
        }
        
        private func applyCornerRadius() {
            let path = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: 10, height: 10))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
    
    var verticalStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSymptomsView()
        
        setupScrollView() //scrollView
        setupButtons() //scrollView
        setupBar() //scrollView
        
        // Configuration de la vue modale du calendrier
        let calendarModalView = UIView()
        calendarModalView.backgroundColor = .white
        calendarModalView.layer.cornerRadius = 12
        calendarModalView.translatesAutoresizingMaskIntoConstraints = false
        
        okButton.setTitle("OK", for: .normal)
        okButton.addTarget(self, action: #selector(showTimePickerModal), for: .touchUpInside)
        
        calendarModalView.addSubview(okButton)
        
        
        // Ajouter l'action du bouton skipButton pour afficher la modale
        let skipButton = UIButton(type: .system)
        skipButton.setTitle("Skip", for: .normal)
        skipButton.addTarget(self, action: #selector(showModal), for: .touchUpInside)
        
        
        
        
    }
    
    //BEGINING OF SCROLL VIEW CODE
    
    func setupScrollView() {
        // Add ScrollView to view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        
        // Set constraints for scrollView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: containerHeight)
        ])
        
        // Add stackView to scrollView
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        // Set constraints for stackView
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    
    
    
    
    func setupButtons() {
        let buttonsConfig = [
            ("State of health", "healt"),
            ("Teperature", "temp"),
            ("Pain", "Icon (7)"),
            ("Liquid", "liquid"),
            ("Diarrhea", "Diarrhea"),
            ("Rash", "Icon (14)"),
            ("Symptoms", "Sad"),
            ("Warning signs", "warning"),
            ("Feeling confi...", "Feeling confi"),
            ("Contact with...", "Contact"),
            ("Medication", "medica"),
            ("Measures", "sarahmeasure"),
            ("Note", "note")
        ]
        
        for (i, (text, imageName)) in buttonsConfig.enumerated() {
            let button = createButton(imageName: imageName, title: text)
            if i == 11 {
                button.layer.borderColor = UIColor.blue.cgColor
                button.layer.borderWidth = 1
            } else {
                button.layer.borderColor = UIColor.white.cgColor
                button.layer.borderWidth = 0
            }
            stackView.addArrangedSubview(button)
        }
    }
    
    func setupBar() {
        let bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .lightGray
        view.addSubview(bar)
        
        NSLayoutConstraint.activate([
            bar.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            bar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            bar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            bar.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func createButton(imageName: String, title: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.backgroundColor = .white
        
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 2
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        // Image configuration
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: imageSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageSize).isActive = true
        
        // Label configuration
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: textSize)
        label.textAlignment = .center
        label.numberOfLines = 1
        
        // Stack view to combine image and text
        let verticalStackView = UIStackView(arrangedSubviews: [imageView, label])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.spacing = 5
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(verticalStackView)
        
        // Center stackView inside button
        
        NSLayoutConstraint.activate([
            verticalStackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            verticalStackView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        
        return button
    }
    
    //END OF SCROLL VIEW CODE
    
    
    func setupUI() {
        let skipButtonTitle = NSMutableAttributedString(string: "No answer Skip")
        skipButton.addTarget(self, action: #selector(skipButtonTouchedDown), for: .touchDown)
        skipButton.addTarget(self, action: #selector(skipButtonTouchedUp), for: [.touchUpInside, .touchUpOutside])
        skipButtonTitle.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 10))
        skipButtonTitle.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 10, length: 4))
        skipButton.setAttributedTitle(skipButtonTitle, for: .normal)
        
        skipButton.layer.borderWidth = 0.5
        skipButton.layer.borderColor = UIColor.lightGray.cgColor
        skipButton.layer.cornerRadius = 8
        skipButton.layer.masksToBounds = true
        
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
        
        
    }
    
    func setupSymptomsView() {
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 15
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top corners
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 310)
        ])
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        containerView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        let scrollableStackView = UIStackView()
        scrollableStackView.axis = .vertical
        scrollableStackView.spacing = 8
        scrollView.addSubview(scrollableStackView)
        
        scrollableStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollableStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollableStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollableStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollableStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollableStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let topContainerView = CustomRoundedView()
        topContainerView.corners = [.topLeft, .topRight, .bottomRight]
        topContainerView.backgroundColor = .white
        topContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topContainerView)
        
        let topLabel = UILabel()
        topLabel.numberOfLines = 0
        topLabel.text = "Which measure(s) have you taken?"
        topLabel.font = .systemFont(ofSize: 13)
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topContainerView.addSubview(topLabel)
        myImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topContainerView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -13),
            topContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            topContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            topContainerView.heightAnchor.constraint(equalToConstant: 40),
            
            topLabel.topAnchor.constraint(equalTo: topContainerView.topAnchor, constant: 10),
            topLabel.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: 10),
            topLabel.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor, constant: -10),
            topLabel.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: -10),
            
            myImage.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),
            myImage.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor, constant: -37),
            myImage.widthAnchor.constraint(equalToConstant: 30),
            myImage.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let symptoms = ["Calm them, caress", "Reading, story telling, singing", "low-stimulus environment", "Tea with honey (e.g.elder, lime-tree, camomille)", "soup or light food", "Hot-water bottle, Cherry stone cushions", "Leg compresses", "Cloths on the forehead", "Enema", "Lemon water rubs", "Other measures"]
        
        for (index, symptom) in symptoms.enumerated() {
            let symptomView = createCheckboxWithLabel(text: symptom, tag: index)
            scrollableStackView.addArrangedSubview(symptomView)
            
            let divider = UIView()
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            scrollableStackView.addArrangedSubview(divider)
        }
        
        self.verticalStackView = scrollableStackView
    }
    
    func createCheckboxWithLabel(text: String, tag: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        let checkbox = UIButton(type: .custom)
        checkbox.tag = tag
        checkbox.setImage(UIImage(systemName: "square")?.withTintColor(.gray, renderingMode: .alwaysOriginal), for: .normal)
        checkbox.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1), renderingMode: .alwaysOriginal), for: .selected)
        checkbox.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.widthAnchor.constraint(equalToConstant: 24).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        label.addGestureRecognizer(tapGestureRecognizer)
        label.isUserInteractionEnabled = true
        
        stackView.addArrangedSubview(checkbox)
        stackView.addArrangedSubview(label)
        
        return stackView
    }
    
    @objc func labelTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let label = gestureRecognizer.view as? UILabel else { return }
        guard let stackView = label.superview as? UIStackView else { return }
        guard let checkbox = stackView.arrangedSubviews.first as? UIButton else { return }
        toggleCheckbox(checkbox)
    }
    
    
    
    
    @objc func toggleCheckbox(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        
        
    }
    
    
    
    @objc func showModal() {
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Selectionner une date"
            label.font = .boldSystemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let subtitleLabel: UILabel = {
            let label = UILabel()
            label.text = "Date selectionee"
            label.font = .systemFont(ofSize: 14)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let iconImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "icon") // Remplacez par le nom de votre image
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        
        modalView.addSubview(titleLabel)
        modalView.addSubview(subtitleLabel)
        modalView.addSubview(iconImageView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: modalView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: subtitleLabel.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -16)
        ])
        
        let calendarView: UIDatePicker = {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .inline
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            return datePicker
        }()
        
        modalView.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 16),
            calendarView.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 16),
            calendarView.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -16),
            calendarView.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        
        
        let cancelButton: UIButton = {
            let button = UIButton()
            button.setTitle("Annuler", for: .normal)
            button.setTitleColor(.red, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
            return button
        }()
        
        let okButton: UIButton = {
            let button = UIButton()
            button.setTitle("OK", for: .normal)
            button.setTitleColor(.green, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(showTimePickerModal), for: .touchUpInside) // Ajoutez cette ligne
            return button
        }()
        
        modalView.addSubview(cancelButton)
        modalView.addSubview(okButton)
        view.addSubview(modalView)
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 16),
            cancelButton.leadingAnchor.constraint(equalTo: modalView.leadingAnchor, constant: 16),
            okButton.topAnchor.constraint(equalTo: calendarView.bottomAnchor, constant: 16),
            okButton.trailingAnchor.constraint(equalTo: modalView.trailingAnchor, constant: -16)
        ])
        
        // Ajouter la vue assombrie à l'arrière-plan
        view.addSubview(dimmingView)
        NSLayoutConstraint.activate([
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Ajouter la vue modale au centre de l'écran
        view.addSubview(modalView)
        NSLayoutConstraint.activate([
            modalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modalView.widthAnchor.constraint(equalToConstant: 350),
            modalView.heightAnchor.constraint(equalToConstant: 500)
        ])
        
        // Animer l'apparition de la modale
        modalView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        modalView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            self.modalView.alpha = 1
            self.modalView.transform = CGAffineTransform.identity
        }
    }
    
    
    
    
    
    func setupTimePickerModal() {
        
    }
    
    @objc func cancelTimePicker() {
        // Supprimer la vue du sélecteur d'heure
        timePickerModalView.removeFromSuperview()
        modalView.alpha = 1
        if let timePickerView = modalView.subviews.last {
            timePickerView.removeFromSuperview()
        }
    }
    
    @objc func confirmTimePicker() {
        // Récupérer l'heure sélectionnée et faire quelque chose avec
        if let timePickerView = modalView.subviews.last {
            timePickerView.removeFromSuperview()
        }
    }
    
    // Fonction pour cacher la modale
    @objc func hideModal() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.modalView.alpha = 0
            self.modalView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { _ in
            self.modalView.removeFromSuperview()
            self.dimmingView.removeFromSuperview()
        }
    }
    
    
    @objc func confirmAction() {
        setupTimePickerModal()
        
    }
    
    
    
    @objc func showTimePickerModal() {
        // Créez la vue modale qui contiendra l'horloge
        timePickerModalView.backgroundColor = .white
        timePickerModalView.layer.cornerRadius = 12
        timePickerModalView.translatesAutoresizingMaskIntoConstraints = false
        
        // Ajoutez un sous-titre
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Sélectionnez l'heure"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        timePickerModalView.addSubview(subtitleLabel)
        
        // Créer un UIDatePicker configuré en mode time
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        timePickerModalView.addSubview(timePicker)
        
        // Ajouter les boutons Cancel et OK
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTimePicker), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmTimePicker), for: .touchUpInside)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        timePickerModalView.addSubview(cancelButton)
        timePickerModalView.addSubview(confirmButton)
        
        // Ajouter les contraintes pour le UIDatePicker et les boutons
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: timePickerModalView.topAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: timePickerModalView.leadingAnchor, constant: 20),
            
            timePicker.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            timePicker.widthAnchor.constraint(equalTo: timePickerModalView.widthAnchor, multiplier: 0.9),
            timePicker.heightAnchor.constraint(equalToConstant: 200),
            timePicker.centerXAnchor.constraint(equalTo: timePickerModalView.centerXAnchor),
            
            cancelButton.leadingAnchor.constraint(equalTo: timePickerModalView.leadingAnchor, constant: 20),
            cancelButton.bottomAnchor.constraint(equalTo: timePickerModalView.bottomAnchor, constant: -20),
            
            confirmButton.trailingAnchor.constraint(equalTo: timePickerModalView.trailingAnchor, constant: -20),
            confirmButton.bottomAnchor.constraint(equalTo: timePickerModalView.bottomAnchor, constant: -20)
        ])
        
        // Présentez la vue modale avec une animation
        view.addSubview(timePickerModalView)
        NSLayoutConstraint.activate([
            timePickerModalView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePickerModalView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timePickerModalView.widthAnchor.constraint(equalToConstant: 350),
            timePickerModalView.heightAnchor.constraint(equalToConstant: 490)
        ])
        
        UIView.animate(withDuration: 0.3) {
            self.timePickerModalView.alpha = 1
        }
    }
    
    
    @objc func dismissModal() {
        UIView.animate(withDuration: 0.3) {
            self.modalView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.modalView.alpha = 0
        } completion: { _ in
            self.modalView.removeFromSuperview()
            self.dimmingView.removeFromSuperview()
        }
    }
    
   
    
    
    @objc func skipButtonTouchedDown() {
        skipButton.backgroundColor = .lightGray
    }
    
    @objc func skipButtonTouchedUp() {
        skipButton.backgroundColor = UIColor(hexString: "#a1c2fc")
        
        // Vérifiez si au moins une case à cocher est sélectionnée
            let anySelected = verticalStackView.arrangedSubviews.compactMap { $0 as? UIStackView }.contains { stackView in
                (stackView.arrangedSubviews.first as? UIButton)?.isSelected ?? false
            }
            
            if anySelected {
                // Affichez la vue modale du calendrier
                showModal()
        
           }
        
     
    }
}

