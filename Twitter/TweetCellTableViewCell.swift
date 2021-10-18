//
//  TweetCellTableViewCell.swift
//  Twitter
//
//  Created by Madison Shimbo on 10/10/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class TweetCellTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!

    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    @IBAction func retweet(_ sender: Any) {
    }
    
    var favorited:Bool = false
    var tweetId:Int = -1 // negative number means not set
    
    @IBAction func favoriteTweet(_ sender: Any) {
        // if we tap on favorite button it should toggle
        // > if favorited -> unfavorite; if unfavorited -> favorite
        let toBeFavorited = !favorited
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(isFavorited:true)
            }, failure: { (error) in
                print("Favorite did not succeed: \(error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.setFavorite(isFavorited:false)
            }, failure: { (error) in
                print("Unfavorite did not succeed: \(error)")
            })
        }
    }
    

    func setFavorite( isFavorited:Bool) {
        favorited = isFavorited
        if(favorited) {
            favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else { // set to gray button
            favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
