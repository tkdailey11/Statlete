//
//  PlayerSportfolioSetupViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class PlayerSportfolioSetupViewController: UIViewController{

    // text fields
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var teamIDTextField: UITextField!
    @IBOutlet weak var tokenTextField: UITextField!
    
    // outlet for button to customize display
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // button actions
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    // default chosen sport to soccer
    var chosenSport: Int = 1
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let playerPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.playerNameTextField.frame.height))
        let playerline = CALayer()
        playerline.frame = CGRect(x: 0, y: playerNameTextField.frame.height - 1, width: playerNameTextField.frame.width , height: 1)
        playerline.backgroundColor = Colors.color5.cgColor
        playerNameTextField.leftView = playerPaddingView
        playerNameTextField.leftViewMode = UITextFieldViewMode.always
        playerPaddingView.layer.addSublayer(playerline)
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseSport"{
            let vc = segue.destination as! ChooseSportViewController
            vc.delegate = self
        }
    }
    @IBAction func createButtonClicked(_ sender: UIButton) {
        var sportfolioId = "id7"
        var teamIdText: String
        if(teamIDTextField.text == teamIDTextField.placeholder){
            teamIdText = "NA"
        }else{
            teamIdText = teamIDTextField.text!
        }
        let id = DB.currentUser.email.replacingOccurrences(of: ".", with: "")
        // create new player sportfolio object
        var psf: PlayerSportfolio = PlayerSportfolio(id: sportfolioId, sport: "soccer", teamId: teamIdText, name: playerNameTextField.text!, user: id)
        
        // Add data to Users
        let thisUser = DB.database.child("Users").child(id)
        thisUser.child("PlayerTeams")
       // DB.database.child("Users").child(id).child("PlayerTeams").updateChildValues(["Name": name]) // changing PlayerTeams to PlayerSportfolios
        
        // Add data in PlayerSportfolio
    }
    
}

extension PlayerSportfolioSetupViewController: PopupDelegate{
    func sportSelected(value: Int) {
        chosenSport = value
    }
}
