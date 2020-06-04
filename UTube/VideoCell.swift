//
//  VideoCell.swift
//  UTube
//
//  Created by Eyad Heikal on 6/4/20.
//  Copyright © 2020 Eyad Heikal. All rights reserved.
//

import UIKit

class VideoCell: UITableViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    
    @IBOutlet weak var chanalImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        chanalImage.layer.masksToBounds = true

        chanalImage.layer.cornerRadius = 35
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
