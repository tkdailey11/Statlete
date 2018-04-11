//
//  TeamSportfolioSetupViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class TeamSportfolioSetupViewController: UIViewController {

   @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var addPlayersButton: UIButton!
  //  @IBOutlet weak var chooseSportButton: UIButton!
    @IBOutlet weak var teamNameTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
