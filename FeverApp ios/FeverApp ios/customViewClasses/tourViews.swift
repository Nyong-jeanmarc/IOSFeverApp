//
//  tourViews.swift
//  FeverApp ios
//
//  Created by NEW on 11/02/2025.
//

import Foundation
import UIKit

class TourPopupViewController: UIViewController {
    var highlightFrames: [Int: CGRect] = [:] // Step number -> UI element frame mapping
    private let spotlightLayer = CAShapeLayer()
      private let lineLayer = CAShapeLayer()
    
    private let steps: [String] = [
        TranslationsViewModel.shared.getAdditionalTranslation(key: "USER.PROFILE.FUNCTIONS", defaultText: "Would you like to learn more about the most important functions of the app?"),
        TranslationsViewModel.shared.getTranslation(key: "TOUR.STEP-2.TEXT", defaultText: "As soon as you have the impression, that your child may be getting ill, you can click on this button to start the examination of your child and add new entries later at any time."),
        TranslationsViewModel.shared.getTranslation(key: "TOUR.STEP-3.TEXT", defaultText: "As soon as you have entered your first entry, you can see all your entries chronologically in the \"list view\". You can also retrieve information on how to deal with your child's fever at any time by clicking on me."),
        TranslationsViewModel.shared.getTranslation(key: "TOUR.STEP-3.TEXT", defaultText: "As soon as you have entered your first entry, you can see all your entries chronologically in the \"list view\". You can also retrieve information on how to deal with your child's fever at any time by clicking on me."),
        TranslationsViewModel.shared.getTranslation(key: "TOUR.STEP-6.TEXT", defaultText: ",Here you can set an alarm clock when you want to watch your child again to make another entry.,"),
        TranslationsViewModel.shared.getTranslation(key: "TOUR.STEP-8.TEXT", defaultText: "Here you can access additional information at any time, such as <strong>emergency information</strong>, <strong>data protection</strong>, <strong>disclaimer</strong>, <strong>information about the app</strong>, <strong>website</strong>, and <strong>service information</strong>. In addition, you can always start this <strong>tour</strong> again, give <strong>feedback to the app</strong> ,or if you want to make an entry at night, set the app to the darker <strong>night mode</strong>. In case of a <strong> fever cramp</strong> you can document it here.").replacingOccurrences(of: "</strong>", with: "").replacingOccurrences(of: "<strong>", with: ""),
        TranslationsViewModel.shared.getTranslation(key: "TOUR.STEP-9.TEXT", defaultText: "Here you will find more detailed information about fever in children at any time. <br>I hope they will help you deal with your child's fever.").replacingOccurrences(of: "<br>", with: "\n")
    ]
    
    private var currentStep: Int = 0
    
