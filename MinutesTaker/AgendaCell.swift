//
//  AgendaCell.swift
//  MinutesTaker
//
//  Created by faisal khalid on 4/2/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class AgendaCell: UITableViewCell {

    @IBOutlet weak var editParticipants: UITextField!

    @IBOutlet weak var editAgendaTitle: UITextView!

    @IBOutlet weak var saveEditedItem: UIButton!
    @IBOutlet weak var edit: UIButton!
    @IBOutlet weak var participants: UILabel!
    @IBOutlet weak var agendaTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
