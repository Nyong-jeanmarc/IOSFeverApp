//
//  listOfMedicationViewController.swift
//  FeverApp ios
//
//  Created by NEW on 05/09/2024.
//

import UIKit
class listOfMedicationViewController:UIViewController{
  @IBOutlet var topView: UIView!
  @IBOutlet var bottomView: UIView!

    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    topView.layer.cornerRadius = 20
    topView.layer.masksToBounds = true
    bottomView.layer.cornerRadius = 20
    bottomView.layer.masksToBounds = true
  }
}