    private let popupView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        return view
    }()
    
    private let stepIndicatorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.SKIP", defaultText: "Skip"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.BACK", defaultText: "Back"), for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.isHidden = true // Initially hidden for step 1
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
        button.setTitleColor(UIColor(red: 168/255, green: 193/255, blue: 247/255, alpha: 1), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        setupPopupView()
        setupDismissGesture()
        updateStep()
    }
    
    private func setupPopupView() {
        view.addSubview(popupView)
        popupView.translatesAutoresizingMaskIntoConstraints = false
        let screenHeight = view.bounds.size.height
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.size.height
            
            var centerYConstant: CGFloat = 0
            
            // Check if screen size is equivalent to iPhone SE (2nd or 3rd generation)
            if safeAreaHeight <= 700 { // Adjust this value as needed
                centerYConstant = 50 // Move popup view 50 points below center
            }
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: centerYConstant),
            // Add leading and trailing space of 15 points
               popupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
               popupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
            
        ])
        
        let leftButtonStack = UIStackView(arrangedSubviews: [skipButton, backButton])
        leftButtonStack.axis = .horizontal
        leftButtonStack.spacing = 15
        leftButtonStack.distribution = .equalSpacing
        leftButtonStack.translatesAutoresizingMaskIntoConstraints = false

        let buttonStack = UIStackView(arrangedSubviews: [leftButtonStack, nextButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalCentering
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        popupView.addSubview(stepIndicatorLabel)
        popupView.addSubview(stepLabel)
        popupView.addSubview(buttonStack)
        
        stepIndicatorLabel.translatesAutoresizingMaskIntoConstraints = false
        stepLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stepIndicatorLabel.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 10),
            stepIndicatorLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            
            stepLabel.topAnchor.constraint(equalTo: stepIndicatorLabel.bottomAnchor, constant: 10),
            stepLabel.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            stepLabel.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
            
            buttonStack.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 20),
            buttonStack.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -20)
        ])
        
        skipButton.addTarget(self, action: #selector(skipTour), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(previousStep), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
    }
    
    private func setupDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func updateStep() {
    
        if currentStep > 0 {
            switch currentStep{
            case 1 : stepIndicatorLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "TOUR.STEP.1", defaultText: "Step 1 of 5").replacingOccurrences(of: "5", with: "6")
            case 2 : stepIndicatorLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "TOUR.STEP.2", defaultText: "Step 2 of 5").replacingOccurrences(of: "5", with: "6")
            case 3 :  stepIndicatorLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "TOUR.STEP.3", defaultText: "Step 3 of 5").replacingOccurrences(of: "5", with: "6")
            case 4 :  stepIndicatorLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "TOUR.STEP.4", defaultText: "Step 4 of 5").replacingOccurrences(of: "5", with: "6")
            case 5 :     let originalText = TranslationsViewModel.shared.getAdditionalTranslation(key: "TOUR.STEP.5", defaultText: "Step 5 of 5")
                if let range = originalText.range(of: "5", options: .backwards) {
                    let modifiedText = originalText.replacingCharacters(in: range, with: "6")
                    stepIndicatorLabel.text = modifiedText
                }
            case 6 :  stepIndicatorLabel.text = TranslationsViewModel.shared.getAdditionalTranslation(key: "TOUR.STEP.6", defaultText: "Step 6 of 5").replacingOccurrences(of: "5", with: "6")
            
            default:
                stepIndicatorLabel.text = ""
            }
            stepIndicatorLabel.text = "Step \(currentStep) of \(steps.count - 1)"
            view.backgroundColor = UIColor.black.withAlphaComponent(0.0) // ✅ Lighter background
        } else {
            stepIndicatorLabel.text = ""
            view.backgroundColor = UIColor.black.withAlphaComponent(0.4) // ✅ Lighter background
        }
        
        stepLabel.text = steps[currentStep]
        backButton.isHidden = currentStep == 0
        skipButton.isHidden = currentStep > 0
        
        if currentStep == steps.count - 1 {
            skipButton.isHidden = true
            backButton.isHidden = true
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
            skipButton.isHidden = false
        }
        highlightTargetElement()
    }
    
    private func highlightTargetElement() {
        spotlightLayer.removeFromSuperlayer()
        lineLayer.removeFromSuperlayer()
        
        guard let targetFrame = highlightFrames[currentStep] else { return }
        
        let path = UIBezierPath(rect: view.bounds)
        let highlightPath = UIBezierPath(roundedRect: targetFrame, cornerRadius: 8)
        path.append(highlightPath)
        path.usesEvenOddFillRule = true
        
        spotlightLayer.path = path.cgPath
        spotlightLayer.fillRule = .evenOdd
        spotlightLayer.fillColor = UIColor.black.withAlphaComponent(0.4).cgColor // ✅ Lighter effect
        view.layer.insertSublayer(spotlightLayer, at: 0)
        
   
        
        drawLine(to: targetFrame)
    }

    private func drawLine(to targetFrame: CGRect) {
        var isTargetUp: Bool?
        let popupCenter = CGPoint(x: popupView.center.x, y: popupView.center.y)
        let targetPoint: CGPoint

        // Calculate target point to just touch the target frame
        if popupCenter.y < targetFrame.minY {
            targetPoint = CGPoint(x: targetFrame.minX + targetFrame.width / 2, y: targetFrame.minY)
        } else if popupCenter.y > targetFrame.maxY {
            targetPoint = CGPoint(x: targetFrame.minX + targetFrame.width / 2, y: targetFrame.maxY)
        } else if popupCenter.x < targetFrame.minX {
            targetPoint = CGPoint(x: targetFrame.minX, y: targetFrame.minY + targetFrame.height / 2)
        } else {
            targetPoint = CGPoint(x: targetFrame.maxX, y: targetFrame.minY + targetFrame.height / 2)
        }

        let linePath = UIBezierPath()
        linePath.move(to: popupCenter)

        let cornerRadius: CGFloat = 20

        let midX = (popupCenter.x + targetPoint.x) / 2
        let midY = (popupCenter.y + targetPoint.y) / 2

        isTargetUp = popupCenter.y > targetPoint.y && popupCenter.x < targetPoint.x

        if abs(popupCenter.x - targetPoint.x) < 10 {
            linePath.addLine(to: CGPoint(x: popupCenter.x, y: targetPoint.y))
        } else if abs(popupCenter.y - targetPoint.y) < 10 {
            linePath.addLine(to: CGPoint(x: targetPoint.x, y: popupCenter.y))
        } else {
            let verticalPoint = CGPoint(x: popupCenter.x, y: midY + (isTargetUp! ? 20 : -20))
            linePath.addLine(to: verticalPoint)

            let firstBendX = popupCenter.x < targetPoint.x ? popupCenter.x + cornerRadius : popupCenter.x - cornerRadius
            let firstBend = CGPoint(x: firstBendX, y: midY)
            let firstControl = CGPoint(x: popupCenter.x, y: midY)

            linePath.addQuadCurve(to: firstBend, controlPoint: firstControl)

            let horizontalPointX = targetPoint.x < popupCenter.x ? targetPoint.x + cornerRadius : targetPoint.x - cornerRadius
            let horizontalPoint = CGPoint(x: horizontalPointX, y: midY)
            linePath.addLine(to: horizontalPoint)

            let secondBendY = midY < targetPoint.y ? midY + cornerRadius : midY - cornerRadius
            let secondBend = CGPoint(x: targetPoint.x, y: secondBendY)
            let secondControl = CGPoint(x: targetPoint.x, y: midY)
            linePath.addQuadCurve(to: secondBend, controlPoint: secondControl)

            linePath.addLine(to: targetPoint)
        }

        lineLayer.path = linePath.cgPath
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.lineWidth = 2.2
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineJoin = .round
        lineLayer.lineCap = .round

        view.layer.insertSublayer(lineLayer, at: 1)
    }

    @objc private func skipTour() {
        dismiss(animated: true)
    }
    
    @objc private func nextStep() {
        if currentStep < steps.count - 1 {
            currentStep += 1
            updateStep()
        }
    }
    
    @objc private func previousStep() {
        if currentStep > 0 {
            currentStep -= 1
            updateStep()
        }
    }
    
    @objc private func handleBackgroundTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !popupView.frame.contains(location) && currentStep == steps.count - 1 {
            dismiss(animated: true)
        }
    }
}
