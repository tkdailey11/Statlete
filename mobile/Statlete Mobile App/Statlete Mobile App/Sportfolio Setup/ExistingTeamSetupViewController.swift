//
//  ExistingTeamSetupViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/8/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class ExistingTeamSetupViewController: UIViewController {

    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var teamTokenTextField: UITextField!
    @IBOutlet weak var teamIDTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.view.backgroundColor = .clear
        navigationItem.title = "Existing Team"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir Next Ultra Light", size: 20)!]
        
        self.navigationController?.navigationBar.tintColor = Colors.red
       
    }

    @IBAction func createButtonClicked(_ sender: UIButton) {
        print("create was clicked")
        var teamId: String = teamIDTextField.text!
        var token: String = teamTokenTextField.text!
        let id = DB.currentUser.email.replacingOccurrences(of: ".", with: "")
     
        
        // add this user to the teams admins list
        DB.database.child("TeamSportfolios").child(teamId).child("Admins").updateChildValues([id: " "])
        
        
        // update current user
        DB.currentUser.AdminTeams.append(teamId)
        
        // add to database - Users
        DB.database.child("Users").child(id).child("AdminTeams").updateChildValues([teamId : " "])
        
        // add to database - Team Sportfolio
        //DB.database.child("TeamSportfolios").child(sportfolioId).updateChildValues(["Admins" : " ", "Creator" : id, "Games": " ", "Players" : " ", "Sport" : "soccer", "TeamName": teamName, "Token": " "])
        //DB.database.child("TeamSportfolios").child(sportfolioId).child("Players").updateChildValues(allplayers)
        
       
        self.performSegue(withIdentifier: "toSportfolio", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
