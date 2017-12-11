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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let object = PFObject(className: "Testing")
        object["Foo"] = "Bar"
        
        object.saveInBackground { (success, error) in
            print("Object as been saved")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

