//
//  NewGameViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    var duration: Int = 0
    var pickerData: [String] = ["10", "12", "15"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.durationPicker.delegate = self
        self.durationPicker.dataSource = self
        
        navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        
        self.navigationController?.navigationBar.tintColor = Colors.red

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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        duration = Int(pickerData[row])!
        print("duration of game: \(duration)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewGameEntryMode" {
            if let controller = segue.destination as? SoccerEntryModeController {
                
                let sid = DB.currentSportfolio.sportfolioId
                let gameName = nameTextField.text ?? ""
                let gameID = "\(sid)-\(DB.currentSportfolio.games.count+1)"
                controller.game = SoccerGame(team: sid, gameID: gameID, name: gameName, halfLength: 45)
                DB.currentSportfolio.games[gameID] = gameName
                DB.database.child("TeamSportfolios/\(sid)/Games").updateChildValues([gameID: gameName])
 
                /*
                controller.game = SoccerGame(team: "teamNate", gameID: "teamNate-1")
                controller.game.loadGameFromDatabase(completion: { success in
                    if success {
                        
                    }
                    else {
                    }
                })
                */
            }
        }
    }
    
}
