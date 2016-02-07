//
//  Tweet.swift
//  Twitter
//
//  Created by Carl Chen on 2/6/16.
//  Copyright © 2016 frostao. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createAt: NSDate?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createAt = formatter.dateFromString(createdAtString!)
    }
    
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
            
        }
        
        return tweets
    }
}
