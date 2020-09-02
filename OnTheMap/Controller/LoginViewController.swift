//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 9/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets and global variables

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: CustomButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    enum LoginFields: Int {
        case username, password
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.tag = LoginFields.username.rawValue
        self.emailTextField.delegate = self

        self.passwordTextField.tag = LoginFields.password.rawValue
        self.passwordTextField.delegate = self
        
        self.logInButton.isEnabled = false
    }
    
    // MARK: - Text Fields Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        var secondField = ""
        
        switch textField.tag {
        case LoginFields.username.rawValue:
            secondField = self.passwordTextField?.text ?? ""
        case LoginFields.password.rawValue:
            secondField = self.emailTextField?.text ?? ""
        default:
            return true
        }
        
        self.logInButton.isEnabled = newText.length > 0 && !secondField.isEmpty
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Log In and Handlers

    @IBAction func login(_ sender: Any) {
        guard
            let username = self.emailTextField.text, !username.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty
            else {
                return
        }
        self.setLoggingIn(true)
        GatewayFactory.shared.login(username: username, password: password, completion: handleSessionResponse(success:error:))
    }
    
    private func handleSessionResponse(success: Bool, error: Error?) {
        if success {
            GatewayFactory.shared.fetchUserData(completion: handleUserDataResponse(success:error:))
        } else {
            self.setLoggingIn(false)
            ErrorUtils.showError(from: self, title: AuthenticationErrors.title, message: error?.localizedDescription ?? "")
        }
    }
    
    private func handleUserDataResponse(success: Bool, error: Error?) {
        self.setLoggingIn(false)
        if success {
            performSegue(withIdentifier: "completeLogin", sender: nil)
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
        } else {
            ErrorUtils.showError(from: self, title: AuthenticationErrors.title, message: AuthenticationErrors.unknownError)
        }
    }
    
    private func setLoggingIn(_ loggingIn: Bool) {
        self.emailTextField.isEnabled = !loggingIn
        self.passwordTextField.isEnabled = !loggingIn
        self.logInButton.isEnabled = !loggingIn
        loggingIn ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
    }

    // MARK: - Sign Up

    @IBAction func signUp(_ sender: Any) {
        if let udacitySignUpURL = URL(string: "https://auth.udacity.com/sign-up") {
            UIApplication.shared.open(udacitySignUpURL)
        }
    }
}
