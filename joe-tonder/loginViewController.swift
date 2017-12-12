//
//  loginViewController.swift
//  joe-tonder
//
//  Created by Joe Sloan on 12/11/17.
//  Copyright © 2017 Joe Sloan. All rights reserved.
//

import UIKit
import Parse

class loginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var passTextField: UITextField!
    @IBOutlet var loginSignupButton: UIButton!
    @IBOutlet var changeLoginSignupButton: UIButton!
    
    var signupMode = false
    
    
    func displayAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func loginSignupTapped(_ sender: Any) {
        if signupMode{
            
            let user = PFUser()
            
            if nameTextField.text != "" && emailTextField.text != "" && passTextField.text != "" {
                user.username = nameTextField.text
                user.email = emailTextField.text
                user.password = passTextField.text
                
                user.signUpInBackground(block: { (success, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                        var errorMessage = "Signup Failed, try again."
                        
                        if let newError = error as NSError?{
                            if let detailError = newError.userInfo["error"] as? String{
                                errorMessage = detailError
                            }
                        }
                    }else{
                        print("Signup Successful")
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        
                    }
                })
            }else{
                self.displayAlert(title: "Incomplete Form", message: "All fields are required")
            }
        }else{
            
            if let username = nameTextField.text{
                if let password = passTextField.text {
                    PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
                        //self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                        if error != nil{
                            print(error?.localizedDescription)
                        }else{
                            self.performSegue(withIdentifier: "loginSegue", sender: nil)
                        }
                    })
                }
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    @IBAction func changeLoginSignUpTapped(_ sender: Any) {
        
        if signupMode{
            
            loginSignupButton.setTitle("Log In", for: .normal)
            changeLoginSignupButton.setTitle("Sign Up", for: .normal)
            emailTextField.alpha = 0
            emailTextField.isEnabled = false
            signupMode = false
            
            let user = PFUser()
            
            if nameTextField.text != "" && emailTextField.text != "" && passTextField.text != "" {
                user.username = nameTextField.text
                user.email = emailTextField.text
                user.password = passTextField.text
            }else{
                displayAlert(title: "Incomplete Form", message: "All fields are required")
            }
            
            
            
            
        }else{
            loginSignupButton.setTitle("Sign Up", for: .normal)
            changeLoginSignupButton.setTitle("Log In", for: .normal)
            emailTextField.isEnabled = true
            emailTextField.alpha = 1
            signupMode = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.alpha = 0
        emailTextField.isEnabled = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
