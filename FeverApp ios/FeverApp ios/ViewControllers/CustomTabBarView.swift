////
////  CustomTabBarView.swift
////  FeverApp ios
////
////  Created by user on 11/25/24.
////
//
//import Foundation
////import UIKit
////
////class CustomTabBarView: UIView, UITabBarDelegate {
////
////    // Tab bar instance
////    private let tabBar: UITabBar = {
////        let tabBar = UITabBar()
////        tabBar.translatesAutoresizingMaskIntoConstraints = false
////        return tabBar
////    }()
////    
////    // Callback for item selection
////    var onTabSelected: ((Int) -> Void)?
////    
////    var tabItems: [UITabBarItem] = [] {
////        didSet {
////            tabBar.items = tabItems
////        }
////    }
////    
////    var selectedItemIndex: Int = 0 {
////        didSet {
////            tabBar.selectedItem = tabItems[selectedItemIndex]
////        }
////    }
////    
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        setupView()
////    }
////    
////    required init?(coder: NSCoder) {
////        super.init(coder: coder)
////        setupView()
////    }
////    
////    private func setupView() {
////        tabBar.delegate = self
////        
////        if let items = tabBar.items {
////            for item in items {
////                item.imageInsets = UIEdgeInsets(top: -16, left: 0, bottom: 16, right: 0) // Adjusts image position
////            }
////        }
////            // Customize the Tab Bar to make it transparent
////            tabBar.backgroundImage = UIImage() // Removes the background
////            tabBar.shadowImage = UIImage() // Removes the border
////            tabBar.isTranslucent = true // Makes it translucent
////            tabBar.backgroundColor = UIColor.clear // Ensures the background is clear
////
////        addSubview(tabBar)
////        
////        NSLayoutConstraint.activate([
////            tabBar.leadingAnchor.constraint(equalTo: leadingAnchor),
////            tabBar.trailingAnchor.constraint(equalTo: trailingAnchor),
////            tabBar.topAnchor.constraint(equalTo: topAnchor),
////            tabBar.bottomAnchor.constraint(equalTo: bottomAnchor)
////        ])
////        
////        // Default items (optional, can be overridden later)
////        let defaultItems = [
////            UITabBarItem(title: "Overview", image: UIImage(named: "home1"), tag: 0),
////            UITabBarItem(title: "Account", image: UIImage(named: "account_icon"), tag: 1),
////            UITabBarItem(title: "Info library", image: UIImage(named: "Icon (12)"), tag: 2),
////            UITabBarItem(title: "More", image: UIImage(named: "Icon-23"), tag: 3)
////        ]
////        tabItems = defaultItems
////    }
////    
////    func updateTranslations() {
////        tabBar.items?[0].title = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.DIARY.LABEL", defaultText: "Overview")
////        tabBar.items?[1].title = TranslationsViewModel.shared.getAdditionalTranslation(key: "APPBAR.ACCOUNT", defaultText: "Account")
////        tabBar.items?[2].title = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL", defaultText: "Info Library")
////        tabBar.items?[3].title = TranslationsViewModel.shared.getAdditionalTranslation(key: "APPBAR.MORE", defaultText: "More")
////    }
////
////    // UITabBarDelegate method
////    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
////        onTabSelected?(item.tag)
////    }
////}
//
//import UIKit
//
//class CustomTabBarView: UIView, UITabBarDelegate {
//    
//    // Tab bar instance
//    private let tabBar: UITabBar = {
//        let tabBar = UITabBar()
//        tabBar.translatesAutoresizingMaskIntoConstraints = false
//        return tabBar
//    }()
//    
//    // Parent view controller for navigation
//    weak var parentViewController: UIViewController?
//    
//    var tabItems: [UITabBarItem] = [] {
//        didSet {
//            tabBar.items = tabItems
//        }
//    }
//    
//    var selectedItemIndex: Int = 0 {
//        didSet {
//            tabBar.selectedItem = tabItems[selectedItemIndex]
//        }
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//    
//    private func setupView() {
//        tabBar.delegate = self
//        
//        // Customize the Tab Bar to make it transparent
//        tabBar.backgroundImage = UIImage() // Removes the background
//        tabBar.shadowImage = UIImage() // Removes the border
//        tabBar.isTranslucent = true // Makes it translucent
//        tabBar.backgroundColor = UIColor.clear // Ensures the background is clear
//        
//        addSubview(tabBar)
//        
//        NSLayoutConstraint.activate([
//            tabBar.leadingAnchor.constraint(equalTo: leadingAnchor),
//            tabBar.trailingAnchor.constraint(equalTo: trailingAnchor),
//            tabBar.topAnchor.constraint(equalTo: topAnchor),
//            tabBar.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//        
//        // Default items (optional, can be overridden later)
//        let defaultItems = [
//            UITabBarItem(title: "Overview", image: UIImage(named: "home1"), tag: 0),
//            UITabBarItem(title: "Account", image: UIImage(named: "account_icon"), tag: 1),
//            UITabBarItem(title: "Info library", image: UIImage(named: "Icon (12)"), tag: 2),
//            UITabBarItem(title: "More", image: UIImage(named: "Icon-23"), tag: 3)
//        ]
//        tabItems = defaultItems
//    }
//    
//    func updateTranslations() {
//        tabBar.items?[0].title = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.DIARY.LABEL", defaultText: "Overview")
//        tabBar.items?[1].title = TranslationsViewModel.shared.getAdditionalTranslation(key: "APPBAR.ACCOUNT", defaultText: "Account")
//        tabBar.items?[2].title = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL", defaultText: "Info Library")
//        tabBar.items?[3].title = TranslationsViewModel.shared.getAdditionalTranslation(key: "APPBAR.MORE", defaultText: "More")
//    }
//    
//    // UITabBarDelegate method
//    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        guard let parent = parentViewController else { return }
//        
//        switch item.tag {
//        case 0:
//            print("Overview Selected")
//            navigateToViewController(from: parent, withIdentifier: "overview")
//        case 1:
//            print("Account Selected")
//            navigateToViewController(from: parent, withIdentifier: "UserProfile")
//        case 2:
//            print("Info Library Selected")
//            navigateToViewController(from: parent, withIdentifier: "infoLibController")
//        case 3:
//            print("More Selected")
//            navigateToViewController(from: parent, withIdentifier: "rhfyjf")
//        default:
//            break
//        }
//    }
//    
//    private func navigateToViewController(from parent: UIViewController, withIdentifier identifier: String) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? UIViewController else {
//            print("Error: ViewController with identifier \(identifier) not found.")
//            return
//        }
//        
//        // Push to the navigation stack or present modally
//        if let navigationController = parent.navigationController {
//            navigationController.pushViewController(viewController, animated: false)
//        } else {
//            viewController.modalPresentationStyle = .fullScreen
//            parent.present(viewController, animated: false, completion: nil)
//        }
//    }
//}

