//
//  CreateAccountViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 3/26/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UITextFieldDelegate{
    
   
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        // text field padding
        let namePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.nameTextField.frame.height))
        let emailPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.emailTextField.frame.height))
        let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.passwordTextField.frame.height))
       
        // text field underline border
        let nameline = CALayer()
        print(view.bounds.debugDescription)
     
        nameline.frame = CGRect(x: 0 , y: nameTextField.frame.height - 1, width: view.bounds.width * 0.7, height: 1)
        nameline.backgroundColor = UIColor.white.cgColor
        print(nameline.frame.debugDescription)
        let emailline = CALayer()
        emailline.frame = CGRect(x: 0, y: nameTextField.frame.height - 1, width: view.bounds.width * 0.7, height: 1)
        emailline.backgroundColor = UIColor.white.cgColor
        let passwordline = CALayer()
        passwordline.frame = CGRect(x: 0, y: passwordTextField.frame.height - 1, width: view.bounds.width * 0.7, height: 1)
        passwordline.backgroundColor = UIColor.white.cgColor
   
        // add attributes to text fields
        nameTextField.leftView = namePaddingView
        nameTextField.leftViewMode = UITextFieldViewMode.always
        namePaddingView.layer.addSublayer(nameline)
        
        emailTextField.leftView = emailPaddingView
        emailTextField.leftViewMode = UITextFieldViewMode.always
        emailPaddingView.layer.addSublayer(emailline)

        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        passwordPaddingView.layer.addSublayer(passwordline)
        createAccountButton.layer.cornerRadius = 10
        navigationController?.isNavigationBarHidden = false

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
  
    @IBAction func backButtonClicked(_ sender: UIButton) {
         _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func createAccountClicked(_ sender: UIButton) {
        // create new user with text field info
        // add to database
        
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print("EEEEERRRRRROOOOOOORRRRRR")
            } else {
                // Add new user to database
                let email = self.emailTextField.text!
                let id = email.replacingOccurrences(of: ".", with: "")
                let phoneNumber = ""
                let name = self.nameTextField.text!
                
                DB.database.child("Users").child(id).updateChildValues(["Name": name, "Phone": phoneNumber, "AdminTeams": " ", "PlayerTeams": " "])
                
                // Create a new user object
                 DB.currentUser = User(name: name, email: email)
                
                self.performSegue(withIdentifier: "toHome", sender: self)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

final class OtherGradientView: UIView{
    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: superview!.frame.size.width, height: superview!.frame.size.height)
        gradient.colors = [Colors.tangerine.cgColor, Colors.orange.cgColor]
        gradient.zPosition = -1
        
        layer.addSublayer(gradient)
    }
}





