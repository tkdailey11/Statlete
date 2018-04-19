//
//  TeamSportfolioSetupViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class TeamSportfolioSetupViewController: UIViewController, UITextFieldDelegate {

   @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var addPlayersButton: UIButton!
  //  @IBOutlet weak var chooseSportButton: UIButton!
    @IBOutlet weak var teamNameTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    
    // default chosen sport to soccer
    var chosenSport: Int = 1
    var allplayers: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamNameTextField.delegate = self
        
        // Do any additional setup after loading the view.
        let teamNamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.teamNameTextField.frame.height))
        teamNameTextField.layer.borderWidth = 0.8
        teamNameTextField.layer.borderColor = UIColor.red.cgColor
        teamNameTextField.leftView = teamNamePaddingView
        teamNameTextField.leftViewMode = UITextFieldViewMode.always
        teamNameTextField.layer.cornerRadius = 5
        addPlayersButton.layer.borderWidth = 0.8
        addPlayersButton.layer.borderColor = UIColor.red.cgColor
        addPlayersButton.layer.cornerRadius = 5
        /*chooseSportButton.layer.borderWidth = 0.8
        chooseSportButton.layer.borderColor = UIColor.red.cgColor
        chooseSportButton.layer.cornerRadius = 5*/
        createButton.layer.borderWidth = 1
        createButton.layer.borderColor = UIColor.red.cgColor
        createButton.layer.cornerRadius = 5
        
        
    }
  
    @IBAction func backButtonClicked(_ sender: UIButton) {
           _ = navigationController?.popViewController(animated: true)
           _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseSport"{
            let vc = segue.destination as! ChooseSportViewController
            vc.delegate = self
        }
        if segue.identifier == "toAddPlayers"{
            let vc = segue.destination as! ChoosePlayersViewController
            vc.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func createButtonClicked(_ sender: UIButton) {
        // create new team sportfolio
        var sportfolioId = "id101" // need to generate this?
        var teamName: String = teamNameTextField.text!
        var players : [String : String] = [:] // need to get these from the AddPLayers page
        var sport: String = "soccer"
      
     
        let id = DB.currentUser.email.replacingOccurrences(of: ".", with: "")
        if(chosenSport == 1){
            sport = "soccer"
        }else if(chosenSport == 0){
             sport = "basketball"
        }else{
            sport = "football"
        }
        var tsf : TeamSportfolio = TeamSportfolio(id: id, creator: id, sport: sport, players: players, teamName: teamName)
        
        // update current user
        DB.currentUser.AdminTeams.append(sportfolioId)
        
        // add to database - Users
        DB.database.child("Users").child(id).child("AdminTeams").updateChildValues([sportfolioId : " "])
        
        // add to database - Team Sportfolio
        DB.database.child("TeamSportfolios").child(sportfolioId).updateChildValues(["Admins" : " ", "Creator" : id, "Games": " ", "Players" : " ", "Sport" : "soccer", "TeamName": teamName, "Token": " "])
        DB.database.child("TeamSportfolios").child(sportfolioId).child("Players").updateChildValues(allplayers)
        self.performSegue(withIdentifier: "toSportfolio", sender: self)

        
    }
    
 

}

extension TeamSportfolioSetupViewController: PopupDelegate, AddPlayersDelegate{
    func playersAdded(value: [String : String]) {
        allplayers = value
    }
    
    func sportSelected(value: Int) {
        chosenSport = value
    }
}
