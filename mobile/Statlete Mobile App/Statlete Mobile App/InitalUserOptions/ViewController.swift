//
//  ViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 3/6/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ViewExistingTeamButton: UIButton!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var CreateAccountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      
        LoginButton.layer.borderWidth = 0.8
        LoginButton.layer.borderColor = Colors.tempcolor.cgColor
        LoginButton.layer.cornerRadius = 25
        CreateAccountButton.layer.cornerRadius = 25
        CreateAccountButton.layer.borderWidth = 0.8
        CreateAccountButton.layer.borderColor = Colors.tempcolor.cgColor
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


final class GradientView: UIView{
    override func draw(_ rect: CGRect) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: superview!.frame.size.width, height: superview!.frame.size.height)
        gradient.colors = [Colors.red.cgColor, Colors.tangerine.cgColor, Colors.orange.cgColor]
        gradient.zPosition = -1
      
        layer.addSublayer(gradient)
    }
}



