//
//  LoginViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/2/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.layer.borderWidth = 0.8
        usernameTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = 0.8
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        
        loginButton.layer.borderWidth = 0.8
        loginButton.layer.borderColor = UIColor.red.cgColor
    

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
