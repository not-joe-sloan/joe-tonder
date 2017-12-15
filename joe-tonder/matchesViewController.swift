//
//  matchesViewController.swift
//  joe-tonder
//
//  Created by Joe Sloan on 12/13/17.
//  Copyright © 2017 Joe Sloan. All rights reserved.
//

import UIKit
import Parse

class matchesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var matchImages: [UIImage] = []
    var userIds: [String] = []
    var messages: [String] = []
    
    @IBOutlet var tableView: UITableView!
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            
            if let acceptedPeeps = PFUser.current()?["accepted"] as? [String]{
                query.whereKey("objectId", containedIn: acceptedPeeps)
                query.findObjectsInBackground(block: { (objects, error) in
                    if let users = objects {
                        for user in users {
                            if let theUser = user as? PFUser {
                                if let imageFile = theUser["Photo"] as? PFFile {
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if let imageData = data {
                                            print("There's data")
                                            
                                            if let objectId = theUser.objectId {
                                                
                                                let messagesQuery = PFQuery(className: "Message")
                                                
                                                messagesQuery.whereKey("recipient", equalTo: PFUser.current()?.objectId as Any)
                                                messagesQuery.whereKey("sender", equalTo: theUser.objectId as Any)
                                                messagesQuery.findObjectsInBackground(block: { (objects, error) in
                                                    var messageText = "She aint interested, broh."
                                                    if let messages = objects {
                                                        for message in messages {
                                                            if let content = message["content"] as? String{
                                                                messageText = content
                                                                
                                                            }
                                                        }
                                                    }
                                                    self.matchImages.append(UIImage(data: imageData)!)
                                                    self.userIds.append(objectId)
                                                    self.messages.append(messageText)
                                                    self.tableView.reloadData()
                                                })
                                                
                                                
                                            }
                                            
                                        }
                                    })
                                }
                            }
                        }
                    }
                })
            }
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchImages.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? matchTableViewCell{
            
            cell.messageLabel.text = "No sexy messages for U, loner.  You'll never get laid."
            cell.profileImageView.image = matchImages[indexPath.row]
            cell.recipientObjectId = userIds[indexPath.row]
            cell.messageLabel.text = messages[indexPath.row]
            
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
