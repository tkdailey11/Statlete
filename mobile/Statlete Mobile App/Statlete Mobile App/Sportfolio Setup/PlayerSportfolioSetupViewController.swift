//
//  PlayerSportfolioSetupViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class PlayerSportfolioSetupViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var chooseSportButton: UIButton!
    // text fields
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var teamIDTextField: UITextField!
    @IBOutlet weak var tokenTextField: UITextField!
    
    @IBOutlet weak var numberTextField: UITextField!
    // outlet for button to customize display
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // button actions
    @IBAction func backButton(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    // default chosen sport to soccer
    var chosenSport: Int = 1
    var sportfolioId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameTextField.delegate = self
        teamIDTextField.delegate = self
        tokenTextField.delegate = self
        numberTextField.delegate = self
        sportfolioId = generateId()
        let playerPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.playerNameTextField.frame.height))
        let playerline = CALayer()
        playerline.frame = CGRect(x: 0, y: playerNameTextField.frame.height - 1, width: playerNameTextField.frame.width , height: 1)
        playerline.backgroundColor = Colors.yellow.cgColor
        playerNameTextField.leftView = playerPaddingView
        playerNameTextField.leftViewMode = UITextFieldViewMode.always
        playerPaddingView.layer.addSublayer(playerline)
        chooseSportButton.layer.cornerRadius = chooseSportButton.frame.height / 2
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseSport"{
            let vc = segue.destination as! ChooseSportViewController
            vc.delegate = self
        }
        if segue.identifier == "toSportfolio"{
            let vc = segue.destination as! SportfolioViewController
           
            if(teamIDTextField.text!.isEmpty){
                DB.loadPlayerSportfolio(with: sportfolioId, completion: { success in
                    if success {
                        vc.thisSportfolio = DB.currentSportfolio
                        vc.view.setNeedsDisplay()
                    }
                    else {
                    }
                })
            }else{
                let sid = teamIDTextField.text!
                DB.loadTeamSportfolio(with: sid, completion: { success in
                    if success {
                        vc.thisSportfolio = DB.currentSportfolio
                        vc.view.setNeedsDisplay()
                    }
                    else {
                        print("Failed to load player sportfolio linked to a team")
                    }
                })
            }
            
            
        }
        
    }
    @IBAction func createButtonClicked(_ sender: UIButton) {
    //    sportfolioId = generateId()
        var teamIdText: String
        if(teamIDTextField.text == teamIDTextField.placeholder){
            teamIdText = "NA"
        }else{
            teamIdText = teamIDTextField.text!
        }
        let id = DB.currentUser.email.replacingOccurrences(of: ".", with: "")
        // create new player sportfolio object
        var psf: PlayerSportfolio = PlayerSportfolio(id: sportfolioId, sport: "soccer", teamId: teamIdText, name: playerNameTextField.text!, user: id)
        DB.currentUser.PlayerSportfolios[sportfolioId] = teamIdText
        
        // Add data to Users
        DB.database.child("Users").child(id).child("PlayerSportfolios").updateChildValues([sportfolioId: teamIdText]) // changing PlayerTeams to PlayerSportfolios
        
        // Add data in PlayerSportfolio
        let pname: String = playerNameTextField.text ?? DB.currentUser.name
        DB.database.child("PlayerSportfolios").child(sportfolioId).updateChildValues(["Games": " ", "Name": pname, "Number": numberTextField.text!, "TeamID": teamIdText, "TotalStats": " ", "User": id])
        
         self.performSegue(withIdentifier: "toSportfolio", sender: self)
    }
    func generateId()-> String{
        var num = arc4random()
        return "id\(num)"
    }
    
}


extension PlayerSportfolioSetupViewController: PopupDelegate{
    func sportSelected(value: Int) {
        chosenSport = value
    }
}
