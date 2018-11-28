//
//  AttendanceCell.swift
//  MinutesTaker
//
//  Created by faisal khalid on 3/29/17.
//  Copyright © 2017 Sharjah Cooperative Society. All rights reserved.
//

import UIKit

class AttendanceCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var reason: UITextField!
    @IBOutlet weak var attendanceMarker: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
