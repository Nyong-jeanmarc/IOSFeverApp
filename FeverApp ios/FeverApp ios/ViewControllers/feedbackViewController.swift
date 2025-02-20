//
//  feedbackViewController.swift
//  FeverApp ios
//
//  Created by NEW on 05/01/2025.
//

import Foundation
import UIKit
class FeedbackQuestionaireViewController: UIViewController {
    var moveToMenu : (()->Void)?
    @IBAction func doneButtonTap(_ sender: Any) {
        self.dismiss(animated: true)
        moveToMenu?()
        
    }
    @IBOutlet var giveFeedbackTitle: UILabel!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var topView: UIView!
    
// MARK: - Properties
    private let feedbackStarRatingView1 = feedbackStarView(
        frame: .zero,
        initialRating: 0,
        feedbackMessage: TranslationsViewModel.shared.getTranslation(key: "EVALUATION.RATING_APP.QUESTION", defaultText: "How do you like the FeverApp in general so far?"), viewIdentity: "GeneralSatisfaction"
    )
    private let feedbackStarRatingView2 = feedbackStarView(
        frame: .zero,
        initialRating: 0,
        feedbackMessage: TranslationsViewModel.shared.getTranslation(key: "EVALUATION.RATING_DESIGN.QUESTION", defaultText: "How do you like the design of the FeverApp?"), viewIdentity: "DesignSatisfaction"
    )
    private let feedbackStarRatingView3 = feedbackStarView(
        frame: .zero,
        initialRating: 0,
        feedbackMessage: TranslationsViewModel.shared.getTranslation(key: "EVALUATION.RATING_USABILITY.QUESTION", defaultText: "How do you like the usability of the FeverApp?"), viewIdentity: "UsabilitySatisfaction"
    )
    private let impressionFeedbackView = ImpressionFeedbackView(message: TranslationsViewModel.shared.getTranslation(key: "EVALUATION.CONFIDENCE.QUESTION", defaultText: "Do you have the impression that the app has increased your confidence in dealing with childhood fever?"))
    private let feedbackTextFieldView1 = textFieldFeedbackView(message: TranslationsViewModel.shared.getTranslation(key: "EVALUATION.POSITIVE.QUESTION", defaultText: "What did you like about the FeverApp?"))
    private let feedbackTextFieldView2 = lastTextFieldFeedbackView(message: TranslationsViewModel.shared.getTranslation(key: "EVALUATION.IMPROVE.QUESTION", defaultText: "From your point of view, what could be (even) better about the FeverApp?"))
    
    private var currentViewIndex: Int = 0
    private var feedbackViews: [UIView] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFeedbackViews()
        hideAllViews()
        showView(at: currentViewIndex)
        setupCallbacks()
    }
    
    // MARK: - Setup Functions
    private func setupFeedbackViews() {
        topView.layer.cornerRadius = 25
        giveFeedbackTitle.text = TranslationsViewModel.shared.getTranslation(key: "MENU.ITEM.FEEDBACK", defaultText: "Give feedback")
        doneButton.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.DONE", defaultText: "Done"), for: .normal)
        
        feedbackViews = [
            feedbackStarRatingView1,
            feedbackStarRatingView2,
            feedbackStarRatingView3,
            impressionFeedbackView,
            feedbackTextFieldView1,
            feedbackTextFieldView2
        ]
        
        feedbackViews.forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topView.bottomAnchor),
                view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
    }
    
    private func hideAllViews() {
        feedbackViews.forEach { $0.isHidden = true }
    }
    
    private func showView(at index: Int) {
        guard index >= 0, index < feedbackViews.count else { return }
        hideAllViews()
        feedbackViews[index].isHidden = false
    }
    
    private func setupCallbacks() {
        feedbackStarRatingView1.confirmTap = { [weak self] in self?.handleConfirmTap() }
        feedbackStarRatingView1.noAnswerTap = { [weak self] in self?.handleNoAnswerTap() }
        
        feedbackStarRatingView2.confirmTap = { [weak self] in self?.handleConfirmTap() }
        feedbackStarRatingView2.noAnswerTap = { [weak self] in self?.handleNoAnswerTap() }
        
        feedbackStarRatingView3.confirmTap = { [weak self] in self?.handleConfirmTap() }
        feedbackStarRatingView3.noAnswerTap = { [weak self] in self?.handleNoAnswerTap() }
        
        impressionFeedbackView.confirmTap = { [weak self] in self?.handleConfirmTap() }
        impressionFeedbackView.noAnswerTap = { [weak self] in self?.handleNoAnswerTap() }
        
        feedbackTextFieldView1.confirmTap = { [weak self] in self?.handleConfirmTap() }
        feedbackTextFieldView1.noAnswerTap = { [weak self] in self?.handleNoAnswerTap() }
        
        feedbackTextFieldView2.confirmTap = { [weak self] in self?.handleLastConfirmTap() }
        feedbackTextFieldView2.noAnswerTap = { [weak self] in self?.handleLastNoAnswerTap() }
    }
    
    // MARK: - Action Handlers
    @IBAction func backButtonTapped(_ sender: Any) {
        if currentViewIndex > 0 {
            currentViewIndex -= 1
            showView(at: currentViewIndex)
        }
    }
    
    private func handleConfirmTap() {
        if currentViewIndex < feedbackViews.count - 1 {
            currentViewIndex += 1
            showView(at: currentViewIndex)
        }
    }
    @objc func goToFirstTab() {
        var window: UIWindow?
        var scene: UIScene?
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Navigate to Overview Screen
        let overviewVC = storyboard.instantiateViewController(identifier: "overview")
        window?.rootViewController = overviewVC
    }
    private func handleLastConfirmTap() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        
            return
        }
        let userId = appDelegate.fetchUserData().0
        feedBackQuestionaireModel.shared.updateFeedBackModel(userId: userId)
        self.dismiss(animated: true)
        moveToMenu?()
    }
    private func handleLastNoAnswerTap() {
        self.dismiss(animated: true)
        moveToMenu?()
    }
    private func handleNoAnswerTap() {
        if currentViewIndex < feedbackViews.count - 1 {
            currentViewIndex += 1
            showView(at: currentViewIndex)
        }
    }
}
