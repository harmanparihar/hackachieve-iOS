//
//  SignUpViewController.swift
//  hackachieve-ios-v2
//
//  Created by Harmanpreet Kaur on 07/03/19.
//  Copyright © 2019 Harmanpreet Kaur. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-background-android.png")!)
    }
    @IBAction func SIGNUP_ButtonTapped(_ sender: Any) {
        print(firstNameTextField.text!)
        print(lastNameTextField.text!)
        print(emailTextField.text!)
        print(passwordTextField.text!)
        let myURL = NSURL(string: "https://hackachieve.com:8000/user/register/")
        var request = URLRequest(url: myURL! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let postString = "{\"firstName\":\"\(firstNameTextField.text!)\",\"lastName\":\"\(lastNameTextField.text!)\",\"email\":\"\(emailTextField.text!)\",\"password\":\"\(passwordTextField.text!)\"}"
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }
            
            // You can print out response object
            print("response = \(String(describing: response))")
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
        task.resume()
        
    }
   
    @IBAction func LOGIN_ButtonTapped(_ sender: Any) {
        print("Hello Login")
        performSegue(withIdentifier: "loginSegue", sender: self)
    }

}
