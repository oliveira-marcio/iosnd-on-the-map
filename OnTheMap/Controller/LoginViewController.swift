//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 9/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: CustomButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: Any) {
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
         if let udacitySignUpURL = URL(string: "https://auth.udacity.com/sign-up") {
            UIApplication.shared.open(udacitySignUpURL)
        }
    }
}
