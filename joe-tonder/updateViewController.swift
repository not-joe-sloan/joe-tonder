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
    
    func createWomen(){
        let imageUrls = ["https://vignette.wikia.nocookie.net/simpsons/images/b/b0/Woman_resembling_Homer.png/revision/latest/scale-to-width-down/700?cb=20141026204206", "https://static.comicvine.com/uploads/scale_small/8/80778/2054878-judge_constance_harm.png", "https://vignette.wikia.nocookie.net/simpsons/images/d/df/Shauna_Chalmers_Tapped_out.png/revision/latest?cb=20150802232912", "https://upload.wikimedia.org/wikipedia/en/0/0b/Marge_Simpson.png"]
        var counter = 0
        
        
        for imageURL in imageUrls{
            let url = URL(string: imageURL)
            if let data = try? Data(contentsOf: url!){
                let imageFile = PFFile(name: "photo.png", data: data)
                let user = PFUser()
                user["photo"] = imageFile
                user.username =  String(counter)
                user.password = "Pass"
                user["isFemale"] = true
                user["isInterestedInWomen"] = false
                
                user.signUpInBackground(block: { (success, error) in
                    if success {
                        print("Woman user created")
                    }
                })
                
                counter += 1
            }
        }
    }
    
    
    
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
        

        if let isFemale = PFUser.current()!["isFemale"] as? Bool{
            genderSwitch.setOn(isFemale, animated: false)
        }
        
        if let isInterestedInWomen = PFUser.current()!["isInterestedInWomen"] as? Bool{
            interestSwitch.setOn(isInterestedInWomen, animated: false)
        }
        
        if let photo = PFUser.current()!["Photo"] as? PFFile {
            photo.getDataInBackground(block: { (data, error) in
                if error != nil {
                    self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                    
                }else{
                    if let image = UIImage(data: data!){
                        self.profileImageView.image = image
                    }
                }
            })
        }
        
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
