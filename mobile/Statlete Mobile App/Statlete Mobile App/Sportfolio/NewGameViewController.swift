//
//  NewGameViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {

    var pickerData: [Int] = [10, 12, 15]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var durationPicker: UIPickerView!
    @IBOutlet weak var opponentNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
           _ = navigationController?.popViewController(animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewGameEntryMode" {
            if let controller = segue.destination as? SoccerEntryModeController {
                //controller.game = SoccerGame(team: "team2", gameID: "team2-1", name: "vs. Sparta 06", halfLength: 45)
                
                
                
                controller.game = SoccerGame(team: "team2", gameID: "team2-1")
                controller.game.loadGameFromDatabase(completion: { success in
                    if success {
                    }
                    else {
                    }
                })
 
            }
        }
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
