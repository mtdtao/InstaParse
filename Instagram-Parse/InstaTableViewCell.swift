//
//  InstaTableViewCell.swift
//  Instagram-Parse
//
//  Created by ZengJintao on 2/23/16.
//  Copyright © 2016 ZengJintao. All rights reserved.
//

import UIKit

class InstaTableViewCell: UITableViewCell {

    @IBOutlet weak var instaImage: UIImageView!
    
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
