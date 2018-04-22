//
//  ChooseSportViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/8/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit
protocol ChooseSportDelegate: AnyObject{
    func sportSelected(value: Int)
}
class ChooseSportViewController: UIViewController {

    var delegate: PopupDelegate?
    
    var sport: Int = 1
    @IBOutlet weak var popupView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popupView.layer.cornerRadius = 15
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.8
        popupView.layer.shadowOffset = CGSize(width: 10, height: 0)
        popupView.layer.cornerRadius = 15
     //   popupView.layer.borderWidth = 3
      //  popupView.layer.borderColor = Colors.color1.cgColor
        popupView.layer.masksToBounds = true

    }

    @IBAction func footballSelected(_ sender: UIButton) {
        sport = 3
    }
    @IBAction func soccerSelected(_ sender: UIButton) {
        sport = 1
    }
    
    @IBAction func basketballSelected(_ sender: UIButton) {
        sport = 0
    }
    @IBAction func closePopup(_ sender: UIButton) {
        if let delegate = delegate{
            delegate.sportSelected(value: sport)
        }
        dismiss(animated: true, completion: nil)
    }
    

}
