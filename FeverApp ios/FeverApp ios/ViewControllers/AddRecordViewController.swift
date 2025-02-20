//
//  AddRecordViewController.swift
//  FeverApp ios
//
//  Created by NEW on 13/08/2024.
//

import UIKit

class AddRecordViewController: UIViewController{
    
    @IBOutlet weak var chatView: UIView!
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button4: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topView.layer.borderColor = UIColor.white.cgColor
        topView.layer.borderWidth = 1.0 // Border width in points
                topView.layer.cornerRadius = 15.0
        bottomView.layer.borderColor = UIColor.white.cgColor
        bottomView.layer.borderWidth = 1.0 // Border width in points
                bottomView.layer.cornerRadius = 15.0
        button1.layer.cornerRadius = 5
        button1.clipsToBounds = true
        button2.layer.cornerRadius = 5
        button2.clipsToBounds = true
        button3.layer.cornerRadius = 5
        button3.clipsToBounds = true
        button4.layer.cornerRadius = 5
        button4.clipsToBounds = true
       

        chatView.layer.shadowColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1).cgColor
        chatView.layer.shadowOpacity = 0.8
        chatView.layer.shadowRadius = 4
        chatView.layer.shadowOffset = CGSize(width: 0, height: 4)
        chatView.layer.cornerRadius = 8
            chatView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        

        
        
        
        
        
    }
}
