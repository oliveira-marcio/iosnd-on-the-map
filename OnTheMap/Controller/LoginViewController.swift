//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 9/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: CustomButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    enum LoginFields: Int {
        case username, password
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.tag = LoginFields.username.rawValue
        self.emailTextField.delegate = self

        self.passwordTextField.tag = LoginFields.password.rawValue
        self.passwordTextField.delegate = self
        
        self.logInButton.isEnabled = false
    }
    
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
        self.setLoggingIn(false)
        if success {
            performSegue(withIdentifier: "completeLogin", sender: nil)
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
        } else {
            self.showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if let udacitySignUpURL = URL(string: "https://auth.udacity.com/sign-up") {
            UIApplication.shared.open(udacitySignUpURL)
        }
    }
    
    private func setLoggingIn(_ loggingIn: Bool) {
        self.emailTextField.isEnabled = !loggingIn
        self.passwordTextField.isEnabled = !loggingIn
        self.logInButton.isEnabled = !loggingIn
        loggingIn ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
    }
    
    private func showLoginFailure(message: String) {
        let alert = UIAlertController(title: "Authentication Failed", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
