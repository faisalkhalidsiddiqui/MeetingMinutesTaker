//
//  ViewController.swift
//  GoogleCloudPrint
//
//  Created by faisal khalid on 30/03/2017.
//  Copyright © 2017 faisal khalid. All rights reserved.
//

import UIKit
import GoogleSignIn
class PrinterViewController: UIViewController,GIDSignInUIDelegate,GIDSignInDelegate,UITableViewDelegate,UITableViewDataSource {
    public var content:String?
    @IBOutlet weak var printerTableView: UITableView!
    var printers:[Printer]?
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var cloudPrinter:CloudPrinter?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        GIDSignIn.sharedInstance().delegate  = self
        
       GIDSignIn.sharedInstance().uiDelegate = self
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        NetworkReachability.isNetworkConnected(){ error,data in
            
            if let error = error {
                print("error")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                

                let controller = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default){ action in
                
                self.dismiss(animated: false, completion: nil)
                }
                controller.addAction(ok)
                DispatchQueue.main.async {
                    self.present(controller, animated: false, completion: nil)
                }
                
            }
            if let data = data {

                let cloudPrint = NSString(string: "https://www.googleapis.com/auth/cloudprint")
                  DispatchQueue.main.async {
                    
                    GIDSignIn.sharedInstance().scopes.append(cloudPrint)
                  GIDSignIn.sharedInstance().signInSilently()
            
                    
                }
            
                
                
                
            }
        
        }

       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let printers = printers {
        return printers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.font = cell.textLabel?.font.withSize(15.0)
        cell.imageView?.image = UIImage(named: "print_icon")
    cell.selectionStyle = .none
         cell.textLabel?.text = ""
        if let printers = printers {
        cell.textLabel?.text = printers[indexPath.row].name + " -   " + printers[indexPath.row].status
        }
       
        return cell
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil {
            DispatchQueue.main.async {
                 self.mainView.isHidden = false
            }
           
            print("already logged in")
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
        
            
            
            let token = user.authentication.accessToken
             cloudPrinter = CloudPrinter(token: token!)
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
           
            cloudPrinter?.getPrinters { error, printers in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()

                }

                if let error = error {

                self.displayMessage(message: "error in getting printer")
                    return
                }
                
                self.printers = printers
                
                
                DispatchQueue.main.async {
                    
                    self.printerTableView.reloadData()
                }
                
            
            }
        }
        else {
            
            DispatchQueue.main.async {
                self.mainView.isHidden = true
            }
            
            print("not sign in")

            DispatchQueue.main.async {
                
                GIDSignIn.sharedInstance().signIn()
            }
        }
    }
    
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        //This line does the trick to fix signin web not showing issue
        viewController.view.layoutIfNeeded()
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(printers?[indexPath.row])
        print(cloudPrinter?.xsrf)
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        cloudPrinter?.submitJob(printerID:printers![indexPath.row].id, contentType: "text/html", title: "Test Print", content: content!, encoding: "base64"){error,message in
            
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            
            if let error = error {
            self.displayMessage(message: error.localizedDescription)
            }
            if let message = message {
            self.displayMessage(message: message)
            }
        
        }
    }
    
    
    func displayMessage(message:String){
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Message", message:message , preferredStyle: UIAlertControllerStyle.alert)
            let ok = UIAlertAction(title: "Ok", style: .default){ action in
            self.dismiss(animated: true, completion: nil)
            }
            controller.addAction(ok)
            
            self.present(controller, animated: false, completion: nil)
        }
    
    }

}

