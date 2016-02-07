//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Carl Chen on 2/7/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        TwitterClient.sharedInstance.timeLineWithCompletion(nil) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TweetsCell
        if let tweets = tweets {
            let tweet = tweets[indexPath.row]
            let user = tweet.user
            cell.name.text = user?.name
            cell.username.text = "@\(user!.screenName!)"
            cell.profileImage.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
            cell.content.text = tweet.text
            let time = Int((tweet.createAt?.timeIntervalSinceNow)!)
            let hours = time / 3600
            
            cell.time.text = "\(hours)h"
            
            cell.repostCount.text = tweet.repostCount?.description
            cell.likeCount.text = tweet.likeCount?.description
            
        }
        return cell
    }
    
    
    
    @IBAction func didClickLogout(sender: AnyObject) {
        User.currentUser?.logout()
        
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
