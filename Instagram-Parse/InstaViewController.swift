//
//  InstaViewController.swift
//  Instagram-Parse
//
//  Created by ZengJintao on 2/23/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit
import Parse
import JTProgressHUD

class InstaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    
    let data = ["a", "b", "c", "d"]
    var mediaData:[PFObject]?
    
    let CellIdentifier = "TableViewCell", HeaderViewIdentifier = "TableViewHeaderView"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: HeaderViewIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 350
        
        self.navigationController?.navigationBar.translucent = false
        
        loadData()
    }
    
    func loadData() {
        // construct PFQuery
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        JTProgressHUD.showWithStyle(.Gradient)
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            
            self.mediaData = media
            print("find data \(self.mediaData)")
            JTProgressHUD.hide()
            self.tableView.reloadData()
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if mediaData == nil {
            return 0
        } else {
            return mediaData!.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InstaTableViewCell", forIndexPath: indexPath) as! InstaTableViewCell
        cell.commentLabel.text = mediaData![indexPath.section]["caption"] as? String
        let imgFile = mediaData![indexPath.section]["media"] as? PFFile
        imgFile?.getDataInBackgroundWithBlock({ (img:NSData?, error:NSError?) -> Void in
            cell.instaImage.image = UIImage(data: img!)
        })

        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier(HeaderViewIdentifier)! as UITableViewHeaderFooterView
        //header.textLabel!.text = data[section]
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 50))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
//                headerView.backgroundColor = UIColor.greenColor()
        
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        profileView.layer.backgroundColor = UIColor.grayColor().CGColor
        
        if let imgFile = mediaData![section]["author"]["avatar"] as? PFFile {
            imgFile.getDataInBackgroundWithBlock({ (img:NSData?, error:NSError?) -> Void in
                print("get")
                profileView.image = UIImage(data: img!)
            })
        }
        let goToProfileTap = UITapGestureRecognizer(target: self, action: "goToProfile:")
        profileView.addGestureRecognizer(goToProfileTap)
        profileView.userInteractionEnabled = true
        profileView.tag = section
        headerView.addSubview(profileView)
        
        // Add a UILabel for the username here
        let nameLabel = UILabel(frame: CGRect(x: 50, y: 0, width: UIScreen.mainScreen().bounds.width - 50, height: 50))
        let user = mediaData![section]["author"] as! PFUser
        nameLabel.text = user.username
        headerView.addSubview(nameLabel)
        
        let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width - 8, height: 50))
        timeLabel.textAlignment = .Right
        let time = mediaData![section].createdAt!
        let a = NSDate().offsetFrom(time)
        timeLabel.text = "\(a) ago"
        timeLabel.textColor = UIColor.darkGrayColor()
        timeLabel.font = timeLabel.font.fontWithSize(12)
        
        headerView.addSubview(timeLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func goToProfile(sender: UITapGestureRecognizer) {
        print(sender.view?.tag)
        let index = sender.view?.tag
        let detailView = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
        let user = mediaData![index!]["author"] as! PFUser
        detailView.username = user.username

        if let imgFile = mediaData![index!]["author"]["avatar"] as? PFFile {
            imgFile.getDataInBackgroundWithBlock({ (img:NSData?, error:NSError?) -> Void in
                print("get")
                detailView.avatar = UIImage(data: img!)
            })
        }
//        detailView.avatar = mediaData[index]
        self.navigationController?.pushViewController(detailView, animated: true)

//        print(sender.locationInView(self.tableView))
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

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
