//
//  UITabBarController.swift
//  FeverApp ios
//
//  Created by user on 11/25/24.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    @IBOutlet weak var overViewText: UITabBar!
    @IBOutlet weak var accountText: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountText.items![0].title = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.DIARY.LABEL", defaultText: "Overview")
        accountText.items![1].title = TranslationsViewModel.shared.getAdditionalTranslation(key: "APPBAR.ACCOUNT",defaultText: "Account")
        accountText.items![2].title = TranslationsViewModel.shared.getTranslation(key: "SHELL.TAB.INFOS.LABEL",defaultText: "Info Library")
        accountText.items![3].title = TranslationsViewModel.shared.getAdditionalTranslation(key: "APPBAR.MORE", defaultText: "More")
        
        // The hidden view controller
                let hiddenVC = PersonalInfoViewController()
                hiddenVC.tabBarItem = UITabBarItem() // Empty tabBarItem
    }
    
}


