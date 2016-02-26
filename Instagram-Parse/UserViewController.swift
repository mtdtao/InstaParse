//
//  UserViewController.swift
//  Instagram-Parse
//
//  Created by ZengJintao on 2/23/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import Parse

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var avatarChanged:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.enabled = false
        avatarChanged = false
        
        let openPhotoTap = UITapGestureRecognizer(target: self, action: "openFromGallary")
        userAvatar.addGestureRecognizer(openPhotoTap)
        userAvatar.userInteractionEnabled = true
        userAvatar.clipsToBounds = true
        userAvatar.layer.cornerRadius = 5;
        if let imgFile = PFUser.currentUser()!["avatar"] as? PFFile {
            imgFile.getDataInBackgroundWithBlock({ (img:NSData?, error:NSError?) -> Void in
                print("get")
                self.userAvatar.image = UIImage(data: img!)
            })
        }
        
        usernameLabel.text = PFUser.currentUser()?.username
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        PFUser.logOut()
        let loginView = self.storyboard?.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        self.presentViewController(loginView, animated: true, completion: nil)
    }
    

    @IBAction func usernameChanged(sender: UITextField) {
        if sender.text == PFUser.currentUser()?.username {
            saveButton.enabled = false
        } else {
            saveButton.enabled = true
        }
    }
    
    
    
    @IBAction func saveButtonPressed(sender: UIButton) {
//        saveButton.enabled = false
        PFUser.currentUser()?.username = usernameLabel.text
        if userAvatar.image != nil && avatarChanged == true {
            PFUser.currentUser()?["avatar"] = UserMedia.getPFFileFromImage(userAvatar.image)
        }
        PFUser.currentUser()?.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
            
        })
    }
    
    func openFromGallary() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(false, completion: nil)
        userAvatar.image = image
        saveButton.enabled = true
        avatarChanged = true
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
