//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Carl Chen on 2/14/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textCount: UILabel!
    @IBOutlet weak var textInput: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        textCount.text = ""
        textInput.contentInset = UIEdgeInsets(top: -60, left: 0, bottom: 0, right: 0)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func postPressed(sender: AnyObject) {
        let parameters: NSDictionary = ["status": textInput.text]
        TwitterClient.sharedInstance.postTweet(parameters) { (response, error) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
            let tweet = Tweet(dictionary: response!)
            NSNotificationCenter.defaultCenter().postNotificationName("newTweetPosted", object: nil, userInfo: ["tweet": tweet])
            
        }
    }
    func textViewDidChange(textView: UITextView) {
        textCount.text = textView.text.characters.count.description
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
