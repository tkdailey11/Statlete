//
//  SportfolioViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class SportfolioViewController: UIViewController {

    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageViewContainer: UIView!
 
    @IBAction func menuButtonClicked(_ sender: Any)
    {
        print("menu clicked")
        if(isSideMenuHidden){
            self.viewConstraint.constant = 0
        }
        else{
            self.viewConstraint.constant = -175
        }
        isSideMenuHidden = !isSideMenuHidden
    }
    
    @IBAction func tappedOutside(_ sender: UITapGestureRecognizer) {
        // TO DO 
        
    }
    
    var isSideMenuHidden: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        blurView.layer.cornerRadius = 15
        sideView.layer.shadowColor = UIColor.black.cgColor
        sideView.layer.shadowOpacity = 0.8
        sideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        viewConstraint.constant = -175
        
       /* blurView.layer.cornerRadius = 15
        SideView.layer.shadowColor = UIColor.blue.cgColor
        SideView.layer.shadowOpacity = 0.8
        SideView.layer.shadowOffset = CGSize(width: 5, height: 0)
        
        viewConstraint.constant = -175*/
        
       // self.navigationController?.isNavigationBarHidden = true
        

    
    }
 //   @IBOutlet weak var SideView: UIView!
    
  //  @IBOutlet weak var blurView: UIVisualEffectView!
  //  @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
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
