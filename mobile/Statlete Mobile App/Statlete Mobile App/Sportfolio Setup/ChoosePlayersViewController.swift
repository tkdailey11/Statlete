//
//  ChoosePlayersViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit
protocol AddPlayersDelegate{
    func playersAdded(value: [Int: String])
}

class ChoosePlayersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    var delegate: AddPlayersDelegate?
    var playerNames: [String] = [String](repeating: "", count: 20)
    var playerNumbers: [Int] = [Int](repeating: 0, count: 20)
    var players: [Int : String] = [:]
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func doneButtonClicked(_ sender: UIButton) {
        for i in 0...playerNames.count - 1{
            if(playerNames[i] != ""){
              players[playerNumbers[i]] = playerNames[i]
                
            }
           
        }
        if let delegate = delegate{
            delegate.playersAdded(value: players)
        }
        dismiss(animated: true, completion: nil)
        //_ = navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddPlayerCell", for: indexPath) as! PlayerCell
        cell.playerNameTextField?.delegate = self
        cell.playerNumberTextField?.delegate = self
        cell.playerNameTextField.tag = indexPath.row
        cell.playerNumberTextField.tag = indexPath.row
        
        return cell
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
     
        let index: Int = textField.tag
        print("TAG: \(textField.tag)")
        
        if(textField.accessibilityIdentifier == "num"){
            print("PLAYER'S NUMBER : \(textField.text ?? "no number")")
            if(textField.text != nil && !(textField.text?.isEmpty)!){
                
                playerNumbers[index] = Int(textField.text!)!
            }
        }
        else if (textField.accessibilityIdentifier == "name"){
            print("PLAYER'S NAME: \(textField.text ?? "no name")")
            
            if(textField.text != nil){
                playerNames[index] = textField.text!
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
   
}
