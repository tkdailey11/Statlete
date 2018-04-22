//
//  NewOrExistingViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/11/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class NewOrExistingViewController: UIViewController {


    @IBOutlet weak var existingTeamButton: UIButton!
    @IBOutlet weak var newTeamButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
       
        newTeamButton.layer.cornerRadius = 10
        newTeamButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        newTeamButton.layer.shadowRadius = 5
        newTeamButton.layer.shadowOpacity = 0.9
        
        newTeamButton.layer.shadowColor = Colors.shadow.cgColor
        
        existingTeamButton.layer.cornerRadius = 10
        existingTeamButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        existingTeamButton.layer.shadowRadius = 5
        existingTeamButton.layer.shadowOpacity = 0.9
        
        existingTeamButton.layer.shadowColor = Colors.shadow.cgColor
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
