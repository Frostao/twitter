//
//  ViewController.swift
//  Twitter
//
//  Created by Carl Chen on 2/4/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func loginClicked(sender: AnyObject) {
        
        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("showTimeLine", sender: nil)
            } else {
                
            }
        }
        
        
    }


}

