//
//  matchTableViewCell.swift
//  joe-tonder
//
//  Created by Joe Sloan on 12/14/17.
//  Copyright © 2017 Joe Sloan. All rights reserved.
//

import UIKit

class matchTableViewCell: UITableViewCell {
    
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func sendTapped(_ sender: Any) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
