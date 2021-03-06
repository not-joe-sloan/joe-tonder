//
//  ViewController.swift
//  joe-tonder
//
//  Created by Joe Sloan on 12/10/17.
//  Copyright © 2017 Joe Sloan. All rights reserved.
//

import UIKit
import Parse


class ViewController: UIViewController {
    
    var displayUserID = ""

    
    @IBOutlet var matchImageView: UIImageView!
    
    
    @IBAction func updateProfilePressed(_ sender: Any) {
    }
    @IBAction func logoutPressed(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logOutFromCards", sender: nil)
    }
    
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer){
        
        let labelPoint = gestureRecognizer.translation(in: view)
        matchImageView.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width/2 - matchImageView.center.x
        
        let rotation = CGAffineTransform(rotationAngle: -(xFromCenter/400))
        var scaledAndRotated = rotation.scaledBy(x: 1 + xFromCenter/700, y: 1 + xFromCenter/700)
        
        
        if xFromCenter > 0 {
            scaledAndRotated = rotation.scaledBy(x: 1 - xFromCenter/900, y: 1 - xFromCenter/900)
        }else{
            scaledAndRotated = rotation.scaledBy(x: 1 + xFromCenter/900, y: 1 + xFromCenter/900)
        }
        
        
        let resetRotation = CGAffineTransform(rotationAngle: 0)
        
        let resetAll = resetRotation.scaledBy(x: 1, y: 1)
        
        matchImageView.transform = scaledAndRotated
        
        if gestureRecognizer.state == .ended{
            
            var acceptedOrRejected = ""
            
            if matchImageView.center.x < view.bounds.width/2 - 100 {
                print("Not Interested")
                acceptedOrRejected = "rejected"
            }
            
            if matchImageView.center.x > view.bounds.width/2 + 100 {
                print("Interested")
                acceptedOrRejected = "accepted"
            }
            
            if acceptedOrRejected != "" && displayUserID != ""{
                PFUser.current()?.addUniqueObject(displayUserID, forKey: acceptedOrRejected)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success{
                        print("imageUpdated")
                        self.updateImage()
                    }
                })
                
                
            }
            
            
            
            
            matchImageView.center = self.view.center
            matchImageView.transform = resetAll
            
        }
        
    }
    
    func updateImage() {
        
        if let query = PFUser.query(){
            if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"]{
                query.whereKey("isFemale", equalTo: isInterestedInWomen)
            }
            
            if let isFemale = PFUser.current()?["isFemale"]{
                query.whereKey("isInterestedInWomen", equalTo: isFemale)
            }
            
            var ignoredUsers: [String] = []
            
            if let acceptedUsers = PFUser.current()?["accepted"] as? [String]{
                ignoredUsers += acceptedUsers
            }
            
            if let rejectedUsers = PFUser.current()?["rejected"] as? [String]{
                ignoredUsers += rejectedUsers
            }
            
            query.whereKey("objectId", notContainedIn: ignoredUsers)
            
            
            
            if let geoPoint = PFUser.current()?["location"] as? PFGeoPoint{
                query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: geoPoint.latitude - 1, longitude: geoPoint.longitude - 1), toNortheast: PFGeoPoint(latitude: geoPoint.latitude + 1, longitude: geoPoint.longitude + 1))
            }
            
            
            
            
            query.limit = 1
            
            query.findObjectsInBackground { (objects, error) in
                if let users = objects {
                    print("I found some objects")
                    for object in users{
                        if let user = object as? PFUser{
                            if let imageFile = user["Photo"] as? PFFile{
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if let image = data {
                                        print("There was image data for \(PFUser.current()?.objectId)")
                                        self.matchImageView.image = UIImage(data: image)
                                        if let objectID = object.objectId {
                                            self.displayUserID = objectID
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            if let point = geoPoint{
                PFUser.current()?["location"] = point
                PFUser.current()?.saveInBackground()
            }
        }
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer: )))
        matchImageView.addGestureRecognizer(gesture)
        
        updateImage()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    



}

