//
//  matchTableViewCell.swift
//  joe-tonder
//
//  Created by Joe Sloan on 12/14/17.
//  Copyright © 2017 Joe Sloan. All rights reserved.
//

import UIKit
import Parse

class matchTableViewCell: UITableViewCell {
    
    var recipientObjectId = String()
    
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func sendTapped(_ sender: Any) {
        if messageTextField.text != "" && messageTextField.text != nil{
            let message = PFObject(className: "Message")
            message["sender"] = PFUser.current()?.objectId
            message["recipient"] = recipientObjectId
            message["content"] = messageTextField.text
            
            message.saveInBackground()
            messageLabel.text = messageTextField.text
            messageTextField.text = ""
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