import UIKit

class CustomTabBarView: UIView, UITabBarDelegate {

    // Tab bar instance
    private let tabBar: UITabBar = {
        let tabBar = UITabBar()
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        return tabBar
    }()

    // Parent view controller for navigation
    weak var parentViewController: UIViewController?

    var tabItems: [UITabBarItem] = [] {
        didSet {
            tabBar.items = tabItems
//            updateTabBarItemColors()
        }
    }

    var selectedItemIndex: Int = 0 {
        didSet {
            tabBar.selectedItem = tabItems[selectedItemIndex]
//            updateTabBarItemColors()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        tabBar.delegate = self
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        // Customize the Tab Bar to make it transparent
        tabBar.backgroundImage = UIImage() // Removes the background
        tabBar.shadowImage = UIImage() // Removes the border
        tabBar.isTranslucent = true // Makes it translucent
        tabBar.backgroundColor = UIColor.clear // Ensures the background is clear

        addSubview(tabBar)

        NSLayoutConstraint.activate([
            tabBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBar.topAnchor.constraint(equalTo: topAnchor),
            tabBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        // Default items (optional, can be overridden later)
        let defaultItems = [
            UITabBarItem(title: "Overview", image: UIImage(named: "home1"), tag: 0),
            UITabBarItem(title: "Account", image: UIImage(named: "account_icon"), tag: 1),
            UITabBarItem(title: "Info library", image: UIImage(named: "Icon (12)"), tag: 2),
            UITabBarItem(title: "More", image: UIImage(named: "Icon-23"), tag: 3)
        ]
        tabItems = defaultItems
    }

    func updateTranslations() {
        tabBar.items?[0].title = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.DIARY.LABEL", defaultText: "Overview")
        tabBar.items?[1].title = TranslationsViewModel.shared.getAdditionalTranslation(key: "APPBAR.ACCOUNT", defaultText: "Account")
        tabBar.items?[2].title = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL", defaultText: "Info Library")
        tabBar.items?[3].title = TranslationsViewModel.shared.getAdditionalTranslation(key: "APPBAR.MORE", defaultText: "More")
    }

    public func updateTabBarItemColors() {
        guard let parent = parentViewController else { return }
            print("\n\nParent view controller: \(parent)\n\n")
            print("\n\nParent storyboard ID: \(String(describing: parent.restorationIdentifier))\n\n")

            for (index, item) in tabItems.enumerated() {
                switch parent.restorationIdentifier {
                case "overview":
                    if index == 0 {
                        tabBar.items?[0].image = tabBar.items?[0].image?.withRenderingMode(.alwaysOriginal)
                        tabBar.items?[0].image = tabBar.items?[0].image?.withTintColor(UIColor(hex:"3263BB"))
                    } else {
                        tabBar.items?[0].image = tabBar.items?[0].image?.withRenderingMode(.alwaysOriginal)
                        tabBar.items?[0].selectedImage = tabBar.items?[0].image?.withTintColor(UIColor(hex: "B9BCC8"))
                    }
                case "UserProfile":
                    if index == 1 {
                        tabBar.items?[1].image = tabBar.items?[1].image?.withRenderingMode(.alwaysOriginal)
                        tabBar.items?[1].image = tabBar.items?[1].image?.withTintColor(UIColor(hex:"3263BB"))
                    } else {
                        tabBar.items?[1].image = tabBar.items?[1].image?.withRenderingMode(.alwaysOriginal)
                        tabBar.items?[1].selectedImage = tabBar.items?[1].image?.withTintColor(UIColor(hex: "B9BCC8"))
                    }
                case "infoLibController":
                    if index == 2 {
                        tabBar.items?[2].image = tabBar.items?[2].image?.withRenderingMode(.alwaysOriginal)
                        tabBar.items?[2].image = tabBar.items?[2].image?.withTintColor(UIColor(hex:"3263BB"))
                    } else {
                        tabBar.items?[2].image = tabBar.items?[2].image?.withRenderingMode(.alwaysOriginal)
                        tabBar.items?[2].selectedImage = tabBar.items?[2].image?.withTintColor(UIColor(hex: "B9BCC8"))
                    }
                case "menuController":
                    if index == 3 {
                        tabBar.items?[3].image = tabBar.items?[3].image?.withRenderingMode(.alwaysOriginal)
                        tabBar.items?[3].image = tabBar.items?[3].image?.withTintColor(UIColor(hex:"3263BB"))
                    } else {
                        tabBar.items?[3].image = tabBar.items?[3].image?.withRenderingMode(.alwaysOriginal)
                        tabBar.items?[3].selectedImage = tabBar.items?[3].image?.withTintColor(UIColor(hex: "B9BCC8"))
                    }
                case "profileList":
                    tabBar.items?[0].image = tabBar.items?[0].image?.withRenderingMode(.alwaysOriginal)
                    tabBar.items?[0].image = tabBar.items?[0].image?.withTintColor(UIColor(hex:"3263BB"))
                default:
                    item.image = item.image?.withRenderingMode(.alwaysOriginal)
                    item.selectedImage = item.image?.withTintColor(UIColor(hex: "B9BCC8"))
                }
            }
        }

    // UITabBarDelegate method
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let parent = parentViewController else { return }

        switch item.tag {
        case 0:
            print("Overview Selected")
            navigateToViewController(from: parent, withIdentifier: "overview")
        case 1:
            print("Account Selected")
            navigateToViewController(from: parent, withIdentifier: "UserProfile")
        case 2:
            print("Info Library Selected")
            navigateToViewController(from: parent, withIdentifier: "infoLibController")
        case 3:
            print("More Selected")
            navigateToViewController(from: parent, withIdentifier: "rhfyjf")
        default:
            break
        }
//        updateTabBarItemColors()
    }

//    private func navigateToViewController(from parent: UIViewController, withIdentifier identifier: String) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? UIViewController else {
//            print("Error: ViewController with identifier \(identifier) not found.")
//            return
//        }
//
//        // Push to the navigation stack or present modally
//        if let navigationController = parent.navigationController {
//            navigationController.pushViewController(viewController, animated: false)
//        } else {
//            viewController.modalPresentationStyle = .fullScreen
//            parent.present(viewController, animated: false, completion: nil)
//        }
//    }
//    private func navigateToViewController<T: UIViewController>(
//        from parent: UIViewController,
//        withIdentifier identifier: String,
//        as type: T.Type
//    ) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
//            print("Error: ViewController with identifier \(identifier) could not be cast to \(T.self).")
//            return
//        }
//
//        // Configure the presentation style
//        viewController.modalPresentationStyle = .fullScreen
//
//        // Present or push the view controller
//        if let navigationController = parent.navigationController {
//            navigationController.pushViewController(viewController, animated: true)
//        } else {
//            parent.present(viewController, animated: true, completion: nil)
//        }
//    }
     func navigateToViewController(from parent: UIViewController, withIdentifier identifier: String) {
        if let navigationController = parent.navigationController,
           let existingVC = navigationController.viewControllers.first(where: { $0.restorationIdentifier == identifier }) {
            navigationController.popToViewController(existingVC, animated: false)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: identifier)

            viewController.modalPresentationStyle = .fullScreen
            parent.present(viewController, animated: false, completion: nil)
        }
    }

}
