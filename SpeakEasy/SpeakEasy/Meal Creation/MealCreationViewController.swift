//
//  ViewController.swift
//  SpeakEasy: Restaurant
//
//  Created by Bryce Langlotz on 4/23/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class MealCreationViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var pointsTextField: UITextField!
    @IBOutlet var serverTextField: UITextField!
    @IBOutlet var QRCodeImageView: UIImageView!
    
    var mealObjectId: String!
    var QRCodeString: String!
    var pickerView:UIPickerView!
    var selectedServerObjectId:String!
    var serverQuery = PFQuery(className: "Servers")
    
    var servers = [PFObject]()
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if servers.count != 0 {
            selectedServerObjectId = servers[row].objectId
            var firstName = servers[row]["first_name"] as! String
            var lastName = servers[row]["last_name"] as! String
            var fullName = firstName + " " + lastName
            serverTextField.text = fullName
        }
        else {
            selectedServerObjectId = nil
            serverTextField.text = ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var firstName = servers[row]["first_name"] as! String
        var lastName = servers[row]["last_name"] as! String
        var fullName = firstName + " " + lastName
        return fullName
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return servers.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func settingsPressed(sender: AnyObject) {
        performSegueWithIdentifier("ShowRestaurantOptionsSegueIdentifier", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        
        serverTextField.inputView = pickerView
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "removeKeyboard:"))
        
        PFUser.logOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        reset()
        
        if let user = PFUser.currentUser() {
            PFUser.currentUser()?.isRestaurant({ (success, error) -> Void in
                if let error = error {
                    println(error.description)
                    self.performSegueWithIdentifier("ShowLogInSegueIdentifier", sender: self)
                }
            })
            serverQuery.whereKey("restaurant_objectId", equalTo: user.objectId!)
            serverQuery.findObjectsInBackgroundWithBlock { (results, error) -> Void in
                if let error = error {
                    println(error.localizedDescription)
                }
                else {
                    if let serversResults = results as? [PFObject] {
                        self.servers = serversResults
                        self.pickerView.reloadAllComponents()
                    }
                }
            }
        }
        else {
            performSegueWithIdentifier("ShowLogInSegueIdentifier", sender: self)
        }
    }
    
    func reset() {
        pointsTextField.text = ""
        serverTextField.text = ""
        
        mealObjectId = ""
        selectedServerObjectId = ""
        generateQRCode()
        UIView.animateWithDuration(0.2, animations: {
            self.QRCodeImageView.alpha = 0.05
        })
    }
    
    func sizeQRCodeView() {
        var frame = QRCodeImageView.frame
        var originDistanceFromBottom = self.view.bounds.size.height - frame.origin.y - (frame.origin.x)
        var originDistanceFromSide = self.view.bounds.size.width - frame.origin.x - (frame.origin.x)
        var sideLength = min(originDistanceFromBottom, originDistanceFromSide)
        frame.size = CGSizeMake(sideLength, sideLength)
        QRCodeImageView.frame = frame
    }
    
    @IBAction func logout(sender:AnyObject) {
        performSegueWithIdentifier("ShowLogInSegueIdentifier", sender: self)
    }
    
    @IBAction func generate(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: {
            self.QRCodeImageView.alpha = 1.0
        })
        
        var points = pointsTextField.text
        var server = serverTextField.text
        
        if points == "" || server == "" {
            showAlert("All fields are required.")
            reset()
        }
        else {
            var newMeal = PFObject(className: "Meals")
            newMeal["claimed"] = false
            newMeal["restaurant_objectId"] = PFUser.currentUser()?.objectId
            newMeal["claimed_by"] = ""
            newMeal["server_objectId"] = selectedServerObjectId
            newMeal["potential_reward"] = pointsTextField.text.toInt()!
            
            self.view.userInteractionEnabled = false
            
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "Creating Meal"
            
            newMeal.saveInBackgroundWithBlock { (success, error) -> Void in
                if success {
                    self.mealObjectId = newMeal.objectId!
                    self.generateQRCode()
                }
                if let error = error {
                    println(error.description)
                }
                hud.hide(true)
                self.view.userInteractionEnabled = true
            }
        }
    }
    
    func showAlert(message:String!) {
        var alertView = UIAlertView(title: message, message: nil, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    func generateQRCode() {
        var error:NSError?
        sizeQRCodeView()
        
        var writer:ZXMultiFormatWriter = ZXMultiFormatWriter()
        var restaurantCode = ""
        if let userObjectId = PFUser.currentUser()?.objectId {
            restaurantCode = userObjectId
        }
        QRCodeString = restaurantCode + " " + mealObjectId + " " + selectedServerObjectId + " " + pointsTextField.text
        var width:Int32 = Int32(QRCodeImageView.frame.size.width)
        var height:Int32 = Int32(QRCodeImageView.frame.size.height)
        var result = writer.encode(QRCodeString, format: kBarcodeFormatQRCode, width: width, height: height, error: &error)
        
        if let error = error {
            println(error.localizedDescription)
        }
        else {
            var image = UIImage(CGImage: ZXImage(matrix: result).cgimage)
            QRCodeImageView.image = image
        }
    }
    
    @IBAction func removeKeyboard(sender:AnyObject!) {
        pointsTextField.resignFirstResponder()
        serverTextField.resignFirstResponder()
    }
}

