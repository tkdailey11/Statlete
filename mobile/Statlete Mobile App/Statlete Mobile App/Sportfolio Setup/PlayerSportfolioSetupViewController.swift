//
//  PlayerSportfolioSetupViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class PlayerSportfolioSetupViewController: UIViewController {

    @IBAction func chooseSportButtonClicked(_ sender: UIButton) {
    }
  
    @IBOutlet weak var playerNameTextField: UITextField!
   
  
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var teamIDTextField: UITextField!
    
    @IBOutlet weak var tokenTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    
   
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.playerNameTextField.frame.height))
        let playerline = CALayer()
        playerline.frame = CGRect(x: 0, y: playerNameTextField.frame.height - 1, width: playerNameTextField.frame.width , height: 1)
        playerline.backgroundColor = Colors.color5.cgColor
        
        playerNameTextField.leftView = playerPaddingView
        playerNameTextField.leftViewMode = UITextFieldViewMode.always
        playerPaddingView.layer.addSublayer(playerline)
        /*
        chooseSportButton.layer.borderColor = Colors.color4.cgColor
        chooseSportButton.layer.borderWidth = 0.8

        chooseSportButton.layer.shadowColor = UIColor.black.cgColor
        chooseSportButton.layer.shadowOpacity = 0.8
        chooseSportButton.layer.shadowOffset = CGSize(width: 5, height: 0)
        */
      
      
        
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
