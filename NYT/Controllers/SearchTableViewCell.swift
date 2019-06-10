//
//  SearchTableViewCell.swift
//  NYT
//
//  Created by Rahul Dange on 4/11/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    // -- Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
