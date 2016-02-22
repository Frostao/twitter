//
//  ProfileTableViewController.swift
//  Twitter
//
//  Created by Carl Chen on 2/14/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit
import IDMPhotoBrowser

class ProfileTableViewController: UITableViewController {
    var tweets: [Tweet]?
    var screenName: String?
    var user:User?

    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.addInfiniteScrollingWithActionHandler { () -> Void in
            let lastTweet = self.tweets![self.tweets!.count-1]
            let lastID = lastTweet.id
            let parameters:NSDictionary = ["max_id": lastID!, "screen_name": self.screenName!]
            TwitterClient.sharedInstance.userTimeLineWithCompletion(parameters, completion: { (tweets, error) -> Void in
                var index = 0
                for tweet in tweets! {
                    if index != 0 {
                        self.tweets?.append(tweet)
                    }
                    index = index + 1
                }
                self.tableView.reloadData()
                self.tableView.infiniteScrollingView.stopAnimating()
            })
            
            
            
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        if user == nil {
            user = User.currentUser
        }
        screenName = user?.screenName
        let parameter: NSDictionary = ["screen_name": screenName!]
        TwitterClient.sharedInstance.userTimeLineWithCompletion(parameter) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }

    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        let parameter: NSDictionary = ["screen_name": screenName!]
        TwitterClient.sharedInstance.userTimeLineWithCompletion(parameter) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return 1
        } else {
            if let tweets = tweets {
                return tweets.count
            } else {
                return 0
            }
        }
    }

    func profileTapped(recognizer: UIGestureRecognizer) {
        
        let photoURL = user?.profileImageUrl?.stringByReplacingOccurrencesOfString("_normal", withString: "")
        let photo = IDMPhoto(URL: NSURL(string: photoURL!))
        let browser = IDMPhotoBrowser(photos: [photo], animatedFromView: nil)
        browser.displayDoneButton = false
        self.presentViewController(browser, animated: true, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("profile", forIndexPath: indexPath) as! ProfileTableViewCell
            cell.name.text = user!.name
            cell.username.text = "@" + (user!.screenName)!
            cell.content.text = user!.tagline
            cell.followerCount.text = (user!.followerCount?.description)! + " FOLLOWERS"
            cell.followingCount.text = (user!.followingCount?.description)! + " FOLLOWING"
            cell.profileImage.setImageWithURL(NSURL(string: (user!.profileImageUrl)!))
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: "profileTapped:")
            cell.profileImage.addGestureRecognizer(gestureRecognizer)
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TweetsCell
            if let tweets = tweets {
                let tweet = tweets[indexPath.row]
                let user = tweet.user
                cell.tweet = tweet
                if tweet.liked! {
                    cell.likeButton.setBackgroundImage(UIImage(named: "like-action-pressed"), forState: .Normal)
                }
                
                if tweet.retweeted! {
                    cell.retweetButton.setBackgroundImage(UIImage(named: "retweet-action-pressed"), forState: .Normal)
                }
                
                cell.name.text = user?.name
                cell.username.text = "@\(user!.screenName!)"
                cell.profileImage.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
                cell.viewController = self
                cell.content.text = tweet.text
                let time = Int((tweet.createAt?.timeIntervalSinceNow)!)
                let hours = -time / 3600
                
                cell.time.text = "\(hours)h"
                
                if tweet.repostCount == 0 {
                    cell.repostCount.text = ""
                } else {
                    cell.repostCount.text = tweet.repostCount?.description
                }
                if tweet.likeCount == 0 {
                    cell.likeCount.text = ""
                } else {
                    cell.likeCount.text = tweet.likeCount?.description
                }
                
                
            }
            
            return cell
        }
        

        // Configure the cell...

        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
