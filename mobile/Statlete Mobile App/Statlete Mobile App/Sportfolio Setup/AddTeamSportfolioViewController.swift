//
//  AddTeamSportfolioViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class AddTeamSportfolioViewController: UIViewController {

    
    @IBOutlet weak var playerButton: UIButton!
    @IBOutlet weak var teamButton: UIButton!
   // @IBOutlet weak var backButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.isNavigationBarHidden = true
       // teamButton.layer.borderWidth = 0.6
        //teamButton.layer.borderColor = Colors.color2.cgColor
        teamButton.layer.cornerRadius = 10
       //     teamButton.layer.shadowColor = UIColor.black.cgColor
        teamButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        teamButton.layer.shadowRadius = 5
        teamButton.layer.shadowOpacity = 0.9

        teamButton.layer.shadowColor = Colors.color4.cgColor
        
        playerButton.layer.borderWidth = 0.6
        playerButton.layer.borderColor = Colors.color2.cgColor
        playerButton.layer.cornerRadius = 10
        playerButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        playerButton.layer.shadowRadius = 5
        playerButton.layer.shadowOpacity = 0.9
        
        playerButton.layer.shadowColor = Colors.color4.cgColor
        
        navigationController?.isNavigationBarHidden = false
        
     //   navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //navigationController?.navigationBar.shadowImage = UIImage()
     //   navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationItem.title = "Choose Sportfolio"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Avenir Next Ultra Light", size: 20)!]
        
        self.navigationController?.navigationBar.tintColor = Colors.red
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
   /*
    @IBAction func backButtonClicked(_ sender: UIButton) {
           _ = navigationController?.popViewController(animated: true)
    }
    */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


