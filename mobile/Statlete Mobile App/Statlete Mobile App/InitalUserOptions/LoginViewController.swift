//
//  LoginViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/2/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

   
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.emailTextField.frame.height))
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.passwordTextField.frame.height))
        
        let emailline = CALayer()
        emailline.frame = CGRect(x: emailPaddingView.frame.width, y: emailTextField.frame.height - 1, width: emailTextField.frame.width + emailPaddingView.frame.width, height: 1)
        let passwordline = CALayer()
        passwordline.frame = CGRect(x: passwordPaddingView.frame.width, y: passwordTextField.frame.height - 1, width: passwordTextField.frame.width + passwordPaddingView.frame.width, height: 1)
        passwordline.backgroundColor = UIColor.white.cgColor
        emailline.backgroundColor = UIColor.white.cgColor
        
        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = UITextFieldViewMode.always
        emailPaddingView.layer.addSublayer(emailline)
        
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        passwordPaddingView.layer.addSublayer(passwordline)

        
        loginButton.layer.cornerRadius = 10

    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if (error != nil) {
                print(error!)
            }
            else {
                let email = self.emailTextField.text!
                let id = email.replacingOccurrences(of: ".", with: "")
                print(id)
                var adminTeams: [String] = []
                var playerTeams: [String] = []
                var phone: String = String()
                
                let ref = DB.database.child("Users/\(id)")
                print(ref)
           
                ref.observeSingleEvent(of: .value, with: { snapshot in
                    
                    if !snapshot.exists() { return }
                    
                    print(snapshot)
                    
                    print(snapshot.value!)
                    var name: String = String()

                    name = snapshot.childSnapshot(forPath: "Name").value as! String
                    phone = snapshot.childSnapshot(forPath: "Phone").value as! String
                    print("name: \(name)")
                    var teams = snapshot.childSnapshot(forPath: "AdminTeams")
                    
                    for team in teams.children {
                        let teamSnapshot = team as! DataSnapshot
                        adminTeams.append(teamSnapshot.key as! String)
                    }
                    
                    teams = snapshot.childSnapshot(forPath: "PlayerTeams")
                    
                    for team in teams.children {
                        let teamSnapshot = team as! DataSnapshot
                        playerTeams.append(teamSnapshot.key as! String)
                    }
                    DB.currentUser = User(name: name, email: email)

                    print(DB.currentUser.name)
                })
              
             
                
                print(DB.currentUser.name)
                self.performSegue(withIdentifier: "toHome", sender: self)
                
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
