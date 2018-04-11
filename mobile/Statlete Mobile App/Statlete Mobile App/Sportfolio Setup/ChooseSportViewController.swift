//
//  ChooseSportViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/8/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class ChooseSportViewController: UIViewController {

    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        popupView.layer.cornerRadius = 15
        popupView.layer.borderWidth = 3
        popupView.layer.borderColor = Colors.color1.cgColor
        popupView.layer.masksToBounds = true
     

    }


    @IBAction func closePopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
