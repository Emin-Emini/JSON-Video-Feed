//
//  FeedTableViewCell.swift
//  JSON Video Feed
//
//  Created by Emin Emini on 11.6.21.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
