//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Madison Shimbo on 10/10/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    
    let myRefreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweets()
        
        // when user tries to pull down to refresh
        
        // target = where we want th action to happe
        // action = what we want to do
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl // telling table which refresh control to use
    }

    @objc func loadTweets() {
        numberOfTweet = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json" // url used to help get tweets from
        let myParams = ["count": numberOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: {
            (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll() // empties array of tweets just to clean up for this refresh
            for tweet in tweets { // add each tweet to our array of tweets to display
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData() // always make sure to reload data with content
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retrieve tweets!")
        })
    }
    
    // keeps adding sets of a number of tweets and essentially helps load more tweets
    func loadMoreTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet = numberOfTweet + 20
        let myParams = ["count": numberOfTweet]
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: {
            (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll() // empties array of tweets just to clean up for this refresh
            for tweet in tweets { // add each tweet to our array of tweets to display
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData() // always make sure to reload data with content
        }, failure: { (Error) in
            print("Could not retrieve tweets!")
        })
    }
    
    // if we are near end of set/page of tweets, we load more tweets automatically
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        // screen will dismiss/disappear itself
        self.dismiss(animated: true, completion: nil)
        
        // note that user logged out
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // identifier will be nickname of this Prototype Cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
     
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows (per section)
        return tweetArray.count
    }


}
