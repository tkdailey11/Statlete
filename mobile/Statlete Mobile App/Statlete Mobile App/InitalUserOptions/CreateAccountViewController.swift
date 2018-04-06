//
//  CreateAccountViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 3/26/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController{
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let namePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.nameTextField.frame.height))
         let usernamePaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.usernameTextField.frame.height))
         let passwordPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: self.passwordTextField.frame.height))
        // nameTextField.layer.borderColor = UIColor.red.cgColor
        // nameTextField.layer.borderWidth = 0.5
        nameTextField.leftView = namePaddingView
        nameTextField.leftViewMode = UITextFieldViewMode.always
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: nameTextField.frame.size.height - width, width: nameTextField.frame.width, height: 1)
        nameTextField.layer.addSublayer(border)
        nameTextField.layer.masksToBounds = true
        usernameTextField.layer.borderColor = UIColor.red.cgColor
        usernameTextField.layer.borderWidth = 0.5
        usernameTextField.leftView = usernamePaddingView
        usernameTextField.leftViewMode = UITextFieldViewMode.always
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.leftView = passwordPaddingView
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        createAccountButton.layer.borderWidth = 0.8
        createAccountButton.layer.borderColor = UIColor.red.cgColor
        
    }
  
    @IBAction func backButtonClicked(_ sender: UIButton) {
         _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

