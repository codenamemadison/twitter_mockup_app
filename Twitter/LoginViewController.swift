//
//  LoginViewController.swift
//  Twitter
//
//  Created by Madison Shimbo on 10/10/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // once page shows up, this is what it does
    override func viewDidAppear(_ animated: Bool) {
        // check user default to see if user is already logged in
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    @IBAction func onLoginButton(_ sender: Any) {
        let myUrl = "https://api.twitter.com/oauth/request_token"
        // url dictates where api will call api call; url is like a phone number we call to request data at (api call)
        TwitterAPICaller.client?.login(url: myUrl, success: {
            // what to do if login is successful
            
            // storing variable that indicates user has logged in named userLoggedIn - this is so that next time user logs in the code will check this variable first
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self) // sender = who this transition is coming from
        }, failure: { Error in
            print("Could not log in!")
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
