//
//  LoginViewController.swift
//  MovieQuotes2
//
//  Created by Tinuviel on 2020/5/16.
//  Copyright © 2020 Tinuviel. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController{
    let ShowListSegueIdentifier = "ShowListSegue"
    
    
    @IBOutlet weak var emailTestField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTestField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
    }
    
    @IBAction func pressedSignInNewUser(_ sender: Any) {
        let email = emailTestField.text!
        let password = passwordTextField.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error creating a new user for Email/Password \(error)")
                return
            }
            
            print("It worked! A new user is created and now signed in!")
            print("Email: \(authResult?.user.email)  UID: \(authResult!.user.uid)")
            self.performSegue(withIdentifier: self.ShowListSegueIdentifier, sender: self)
        }
    }
    
    @IBAction func pressedLoginExistingUser(_ sender: Any) {
        let email = emailTestField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error logging in an existing user for Email/Password \(error)")
                return
            }
            
            print("It worked! An existing user is now signed in!")
            print("Email: \(authResult?.user.email)  UID: \(authResult!.user.uid)")
            self.performSegue(withIdentifier: self.ShowListSegueIdentifier, sender: self)
        }
    }
}
