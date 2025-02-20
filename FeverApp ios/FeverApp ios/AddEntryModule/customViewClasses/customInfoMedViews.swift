//
//  customInfoMedViews.swift
//  FeverApp ios
//
//  Created by NEW on 19/11/2024.
//

import Foundation
import UIKit
class customDatePickerView: UIView{
    let customBlueColor = UIColor(red: 165/255.0, green: 189/255.0, blue: 242/255.0, alpha: 1.0)
    let okButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)
    let datePicker: UIDatePicker = {
        // Fetch the user's selected language
           let appDelegate = UIApplication.shared.delegate as? AppDelegate
           let userLanguageCode = appDelegate?.fetchUserLanguage().languageCode ?? "en" // Default to English
        let picker = UIDatePicker()
        picker.locale = Locale(identifier: userLanguageCode) // Use the fetched language
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
     
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .white
        setupView()

    }
  
  
    private func setupView() {
                self.layer.cornerRadius = 20
                self.layer.masksToBounds = true
        // setup ok button
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.isEnabled = true
        okButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.OK", defaultText: "Ok"), for: .normal)
        okButton.setTitleColor(customBlueColor, for: .normal)
        okButton.isUserInteractionEnabled = true
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
       
     
        // setup cancel button
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.isEnabled = true
        cancelButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CANCEL", defaultText: "Cancel"), for: .normal)
        cancelButton.setTitleColor(customBlueColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        addSubview(okButton)
        addSubview(cancelButton)
        addSubview(datePicker)
        bringSubviewToFront(okButton)
        bringSubviewToFront(cancelButton)
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            okButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            okButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            okButton.widthAnchor.constraint(equalToConstant: 35),
            okButton.heightAnchor.constraint(equalToConstant: 35),
            cancelButton.trailingAnchor.constraint(equalTo: okButton.leadingAnchor, constant: -30),
            cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    var okButtonTap: (()->Void)?
    var cancelButtonTap: (()->Void)?
    @objc func okButtonTapped(){
        okButtonTap?()
    }
    @objc func cancelButtonTapped(){
        cancelButtonTap?()
    }
}
class ToggleButton: UIControl {
    private let amButton = UIButton(type: .system)
    private let pmButton = UIButton(type: .system)
    private let buttonStack = UIStackView()
    
    private let selectedColor = UIColor(red: 1.0, green: 0.85, blue: 0.85, alpha: 1.0) // Light pink
    private let defaultColor = UIColor.white
    
    private(set) var isAMSelected = true {
        didSet {
            updateSelection()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        updateSelection()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        updateSelection()
    }
    
    private func setupView() {
        // Configure buttons
        amButton.layer.masksToBounds = true
        pmButton.layer.masksToBounds = true
        amButton.setTitle("a.m.", for: .normal)
        pmButton.setTitle("p.m.", for: .normal)
        amButton.setTitleColor(.black, for: .normal)
        pmButton.setTitleColor(.black, for: .normal)
        amButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        pmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        amButton.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
        pmButton.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
        
        // Configure stack view
        buttonStack.axis = .vertical
        buttonStack.distribution = .fillEqually
        buttonStack.alignment = .fill
        buttonStack.layer.borderWidth = 1.0
        buttonStack.layer.borderColor = UIColor.lightGray.cgColor
        buttonStack.layer.cornerRadius = 10.0
        
        buttonStack.addArrangedSubview(amButton)
        buttonStack.addArrangedSubview(pmButton)
        
        addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: topAnchor),
            buttonStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func updateSelection() {
        amButton.backgroundColor = isAMSelected ? selectedColor : defaultColor
        pmButton.backgroundColor = isAMSelected ? defaultColor : selectedColor
    }
    var toggleTap : (( _ isAMSelected: Bool?)->Void)?
    @objc private func toggleSelection(_ sender: UIButton) {
     
        isAMSelected = (sender == amButton)
        sendActions(for: .valueChanged) // Notify about the value change
        toggleTap?(isAMSelected)
    }
}
class CustomTimePickerView: UIView {

    // MARK: - UI Components
    var topLabel = UILabel()
    private let hourLabel = UILabel()
    private let minuteLabel = UILabel()
    private let colonLabel = UILabel()
    private let amPmToggleButton = UIButton(type: .system)
    private let circularClock = UIView()
    private let cancelButton = UIButton(type: .system)
    private let okButton = UIButton(type: .system)
    let customPinkColor = UIColor(red: 230/255.0, green: 224/255.0, blue: 233/255.0, alpha: 1.0)
    let customBlueColor = UIColor(red: 165/255.0, green: 189/255.0, blue: 242/255.0, alpha: 1.0)

    // MARK: - Properties
    private var isHourSelected: Bool = true
  var selectedHour: Int = 12
    var selectedMinute: Int = 0
    private var isPM: Bool = false
    private var lineLayer: CAShapeLayer?
    var onTimeSelected: ((String) -> Void)?
    private let centerCircle = UIView()
    private var isFirstCall: Bool = true

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0.8, alpha: 1)
  
       
        updateHighlighting()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
 
       
        updateHighlighting()
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
        // Force layout update
          
     updateClockDisplay() // Ensure labels are correctly positioned after layout
       
  
    }
  
    // MARK: - Setup View
    private func setupView() {
        
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 16
// top label
        topLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "TIME.SELECTED.TEXT", defaultText: "Selected time")
        topLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        topLabel.textColor = .black
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLabel)
        // Hour Label
        hourLabel.text = "12"
        hourLabel.font = .systemFont(ofSize: 70, weight: .semibold)
        hourLabel.textAlignment = .center
        hourLabel.textColor = .label
        hourLabel.backgroundColor = UIColor.white
        hourLabel.layer.cornerRadius = 8
        hourLabel.layer.masksToBounds = true
        hourLabel.isUserInteractionEnabled = true
        hourLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHour)))
        // Set fixed width and height, and center it in the view
           NSLayoutConstraint.activate([
               hourLabel.widthAnchor.constraint(equalToConstant: 100), // Fixed width
               hourLabel.heightAnchor.constraint(equalToConstant: 100) // Fixed height
              
           ])
        // Colon Label
        colonLabel.text = ":"
        colonLabel.font = .systemFont(ofSize: 70, weight: .regular)
        colonLabel.textAlignment = .center
        colonLabel.textColor = .label

        // Minute Label
        minuteLabel.text = "00"
        minuteLabel.font = .systemFont(ofSize: 70, weight: .semibold)
        minuteLabel.textAlignment = .center
        minuteLabel.textColor = .black
        minuteLabel.backgroundColor = customPinkColor
        minuteLabel.layer.cornerRadius = 8
        minuteLabel.layer.masksToBounds = true
        minuteLabel.isUserInteractionEnabled = true
        minuteLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectMinute)))
