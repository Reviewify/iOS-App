//
//  LoginViewController.swift
//  Reviewify MVP
//
//  Created by Bryce Langlotz on 4/9/15.
//  Copyright (c) 2015 Bryce Langlotz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var logInButton:UIButton!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var reenterPasswordTextField: UITextField!
    @IBOutlet var infoMessageView: ImportantInformationView!
    
    let LogoutText = "Logout"
    let LoginText = "Login with Facebook"
    let LoggingInText = "Logging In"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PFUser.logOut()
        
        self.reenterPasswordTextField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    @IBAction func textFieldDidChange(sender:AnyObject!) {
        if reenterPasswordTextField.text == "" {
            logInButton.setTitle("Login", forState: UIControlState.Normal)
        }
        else {
            logInButton.setTitle("Sign Up", forState: UIControlState.Normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func login(sender: AnyObject) {
        self.removeKeyboard(self)
        var lowercaseEmail = (self.emailTextField.text as NSString).lowercaseString
        if reenterPasswordTextField.text == "" {
            var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.mode = MBProgressHUDMode.Indeterminate
            hud.labelText = "Logging In"
            PFUser.logInWithUsernameInBackground(lowercaseEmail, password: self.passwordTextField.text, block: { (user, error) -> Void in
                if let error = error {
                    if error.code == 101 {
                        self.infoMessageView.actionLabel.text = "● Invalid login credentials"
                        self.infoMessageView.show()
                    }
                }
                else {
                    self.removeKeyboard(self)
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            })
        }
        else if self.reenterPasswordTextField.text == self.passwordTextField.text && self.passwordTextField.text != "" {
            if count(self.passwordTextField.text) < 5 || count(self.passwordTextField.text) > 16 {
                self.infoMessageView.actionLabel.text = "● Password must be 5-16 characters"
                self.infoMessageView.show()
            }
            else {
                var user = PFUser()
                user.username = lowercaseEmail
                user.password = self.passwordTextField.text
                user.email = user.username
                
                var hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Indeterminate
                hud.labelText = "Creating User"
                user.signUpInBackgroundWithBlock {
                    (succeeded, error) -> Void in
                    if error == nil {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    if let error = error {
                        if error.code == 202 || error.code == 203 {
                            self.infoMessageView.actionLabel.text = "● E-Mail is already registered"
                            
                            self.infoMessageView.show()
                        }
                        if error.code == 125 {
                            self.infoMessageView.actionLabel.text = "● Invalid E-Mail"
                            self.infoMessageView.show()
                        }
                    }
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
            }
        }
        if self.reenterPasswordTextField.text != "" && self.passwordTextField.text != self.reenterPasswordTextField.text {
            self.infoMessageView.actionLabel.text = "● Passwords don't match"
            self.infoMessageView.show()
        }
    }
    
    func showAlert(titles:String!, message:String!) {
        var alertView = UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    @IBAction func removeKeyboard(sender: AnyObject) {
        self.view.endEditing(false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
