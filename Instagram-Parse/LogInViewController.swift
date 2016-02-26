//
//  ViewController.swift
//  Instagram-Parse
//
//  Created by ZengJintao on 2/23/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("you have logged in")
                self.performSegueWithIdentifier("goToMainVC", sender: self)
            }
        }
    }
    
    
    @IBAction func signupPressed(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("success")
            } else {
                print(error?.localizedDescription)
                if error?.code == 202 {
                    print("user name is already taken")
                }
            }
        }
        
    }

}

