//
//  UserProfileViewController.swift
//  Instagram-Parse
//
//  Created by ZengJintao on 2/26/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var avartarImgView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var avatar:UIImage?
    var username:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        avartarImgView.clipsToBounds = true
        avartarImgView.layer.cornerRadius = 5;

        if avatar != nil {
            avartarImgView.image = avatar
        }
        usernameLabel.text = username
        
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
