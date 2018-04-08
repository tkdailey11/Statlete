//
//  SportfolioViewController.swift
//  Statlete Mobile App
//
//  Created by Taylor M de Jonge on 4/3/18.
//  Copyright © 2018 Taylor M de Jonge. All rights reserved.
//

import UIKit

class SportfolioViewController: UIViewController {

    @IBOutlet weak var pageView: UIView!
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBAction func menuButton(_ sender: UIButton) {
        if(isSideMenuHidden){
         viewConstraint.constant = 0
         pageView.isUserInteractionEnabled = false
        } else{
         viewConstraint.constant = -175
         pageView.isUserInteractionEnabled = true
        }
        isSideMenuHidden = !isSideMenuHidden
       
    }
    
  var isSideMenuHidden: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        blurView.layer.cornerRadius = 15
        blurView.layer.shadowColor = UIColor.black.cgColor
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
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        let locationx = sender.location(in: view).x
        
        
        if(isSideMenuHidden){
            
        }else{
            if(locationx < 175){
                print("inside bounds of slide menu")
            }else{
                viewConstraint.constant = -175
                isSideMenuHidden = !isSideMenuHidden
            }
        }
    }
    //  @IBOutlet weak var blurView: UIVisualEffectView!
  //  @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    /*
    @IBAction func panPerformed(_ sender: UIPanGestureRecognizer) {
        print("detected")
        let location = sender.location(in: view).x
        if (isSideMenuHidden ){
            viewConstraint.constant = 0
            } else{
            viewConstraint.constant = -175
            }
            isSideMenuHidden = !isSideMenuHidden
        }
       */
      
        /*
        if(sender.state == .began || sender.state == .changed){
            let translation = sender.translation(in: self.view).x
            if(translation > 0){ // swipe right
                if viewConstraint.constant < 20{
                self.viewConstraint.constant += translation
                }
            }else{ // swipe left
                
            }
        }else if(sender.state == .ended){
            
        }
 */
        
   
    
    
    
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
