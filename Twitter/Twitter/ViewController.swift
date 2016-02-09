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
        
        
        let viewController = UIViewController()
        viewController.view.backgroundColor = UIColor.whiteColor()
        let webview = UIWebView(frame: CGRect(x: 0, y: 20, width: viewController.view.frame.width, height: viewController.view.frame.height-20))
        viewController.view.addSubview(webview)
        self.presentViewController(viewController, animated: true,completion: nil)
        
        TwitterClient.sharedInstance.loginWithWebview(webview) { (user, error) -> Void in
            viewController.dismissViewControllerAnimated(true, completion: nil)
            if user != nil {
                self.performSegueWithIdentifier("showTimeLine", sender: nil)
            }
        }
        
        
//        TwitterClient.sharedInstance.loginWithCompletion { (user, error) -> Void in
//            if user != nil {
//                self.performSegueWithIdentifier("showTimeLine", sender: nil)
//            } else {
//                
//            }
//        }
        
        
    }


}

