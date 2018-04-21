//
//  LoginViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/2/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {

   
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.emailTextField.frame.height))
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.passwordTextField.frame.height))
        
        let emailline = CALayer()
        emailline.frame = CGRect(x: 0, y: emailTextField.frame.height - 1, width: view.bounds.width * 0.7, height: 1)
        let passwordline = CALayer()
        passwordline.frame = CGRect(x: 0, y: passwordTextField.frame.height - 1, width: view.bounds.width * 0.7, height: 1)
        passwordline.backgroundColor = UIColor.white.cgColor
        emailline.backgroundColor = UIColor.white.cgColor
        
        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = UITextFieldViewMode.always
        emailPaddingView.layer.addSublayer(emailline)
        
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        passwordPaddingView.layer.addSublayer(passwordline)

        navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear

        self.navigationController?.navigationBar.tintColor = UIColor.white


        
        loginButton.layer.cornerRadius = 10

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if (error != nil) {
                print(error!)
            }
            else {
                let email = self.emailTextField.text!
                let id = email.replacingOccurrences(of: ".", with: "")
              
                DB.database.child("Users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    print("VALUEEE!!!!!!!!!!!!!!! \(value)")
                    let name = value?["Name"] as? String ?? ""
                    let phone = value?["Phone"] as? String ?? ""
                    print("NAME: \(name)")
                    DB.currentUser = User(name: name, email: email)
                    
                    var adminTeams: [String] = []
                    let adminTeamsSet = value?["AdminTeams"] as? [String: String] ?? [:]
                    let adminTeamIDs = adminTeamsSet.keys
                    for adminTeamID in adminTeamIDs {
                        adminTeams.append(adminTeamID)
                    }
                    DB.currentUser.AdminTeams = adminTeams
                    
                    var playerTeams: [String] = []
                    let playerTeamsSet = value?["PlayerTeams"] as? [String: String] ?? [:]
                    let playerTeamsIDs = playerTeamsSet.keys
                    for playerTeamsID in playerTeamsIDs {
                        playerTeams.append(playerTeamsID)
                    }
                    DB.currentUser.PlayerTeams = playerTeams // change this when db changes from PlayerTeams to PlayerSportfolios
                    
                    DB.currentUser.phoneNumber = phone
                })
 
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toHome", sender: self)
                }
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
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
