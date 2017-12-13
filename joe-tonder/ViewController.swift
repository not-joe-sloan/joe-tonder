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

    @IBOutlet var swipeLabel: UILabel!
    
    @IBAction func updateProfilePressed(_ sender: Any) {
        performSegue(withIdentifier: "goToUpdateView", sender: nil)
    }
    @IBAction func logoutPressed(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logOutFromCards", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer: )))
        swipeLabel.addGestureRecognizer(gesture)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer){
        let labelPoint = gestureRecognizer.translation(in: view)
        swipeLabel.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width/2 - swipeLabel.center.x
        
        let rotation = CGAffineTransform(rotationAngle: -(xFromCenter/400))
        var scaledAndRotated = rotation.scaledBy(x: 1 + xFromCenter/700, y: 1 + xFromCenter/700)

        
        if xFromCenter > 0 {
            scaledAndRotated = rotation.scaledBy(x: 1 - xFromCenter/900, y: 1 - xFromCenter/900)
        }else{
            scaledAndRotated = rotation.scaledBy(x: 1 + xFromCenter/900, y: 1 + xFromCenter/900)
        }
        
        
        let resetRotation = CGAffineTransform(rotationAngle: 0)
        
        let resetAll = resetRotation.scaledBy(x: 1, y: 1)
        
        swipeLabel.transform = scaledAndRotated
        
        if gestureRecognizer.state == .ended{
            if swipeLabel.center.x < view.bounds.width/2 - 100 {
                print("Not Interested")
            }
            
            if swipeLabel.center.x > view.bounds.width/2 + 100 {
                print("Interested")
            }
            
            swipeLabel.center = self.view.center
            swipeLabel.transform = resetAll
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

