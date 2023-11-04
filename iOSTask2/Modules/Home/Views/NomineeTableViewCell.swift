//
//  NomineeTableViewCell.swift
//  iOSTask2
//
//  Created by ARBAZ on 31/10/2023.
//

import UIKit

class NomineeTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var reasonLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureData(name: String, reason: String) {
        self.nameLabel.text = name
        self.reasonLabel.text = reason
    }
    
}
