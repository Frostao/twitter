//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Carl Chen on 2/7/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit
import SVPullToRefresh

class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newTweetPosted:", name: "newTweetPosted", object: nil)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.addInfiniteScrollingWithActionHandler { () -> Void in
            let lastTweet = self.tweets![self.tweets!.count-1]
            let lastID = lastTweet.id
            let parameters:NSDictionary = ["max_id": lastID!]
            TwitterClient.sharedInstance.timeLineWithCompletion(parameters, completion: { (tweets, error) -> Void in
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
        TwitterClient.sharedInstance.timeLineWithCompletion(nil) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.timeLineWithCompletion(nil) { (tweets, error) -> Void in
            self.tweets = tweets
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showDetail", sender: tweets![indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "showDetail" {
            let destViewController = segue.destinationViewController as! TweetDetailViewController
            destViewController.tweet = sender as? Tweet
        } else if segue.identifier == "showProfile" {
            let destViewController = segue.destinationViewController as! ProfileTableViewController
            destViewController.user = sender as? User
            
        }
        
    }
    
    func newTweetPosted(notification: NSNotification) {
        let tweet = notification.userInfo!["tweet"] as! Tweet
        tweets?.insert(tweet, atIndex: 0)
        tableView.reloadData()
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
