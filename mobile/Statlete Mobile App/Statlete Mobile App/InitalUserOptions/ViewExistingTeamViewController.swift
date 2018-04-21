//
//  ViewExistingTeamViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class ViewExistingTeamViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var teamIDTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        teamIDTextField.delegate = self
        let teamPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.teamIDTextField.frame.height))
        let teamline = CALayer()
        teamline.frame = CGRect(x:0, y: teamIDTextField.frame.height - 1, width: view.bounds.width * 0.7, height: 1)
        
        teamline.backgroundColor = UIColor.white.cgColor
        teamIDTextField.leftView = teamPaddingView
        teamIDTextField.leftViewMode = UITextFieldViewMode.always
        teamPaddingView.layer.addSublayer(teamline)
        viewButton.layer.cornerRadius = 10
        navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
