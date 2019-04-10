//
//  LoginViewController.swift
//  hackachieve-ios-v2
//
//  Created by Harmanpreet Kaur on 07/03/19.
//  Copyright © 2019 Harmanpreet Kaur. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
class LoginViewController: UIViewController {

    var access_token: String!
    var board_get: [[String : Any]] = [[:]]
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern-background-android.png")!)
        let retrievedToken: String? = KeychainWrapper.standard.string(forKey: "token")
        if(retrievedToken != nil){
            print("Retrieved token is: \(retrievedToken!)")
            load_board(access_token : retrievedToken!)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "boardSegue"){
            let dvc = segue.destination as! BoardViewController
            dvc.boards = board_get
        }
    }
    @IBAction func signupButtonTapped(_ sender: Any) {
        print("Signup button tapped")
        performSegue(withIdentifier: "signupSegue", sender: self)
    }
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        print(passwordTextField.text!)
        print(usernameTextField.text!)
        
        //create activity indicator
        let myActivityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: self.view.frame.size.width, height: self.view.frame.size.height))
//        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        //position activity indicator in the center
        myActivityIndicator.center = view.center
        
        myActivityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        
        //If needed, you can prevent activity indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        myActivityIndicator.backgroundColor = (UIColor(white: 0.0, alpha: 0.8))
        myActivityIndicator.layer.cornerRadius = 5
        
        //start activity indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        let myURL = NSURL(string: "https://hackachieve.com:8000/api/token/")
        
        var request = URLRequest(url: myURL! as URL)
        request.httpMethod = "POST"
        request.addValue("Basic Og==", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "email=\(usernameTextField.text!)&password=\(passwordTextField.text!)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8);
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil
            {
                print("error=\(error!)")
                return
            }
            
            // You can print out response object
            print("response = \(String(describing: response))")
            
            let httpResponse = response as! HTTPURLResponse
            print("\(String(httpResponse.statusCode))")
            let strongSelf = self
            
                        //Let's convert response sent from a server side script to a NSDictionary object:
                        do {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                            print(json!)
                            
                            //checking if response is 200 OK before performing boardSegue
                            if(httpResponse.statusCode == 200){
                                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                                DispatchQueue.main.async {
                                    if(json!["access"] != nil){
                                        print(json!["access"]!)
                                        strongSelf.access_token = json!["access"]! as! String
                                        let saveSuccessful: Bool = KeychainWrapper.standard.set(strongSelf.access_token , forKey: "token")
                                        print("Token was saved : \(saveSuccessful)")
                                    }
                                    strongSelf.load_board(access_token : strongSelf.access_token!)
                                }
                                
                            }
                        } catch {
                            print(error)
                        }
        }
        task.resume()
        
    }
    
    //Fetching data from the server for user using access token
    func load_board(access_token : String!){
        let myURL = NSURL(string: "https://hackachieve.com:8000/boards/show/0/all")
        
        var request = URLRequest(url: myURL! as URL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(access_token!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil
            {
                print("error=\(String(describing: error))")
                return
            }
            
            // You can print out response object
            print("response = \(String(describing: response))")
            let httpResponse = response as! HTTPURLResponse
            print("\(String(httpResponse.statusCode))")
            
            //Let's convert response sent from a server side script to a NSDictionary object:
            guard let data = data, error == nil else { return }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]
                let posts = json
                
                print("\(self.board_get)!")
                for tempObject in (posts!)  {
                    print("\(tempObject)")
                    self.board_get.append(tempObject)
                }
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "boardSegue", sender: self)
                }
                
            } catch let error as NSError {
                print(error)
            }
        }
        task.resume()
    }
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async
            {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
        }
    }
    
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }
        
        
        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }
        
        return borders
    }
}
