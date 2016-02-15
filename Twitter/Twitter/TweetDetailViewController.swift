//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Carl Chen on 2/14/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit
import IDMPhotoBrowser

class TweetDetailViewController: UIViewController {

    var tweet: Tweet?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var repostCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    func loadGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "profileTapped")
        profileImage.addGestureRecognizer(gestureRecognizer)
    }
    
    func profileTapped() {
        
        let photoURL = tweet?.user?.profileImageUrl?.stringByReplacingOccurrencesOfString("_normal", withString: "")
        let photo = IDMPhoto(URL: NSURL(string: photoURL!))
        let browser = IDMPhotoBrowser(photos: [photo], animatedFromView: nil)
        browser.displayDoneButton = false
        self.presentViewController(browser, animated: true, completion: nil)
    }
    
    
    
    @IBAction func replyTapped(sender: AnyObject) {
    }
    @IBAction func retweetTapped(sender: AnyObject) {
        if tweet!.retweeted! {
            TwitterClient.sharedInstance.unretweet(withID: tweet!.id!, complete: { (response, error) -> Void in
                self.retweetButton.setBackgroundImage(UIImage(named: "retweet-action"), forState: .Normal)
                self.tweet?.repostCount = self.tweet!.repostCount!.integerValue - 1
                self.repostCount.text = self.tweet?.repostCount?.description
                self.tweet?.retweeted = false
                
            })
        } else {
            TwitterClient.sharedInstance.retweet(withID: tweet!.id!, complete: { (response, error) -> Void in
                self.retweetButton.setBackgroundImage(UIImage(named: "retweet-action-pressed"), forState: .Normal)
                self.tweet?.repostCount = self.tweet!.repostCount!.integerValue + 1
                self.repostCount.text = self.tweet?.repostCount?.description
                self.tweet?.retweeted = true
                
            })
        }
        
        
    }
    @IBAction func likeTapped(sender: AnyObject) {
        if tweet!.liked! {
            TwitterClient.sharedInstance.unlike(withID: tweet!.id!, complete: { (response, error) -> Void in
                self.likeButton.setBackgroundImage(UIImage(named: "like-action"), forState: .Normal)
                self.tweet?.likeCount = self.tweet!.likeCount!.integerValue - 1
                self.likeCount.text = self.tweet?.likeCount?.description
                self.tweet?.liked = false
                
            })
        } else {
            TwitterClient.sharedInstance.like(withID: tweet!.id!, complete: { (response, error) -> Void in
                self.likeButton.setBackgroundImage(UIImage(named: "like-action-pressed"), forState: .Normal)
                self.tweet?.likeCount = self.tweet!.likeCount!.integerValue + 1
                self.likeCount.text = self.tweet?.likeCount?.description
                self.tweet?.liked = true
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGestureRecognizer()
        if let tweet = tweet {
            let user = tweet.user
        if tweet.liked! {
            likeButton.setBackgroundImage(UIImage(named: "like-action-pressed"), forState: .Normal)
        }
        
        if tweet.retweeted! {
            retweetButton.setBackgroundImage(UIImage(named: "retweet-action-pressed"), forState: .Normal)
        }
        
        name.text = user?.name
        username.text = "@\(user!.screenName!)"
        profileImage.setImageWithURL(NSURL(string: user!.profileImageUrl!)!)
        content.text = tweet.text
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yy, HH:mm"
        time.text = formatter.stringFromDate(tweet.createAt!)
        
        if tweet.repostCount == 0 {
            repostCount.text = ""
        } else {
            repostCount.text = (tweet.repostCount?.description)! + " RETWEETS"
        }
        if tweet.likeCount == 0 {
            likeCount.text = ""
        } else {
            likeCount.text = (tweet.likeCount?.description)! + " LIKES"
        }
        }

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
