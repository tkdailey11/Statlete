//
//  PlayerSportfolioSetupViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class PlayerSportfolioSetupViewController: UIViewController {

    @IBOutlet weak var chooseSportButton: UIButton!
    @IBOutlet weak var playerNameTextField: UITextField!
   
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var teamIDTextField: UITextField!
    
    @IBOutlet weak var tokenTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let usernamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.playerNameTextField.frame.height))
        playerNameTextField.layer.borderWidth = 0.8
        playerNameTextField.layer.borderColor = UIColor.red.cgColor
        playerNameTextField.leftView = usernamePaddingView
        playerNameTextField.leftViewMode = UITextFieldViewMode.always
        chooseSportButton.layer.borderWidth = 0.8
        chooseSportButton.layer.borderColor = UIColor.red.cgColor
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.red.cgColor
        
    }
    @IBAction func backButtonClicked(_ sender: UIButton) {
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
