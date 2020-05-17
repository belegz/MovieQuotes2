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
import Rosefire

class LoginViewController: UIViewController{
    let ShowListSegueIdentifier = "ShowListSegue"
    let REGISTRY_TOKEN = "4689fdc5-88ef-4cc5-93b8-96c7784cbcc7" // DONE go visit rosefire.csse.rose-hulman.edu to generate this
    
    
    @IBOutlet weak var emailTestField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTestField.placeholder = "Email"
        passwordTextField.placeholder = "Password"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            print("Someone is already signed in. Move on!")
            self.performSegue(withIdentifier: self.ShowListSegueIdentifier, sender: self)
        }
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
            print("Email: \(authResult!.user.email)  UID: \(authResult!.user.uid)")
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
            print("Email: \(authResult!.user.email)  UID: \(authResult!.user.uid)")
            self.performSegue(withIdentifier: self.ShowListSegueIdentifier, sender: self)
        }
    }
    
    @IBAction func pressedRoseFireLogin(_ sender: Any) {
//        print("TODO: Use RoseFire")
        Rosefire.sharedDelegate().uiDelegate = self // This should be your view controller
        Rosefire.sharedDelegate().signIn(registryToken: REGISTRY_TOKEN) { (err, result) in
          if let err = err {
            print("Rosefire sign in error! \(err)")
            return
          }
          print("Result = \(result!.token!)")
          print("Result = \(result!.username!)")
          print("Result = \(result!.name!)")
          print("Result = \(result!.email!)")
          print("Result = \(result!.group!)")
            
//          Auth.auth().signIn(withCustomToken: result!.token) { (authResult, error) in
//            if let error = error {
//              print("Firebase sign in error! \(error)")
//              return
//            }
//            // User is signed in using Firebase!
//            self.performSegue(withIdentifier: self.ShowListSegueIdentifier, sender: self)
//          }
        }

    }
    
}
