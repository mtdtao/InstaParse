//
//  CaptureViewController.swift
//  Instagram-Parse
//
//  Created by ZengJintao on 2/25/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import JTProgressHUD

class CaptureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var captureImageView: UIImageView!
    @IBOutlet weak var takePhotoLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let openPhotoTap = UITapGestureRecognizer(target: self, action: "openFromGallary")
        captureImageView.addGestureRecognizer(openPhotoTap)
        captureImageView.userInteractionEnabled = true
        captureImageView.clipsToBounds = true
        captureImageView.layer.cornerRadius = 15;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openFromGallary() {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func sendPressed(sender: UIButton) {
        if captureImageView.image != nil {
            JTProgressHUD.showWithStyle(.Gradient)
            UserMedia.postUserImage(captureImageView.image, withCaption: commentTextField.text) { (success:Bool, error:NSError?) -> Void in
                if success {
                    print("success post")
                    self.captureImageView.image = nil
                    self.takePhotoLabel.text = "Take a photo"
                    self.commentTextField.text = ""
                    let a = self.tabBarController?.viewControllers![0] as! UINavigationController
                    let b = a.viewControllers[0] as! InstaViewController
                    b.loadData()
                    self.tabBarController?.selectedIndex = 0
                }
                JTProgressHUD.hide()
            }
        } else {
            print("no pic")
            JTProgressHUD.hide()

        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(false, completion: nil)
        captureImageView.image = image
        takePhotoLabel.text = ""
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
