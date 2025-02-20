//
//  PlayVideoViewController.swift
//  FeverApp ios
//
//  Created by NEW on 03/08/2024.
//

import UIKit
import WebKit
class PlayVideoViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler{
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
  
    var playTime: TimeInterval = 0
    var playStartTime: Date!
       var pauseDuration: TimeInterval = 0
       var pauseStartTime: Date!
       var rewindSections: Int = 0
       var fastForwardSections: Int = 0
       var completionStatus: Bool = false
       var videoDuration: TimeInterval = 0
       var videoStarted: Bool = false
       var videoPaused: Bool = false
       var startTime: Date!
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    @IBOutlet var hideView: UIView!
    
  
    @IBOutlet var videoView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var bottomView: UIView!
    @IBOutlet var button: UIButton!
    
    @IBOutlet var VideoContainer: UIView!
    
    @IBAction func nextBtn(_ sender: Any) {
    }
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var videoDescriptionLabel: UILabel!
    
    var webView = WKWebView()
    
    func setVideoDescriptionText() -> NSAttributedString {
        // Get the full translation text
        let fullText = TranslationsViewModel.shared.getTranslation(key: "VIDEO.INTRO", defaultText: "The main things about fever in 4 minutes:<br>The FeverApp Video<br>")
        
        // Create a paragraph style for justification
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center // Set alignment to center

        // Split the text by "FeverApp"
        let splitText = fullText.components(separatedBy: ("<br>"))

        // Create the attributed string
        let attributedText = NSMutableAttributedString(string: splitText[0], attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .regular),
        ])

//        // Add "FeverApp" with bold style
//        let boldText = NSAttributedString(string: "\n\(splitText)", attributes: [
//            .font: UIFont.boldSystemFont(ofSize: 14),
//        ])
//        attributedText.append(boldText)

        // Append the remaining text if available
        if splitText.count > 1 {
            let remainingText = NSAttributedString(string: ("\n\(splitText[1])"), attributes: [
                .font: UIFont.systemFont(ofSize: 14, weight: .bold),
            ])
            attributedText.append(remainingText)
        }

        // Assign the attributed text to the UILabel
     return attributedText
    }
    
    override func viewDidLoad() {
        // Fetch the current selected language from Core Data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let (languageCode, _) = appDelegate.fetchUserLanguage()
        
        videoDescriptionLabel.numberOfLines = 0 // Allow multiple lines
        videoDescriptionLabel.lineBreakMode = .byWordWrapping
        videoDescriptionLabel.attributedText = setVideoDescriptionText()
        nextBtn.setTitle(TranslationsViewModel.shared.getTranslation(key: "CONTROLS.NEXT", defaultText: "Next"), for: .normal)
        bottomView.layer.shadowColor = UIColor.lightGray.cgColor
        bottomView.layer.shadowOpacity = 0.3
        bottomView.layer.shadowRadius = 5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
//        videoView.layer.shadowColor = UIColor.lightGray.cgColor
//        videoView.layer.shadowOpacity = 0.3
//        videoView.layer.shadowRadius = 5
//        videoView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        topView.layer.shadowColor = UIColor.lightGray.cgColor
        topView.layer.shadowOpacity = 0.3
        topView.layer.shadowRadius = 5
        topView.layer.shadowOffset = CGSize(width: 0, height: 2)
        // Bring a specific view to the front
        view.bringSubviewToFront(hideView)
        VideoContainer.layer.cornerRadius = 16
        let chevronImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysOriginal)
            let scaledImage = resizeImage(image: chevronImage!, to: CGSize(width: 18, height: 18))
        let backButton = UIBarButtonItem(image: scaledImage, style: .plain, target: self, action: #selector(handleBackButtonTap))
        backButton.tintColor = .gray
        // Create a custom UILabel for the title
            let navtitleLabel = UILabel()
        navtitleLabel.text = TranslationsViewModel.shared.getTranslation(key: "VIDEO.TITLE",defaultText: "Video")
            navtitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold) // Customize the font as needed
            navtitleLabel.sizeToFit() // Adjust the size to fit the content

            // Create a left bar button item as a container for the titleLabel
            let leftTitleItem = UIBarButtonItem(customView: navtitleLabel)
        navigationItem.leftBarButtonItems = [backButton, leftTitleItem].compactMap { $0 }
           navigationItem.leftBarButtonItem = backButton
           navigationItem.hidesBackButton = false
     webView = WKWebView(frame: videoView.bounds)
        webView.translatesAutoresizingMaskIntoConstraints = false
     
        videoView.addSubview(webView)
        webView.navigationDelegate = self
        videoView.addSubview(activityIndicator)
       
     
        activityIndicator.hidesWhenStopped = true
       
        activityIndicator.startAnimating()
        
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
               // Load URL