//
        // Set fixed width and height, and center it in the view
           NSLayoutConstraint.activate([
               minuteLabel.widthAnchor.constraint(equalToConstant: 100), // Fixed width
               minuteLabel.heightAnchor.constraint(equalToConstant: 100) // Fixed height
           ])
        // AM/PM Toggle Button
        amPmToggleButton.setTitle("AM", for: .normal)
        amPmToggleButton.setTitleColor(.label, for: .normal)
        amPmToggleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        amPmToggleButton.addTarget(self, action: #selector(toggleAmPm), for: .touchUpInside)

        // Circular Clock
        circularClock.backgroundColor = customPinkColor
        circularClock.layer.cornerRadius = 100
        circularClock.translatesAutoresizingMaskIntoConstraints = false
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDragGesture(_:)))
        circularClock.addGestureRecognizer(panGesture)


        // Cancel and OK Buttons
        cancelButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.CANCEL", defaultText: "Cancel"), for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)

        okButton.setTitle(TranslationsViewModel.shared.getAdditionalTranslation(key: "CONTROLS.OK", defaultText: "Ok"), for: .normal)
        okButton.setTitleColor(.systemBlue, for: .normal)
        okButton.addTarget(self, action: #selector(okPressed), for: .touchUpInside)

        // Layout
        let timeStack = UIStackView(arrangedSubviews: [hourLabel, colonLabel, minuteLabel])
        timeStack.axis = .horizontal
        timeStack.alignment = .center
        timeStack.spacing = 8
        addSubview(timeStack)

        addSubview(amPmToggleButton)
        addSubview(circularClock)
        addSubview(cancelButton)
        addSubview(okButton)

        // Constraints
        timeStack.translatesAutoresizingMaskIntoConstraints = false
        amPmToggleButton.translatesAutoresizingMaskIntoConstraints = false
        amPmToggleButton.isHidden = true
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            topLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30),
            timeStack.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -30),
            timeStack.topAnchor.constraint(equalTo: topAnchor, constant: 65),

            amPmToggleButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            amPmToggleButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            circularClock.centerXAnchor.constraint(equalTo: centerXAnchor),
            circularClock.topAnchor.constraint(equalTo: timeStack.bottomAnchor, constant: 30),
            circularClock.widthAnchor.constraint(equalToConstant: 200),
            circularClock.heightAnchor.constraint(equalToConstant: 200),

            cancelButton.trailingAnchor.constraint(equalTo: okButton.leadingAnchor, constant: -35),
            cancelButton.topAnchor.constraint(equalTo: circularClock.bottomAnchor, constant: 16),

            okButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            okButton.topAnchor.constraint(equalTo: circularClock.bottomAnchor, constant: 16),
        ])
        let toggleButton = ToggleButton()
               toggleButton.translatesAutoresizingMaskIntoConstraints = false
            addSubview(toggleButton)
        toggleButton.toggleTap = { isAMSelected in
        
            self.toggleAmAndPm(isAMSelected:isAMSelected ?? false)
        }
               // Center the button in the view
               NSLayoutConstraint.activate([
                   toggleButton.topAnchor.constraint(equalTo: topAnchor, constant: 70),
                   toggleButton.leadingAnchor.constraint(equalTo: timeStack.trailingAnchor, constant: 20),
                   toggleButton.widthAnchor.constraint(equalToConstant: 52),
                   toggleButton.heightAnchor.constraint(equalToConstant: 75)
               ])
      
    }
    private func updateClockDisplay() {
        // Update hour and minute labels at the top
        hourLabel.text = String(format: "%02d", selectedHour)
        minuteLabel.text = String(format: "%02d", selectedMinute)
        
        // Clear previous clock display
        circularClock.subviews.forEach { $0.removeFromSuperview() }
        // Center Circle
           centerCircle.backgroundColor = customBlueColor
           centerCircle.layer.cornerRadius = 5 // Half of width/height for a perfect circle
           centerCircle.translatesAutoresizingMaskIntoConstraints = false
           circularClock.addSubview(centerCircle)

           // Constraints for centerCircle
           NSLayoutConstraint.activate([
               centerCircle.centerXAnchor.constraint(equalTo: circularClock.centerXAnchor),
               centerCircle.centerYAnchor.constraint(equalTo: circularClock.centerYAnchor),
               centerCircle.widthAnchor.constraint(equalToConstant: 10), // Diameter of the circle
               centerCircle.heightAnchor.constraint(equalToConstant: 10) // Diameter of the circle
           ])
        lineLayer?.removeFromSuperlayer()

        let count = isHourSelected ? 12 : 60
        let radius: CGFloat = 80

        for i in 0..<count {
            let label = UILabel()
            label.text = "\(i == 0 ? (isHourSelected ? 12 : 0) : i)"
            label.font = .systemFont(ofSize: 16, weight: .medium)
            label.textColor = UIColor.label
            label.textAlignment = .center
            label.frame.size = CGSize(width: 30, height: 30)
            label.layer.cornerRadius = 15
            label.layer.masksToBounds = true
            label.isUserInteractionEnabled = true
            label.tag = i

            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clockLabelTapped(_:))))

            let angle = CGFloat(i) * (2 * .pi / CGFloat(count)) - .pi / 2
            label.center = CGPoint(
                x: circularClock.bounds.midX + radius * cos(angle),
                y: circularClock.bounds.midY + radius * sin(angle)
            )

            if !isHourSelected && i % 5 != 0 {
                label.textColor = .clear
            }

            if (isHourSelected && i == selectedHour % 12) || (!isHourSelected && i == selectedMinute) {
                label.backgroundColor = customBlueColor
                label.textColor = .white
                drawLine(to: label.center)
            
            }

            circularClock.addSubview(label)
        }
      
    }

    @objc private func handleDragGesture(_ gesture: UIPanGestureRecognizer) {
        let touchPoint = gesture.location(in: circularClock)
        let centerPoint = CGPoint(x: circularClock.bounds.midX, y: circularClock.bounds.midY)

        // Calculate the angle of the touch relative to the center
        let dx = touchPoint.x - centerPoint.x
        let dy = touchPoint.y - centerPoint.y
        let angle = atan2(dy, dx)

        // Normalize the angle to a range between 0 and 2π
        let normalizedAngle = angle >= 0 ? angle : (2 * .pi + angle)

        // Determine the current time value based on the angle
        let count = isHourSelected ? 12 : 60
        let selectedValue = Int(round(normalizedAngle / (2 * .pi) * CGFloat(count))) % count

        switch gesture.state {
        case .began, .changed:
            if isHourSelected {
                selectedHour = selectedValue == 0 ? 12 : selectedValue
            } else {
                selectedMinute = selectedValue
            }
            updateClockDisplay() // Ensure labels and clock are updated
        default:
            break
        }
    }


    // MARK: - Actions
    @objc private func selectHour() {
        isHourSelected = true
        updateClockDisplay()
        updateHighlighting()
    }

    @objc private func selectMinute() {
        isHourSelected = false
        updateClockDisplay()
        updateHighlighting()
    }

    @objc private func toggleAmPm() {
        isPM.toggle()
        amPmToggleButton.setTitle(isPM ? "PM" : "AM", for: .normal)
    }
    func toggleAmAndPm(isAMSelected : Bool){
        if isAMSelected{
            isPM = false
        }else{
            isPM = true
        }
        amPmToggleButton.setTitle(isPM ? "PM" : "AM", for: .normal)
    }

    @objc private func okPressed() {
        let hour = isPM ? (selectedHour % 12) + 12 : selectedHour % 12
        let timeString = String(format: "%02d:%02d", hour, selectedMinute)
        onTimeSelected?(timeString)
        removeFromSuperview()
    }
    var cancelTap : (()->Void)?
    @objc private func cancelPressed() {
        cancelTap?()
        removeFromSuperview()
    }

    // MARK: - Update Methods

    @objc private func clockLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }

        if isHourSelected {
            selectedHour = label.tag == 0 ? 12 : label.tag
            hourLabel.text = "\(selectedHour)"
        } else {
            selectedMinute = label.tag
            minuteLabel.text = String(format: "%02d", selectedMinute)
        }

        updateClockDisplay()
    }

    private func drawLine(to point: CGPoint) {
        lineLayer?.removeFromSuperlayer()
        let path = UIBezierPath()
        
        // Start from the center of the tiny circle
        let center = CGPoint(x: centerCircle.center.x, y: centerCircle.center.y)
        path.move(to: center)
        path.addLine(to: point)

        let line = CAShapeLayer()
        line.path = path.cgPath
        line.strokeColor = lineLayer == nil ? UIColor.red.cgColor : customBlueColor.cgColor
        line.lineWidth = 2
        circularClock.layer.addSublayer(line)
        lineLayer = line
    }

    private func updateHighlighting() {
        if isHourSelected {
            hourLabel.backgroundColor = .white
            hourLabel.textColor = .black
            minuteLabel.backgroundColor = customPinkColor
            minuteLabel.textColor = .black
        } else {
            hourLabel.backgroundColor = customPinkColor
            hourLabel.textColor = .black
            minuteLabel.backgroundColor = .white
            minuteLabel.textColor = .black
        }
    }
}


