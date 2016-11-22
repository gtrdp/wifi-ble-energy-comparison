//
//  HistoryTableViewCell.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 25/05/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var sentPacketsLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