//               let url = URL(string: "https://player.vimeo.com/video/504369204?h=c95a727cfa")!
        
        // Get the URL for the language code or default to English
        
        // Safely unwrap the optional languageCode
        let languageCode1 = languageCode ?? "en"
        
        print("\n\n\n\n\n\nLanguage code selected is \(languageCode1)\n\n\n\n\n\n\n\n")
        
        let urlString = videoLinks[languageCode1] ?? videoLinks["en"]!

        // Safely unwrap and return the URL
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
      let request = URLRequest(url: url)
        webView.load(request)
        super.viewDidLoad()
        videoView.layoutIfNeeded()
        webView.scrollView.contentInsetAdjustmentBehavior = .always
        button.layer.cornerRadius = 10
        topView.layer.borderColor = UIColor.white.cgColor
        topView.layer.borderWidth = 1.0 // Border width in points
                topView.layer.cornerRadius = 15.0
        bottomView.layer.borderColor = UIColor.white.cgColor
        bottomView.layer.borderWidth = 1.0 // Border width in points
                bottomView.layer.cornerRadius = 15.0
        
    }
    @objc func handleBackButtonTap() {
        navigationController?.popViewController(animated: true)
    }
    func resizeImage(image: UIImage, to newSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
    // WKNavigationDelegate method to detect when the webView has finished loading
     func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         // Stop and hide the activity indicator
         activityIndicator.stopAnimating()
     }
    func u(m: String) {
        print("pause duration : \(pauseDuration)")
        print("rewindSections : \(rewindSections)")
        print("fastForwardSections : \(fastForwardSections)")
        print("playtime : \(playTime)")
        switch m{
                case "playHandler":
            if !videoPaused{
                videoStarted = true
                startTime = Date()
                playStartTime = startTime
            }else{
             playStartTime = Date()
                videoPaused = false
                pauseDuration += Date().timeIntervalSince(pauseStartTime)
            }
                case "pauseHandler":
            pauseStartTime = Date()
            playTime += Date().timeIntervalSince(playStartTime)
                    videoPaused = true
                case "seekHandler":
            if let seekDirection = m as? String {
                        switch seekDirection {
                        case "rewind":
                            rewindSections += 1
                        case "forward":
                            fastForwardSections += 1
                        default:
                            break
                        }
                    }
                case "endHandler":
            
                    completionStatus = true
                    playTime += Date().timeIntervalSince(playStartTime)
                default:
                    break
                }
       
       
    }
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           
           // Ensure the activity indicator is centered in the webView
           activityIndicator.center = CGPoint(x: webView.bounds.midX, y: webView.bounds.midY)
       }
    
    func handleNavigationToLoginPageCodeScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let LoginPageVC = storyboard.instantiateViewController(withIdentifier: "LoginPageViewController") as? LoginPageViewController {
            self.navigationController?.pushViewController(LoginPageVC, animated: true)
        }
        print("hello")
    }
    
    @IBAction func handleNextUIButtonClick(_ sender: UIButton) {
        handleNavigationToLoginPageCodeScreen()
        
    }
}
