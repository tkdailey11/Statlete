//
//  ViewExistingTeamViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class ViewExistingTeamViewController: UIViewController {

    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var teamIDTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let teamPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.teamIDTextField.frame.height))
        let teamline = CALayer()
        teamline.frame = CGRect(x: teamPaddingView.frame.width, y: teamIDTextField.frame.height - 1, width: teamIDTextField.frame.width - teamPaddingView.frame.width, height: 1)
        
        teamline.backgroundColor = UIColor.white.cgColor
        teamIDTextField.leftView = teamPaddingView
        teamIDTextField.leftViewMode = UITextFieldViewMode.always
        teamPaddingView.layer.addSublayer(teamline)
        viewButton.layer.cornerRadius = 10
        
        //   _ = navigationController?.popViewController(animated: true)
    }
   
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
         _ = navigationController?.popViewController(animated: true)
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
