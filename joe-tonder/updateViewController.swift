//
//  updateViewController.swift
//  
//
//  Created by Joe Sloan on 12/11/17.
//

import UIKit
import Parse

class updateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var genderSwitch: UISwitch!
    @IBOutlet var interestSwitch: UISwitch!
    
    @IBAction func updateImagePressed(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func displayAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Pull image out of the info dictionary
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            profileImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateProfilePressed(_ sender: Any) {
        
        PFUser.current()?["isFemale"] = genderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestSwitch.isOn
        
        if let image = profileImageView.image{
            if let imageData = UIImagePNGRepresentation(image){
                PFUser.current()?["Photo"] = PFFile(name: "Profile.png", data: imageData)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                        var errorMessage = "Signup Failed, try again."
                        
                        if let newError = error as NSError?{
                            if let detailError = newError.userInfo["error"] as? String{
                                errorMessage = detailError
                            }
                        }
                    }else{
                        print("Update Successful")
                    }
                })
            }
            
        }
        
        
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
