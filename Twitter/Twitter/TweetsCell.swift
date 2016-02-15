//
//  TweetsCell.swift
//  Twitter
//
//  Created by Carl Chen on 2/7/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit
import IDMPhotoBrowser

class TweetsCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var repostCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    
    var tweet: Tweet?
    var viewController: UIViewController?
    
    override func awakeFromNib() {
        loadGestureRecognizer()
    }
    func loadGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "profileTapped")
        profileImage.addGestureRecognizer(gestureRecognizer)
    }
    
    func profileTapped() {
        
        let photoURL = tweet?.user?.profileImageUrl?.stringByReplacingOccurrencesOfString("_normal", withString: "")
        let photo = IDMPhoto(URL: NSURL(string: photoURL!))
        let browser = IDMPhotoBrowser(photos: [photo], animatedFromView: nil)
        browser.displayDoneButton = false
        viewController?.presentViewController(browser, animated: true, completion: nil)
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

    

}
