//
//  summaryVideoViewController.swift
//  FeverApp ios
//
//  Created by Glory Ngassa  on 06/09/2024.
//

import UIKit
import WebKit

class summaryVideoViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet var topView: UIView!
    
    @IBOutlet var oneMiddleView: UIView!
    
    @IBOutlet var twoMiddleView: UIView!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var videoTitle: UILabel!
    
    @IBAction func backBtnTapAction(_ sender: UIButton) {
        backButtonTapped()
    }
    
    // Back button action
    @objc private func backButtonTapped() {
        // Perform action for the back button, like dismissing the view controller
        // If you're not using a navigation controller, just dismiss
        self.dismiss(animated: true, completion: nil)
    }
    
    // Card 1
    let cardOne: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardOneTitle: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-VIDEOS.TEXT.1",defaultText: "Summary")
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let webViewOne: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    let activityIndicatorOne: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // Card 2
    let cardTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cardTwoTitle: UILabel = {
        let label = UILabel()
        label.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-VIDEOS.TEXT.2",defaultText: "Calf compress")
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let webViewTwo: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    let activityIndicatorTwo: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true

        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
        setupViews()
        setupWebViewOne()
        setupWebViewTwo()
        videoTitle.text = TranslationsViewModel.shared.getTranslation(key: "INFOS.INFO-SECTION-LIST.TEXT.2", defaultText: "Videos")
    }
    func setupViews() {
           scrollView.translatesAutoresizingMaskIntoConstraints = false
           view.addSubview(scrollView)

           scrollView.addSubview(contentView)
           contentView.translatesAutoresizingMaskIntoConstraints = false

           
           NSLayoutConstraint.activate([
               scrollView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 16),
               scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
               scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
               scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
               
               contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
               contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
               contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
               contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
               contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
           ])
           
           contentView.addSubview(cardOne)
           contentView.addSubview(cardTwo)
           
           NSLayoutConstraint.activate([
            cardOne.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            cardOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardOne.heightAnchor.constraint(equalToConstant: 300),

            cardTwo.topAnchor.constraint(equalTo: cardOne.bottomAnchor, constant: 16),
            cardTwo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardTwo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardTwo.heightAnchor.constraint(equalToConstant: 300),
            cardTwo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
           ])

           cardOne.addSubview(cardOneTitle)
           cardOne.addSubview(webViewOne)
           cardOne.addSubview(activityIndicatorOne)

           NSLayoutConstraint.activate([
               cardOneTitle.topAnchor.constraint(equalTo: cardOne.topAnchor, constant: 16),
               cardOneTitle.leadingAnchor.constraint(equalTo: cardOne.leadingAnchor, constant: 16),

               webViewOne.topAnchor.constraint(equalTo: cardOneTitle.bottomAnchor, constant: 16),
               webViewOne.leadingAnchor.constraint(equalTo: cardOne.leadingAnchor),
               webViewOne.trailingAnchor.constraint(equalTo: cardOne.trailingAnchor),
               webViewOne.bottomAnchor.constraint(equalTo: cardOne.bottomAnchor, constant: -16),

               activityIndicatorOne.centerXAnchor.constraint(equalTo: webViewOne.centerXAnchor),
               
               activityIndicatorOne.centerXAnchor.constraint(equalTo: webViewOne.centerXAnchor),
               activityIndicatorOne.centerYAnchor.constraint(equalTo: webViewOne.centerYAnchor)
           ])

           cardTwo.addSubview(cardTwoTitle)
           cardTwo.addSubview(webViewTwo)
           cardTwo.addSubview(activityIndicatorTwo)

           NSLayoutConstraint.activate([
               cardTwoTitle.topAnchor.constraint(equalTo: cardTwo.topAnchor, constant: 16),
               cardTwoTitle.leadingAnchor.constraint(equalTo: cardTwo.leadingAnchor, constant: 16),

               webViewTwo.topAnchor.constraint(equalTo: cardTwoTitle.bottomAnchor, constant: 16),
               webViewTwo.leadingAnchor.constraint(equalTo: cardTwo.leadingAnchor),
               webViewTwo.trailingAnchor.constraint(equalTo: cardTwo.trailingAnchor),
               webViewTwo.bottomAnchor.constraint(equalTo: cardTwo.bottomAnchor, constant: -16),

               activityIndicatorTwo.centerXAnchor.constraint(equalTo: webViewTwo.centerXAnchor),
               activityIndicatorTwo.centerYAnchor.constraint(equalTo: webViewTwo.centerYAnchor)
           ])
       }
    
    func setupWebViewOne() {
        webViewOne.navigationDelegate = self

        activityIndicatorOne.startAnimating()

        // Define the mapping of LanguageCode to IntroVideoLink
        let videoLinks: [String: String] = [
            "fr": "https://player.vimeo.com/video/656681669?h=fb0d1b7be8",
            "en": "https://player.vimeo.com/video/504369204?h=c95a727cfa",
            "de": "https://player.vimeo.com/video/498418242?h=d72cb30223",
            "ru": "https://player.vimeo.com/video/557186819?h=a76ce267aa",
            "tr": "https://player.vimeo.com/video/557158221?h=3afbebc44b",
            "ar": "https://player.vimeo.com/video/559987987?h=8819a38f1f",
            "fa": "https://player.vimeo.com/video/579459773?h=916b57d6ad",
            "nl": "https://player.vimeo.com/video/721916641?h=db4701a570",
            "pl": "https://player.vimeo.com/video/721916641?h=db4701a570",
            "it": "https://player.vimeo.com/video/717493913?h=b5f1af8f51",
            "es": "https://player.vimeo.com/video/885516274?h=c51cf77de3",
            "pt": "https://player.vimeo.com/video/504369204?h=c95a727cfa"
        ]

        // Fetch the current selected language from Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, _) = appDelegate.fetchUserLanguage()

        // Get the URL for the language code or default to English
        let videoURLString = videoLinks[languageCode!] ?? videoLinks["en"]!
        guard let videoURL = URL(string: videoURLString) else {
            fatalError("Invalid URL")
        }

        webViewOne.load(URLRequest(url: videoURL))
    }

    func setupWebViewTwo() {
        webViewTwo.navigationDelegate = self

        activityIndicatorTwo.startAnimating()

        // Define the mapping of LanguageCode to IntroVideoLink
        let videoLinks: [String: String] = [
            "fr": "https://player.vimeo.com/video/502087435?h=371123c23e",
            "en": "https://player.vimeo.com/video/502087435?h=371123c23e",
            "de": "https://player.vimeo.com/video/502087435?h=371123c23e",
            "ru": "https://player.vimeo.com/video/502087435?h=371123c23e",
            "tr": "https://player.vimeo.com/video/502087435?h=371123c23e",
            "ar": "https://player.vimeo.com/video/502087435?h=371123c23e",
            "fa": "https://player.vimeo.com/video/502087435?h=371123c23e",
            "nl": "https://player.vimeo.com/video/502087435?h=371123c23e",
            "pl": "https://player.vimeo.com/video/721916641?h=db4701a570",
            "it": "https://player.vimeo.com/video/502087435?h=371123c23e",
            "es": "https://player.vimeo.com/video/502087435?h=371123c23e",
            "pt": "https://player.vimeo.com/video/502087435?h=371123c23e"
        ]

        // Fetch the current selected language from Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, _) = appDelegate.fetchUserLanguage()

        // Get the URL for the language code or default to English
        let videoURLString = videoLinks[languageCode!] ?? videoLinks["en"]!
        guard let videoURL = URL(string: videoURLString) else {
            fatalError("Invalid URL")
        }

        webViewTwo.load(URLRequest(url: videoURL))
    }

    // WKNavigationDelegate method to detect when the webView has finished loading
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Stop and hide the activity indicator
        if webView == webViewOne {
            activityIndicatorOne.stopAnimating()
        } else {
            activityIndicatorTwo.stopAnimating()
        }
    }
}
   
