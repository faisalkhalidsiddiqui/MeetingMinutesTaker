//
//  AgendaCell.swift
//  MinutesTaker
//
//  Created by faisal khalid on 4/2/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class ActionItemCell: UITableViewCell {

    @IBOutlet weak var editActionItemTitle: UITextView!

    @IBOutlet weak var saveEditedItem: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var actionItemTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
