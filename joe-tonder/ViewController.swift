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
        
        let terminalCommand = PFObject(className: "terminalCommand")
        terminalCommand["command"] = "parse-dashboard --appId joeTonder --masterKey joeTonder --serverURL \"http://joe-tonder.herokuapp.com/parse\""
        
        terminalCommand.saveInBackground { (success, error) in
            print("Object has been saved")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

