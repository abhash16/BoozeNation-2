//
//  MenuViewController.swift
//  BoozeNation
//
//  Created by Starlord on 23/08/17.
//  Copyright © 2017 Starlord. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
var UID=String()

class loginViewController: UIViewController,GIDSignInUIDelegate ,GIDSignInDelegate {

    @IBAction func forgetPasswordAction(_ sender: Any) {
        if !isChecked{
            if emailTxtField.text == ""{
                emailTxtField.shake()
                snakbarcustom(string: "Enter your Email id")
                
            }
                else {
                     self.snakbarcustom(string: "Kindly agree our terms of service to continue")
                }
    
            }
        
        else{
            if emailTxtField.text != "" {
                let email = emailTxtField.text!
            _ = SweetAlert().showAlert("Reset Password", subTitle: "Send password reset email to \(email)", style: AlertStyle.warning, buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Send", otherButtonColor: UIColor.colorFromRGB(0xEF6C00)) { (isOtherButton) -> Void in
                        if isOtherButton == true {
                
                            print("Cancel Button  Pressed", terminator: "")
                        }
                        else {
                            //password sent mail
                            
                            
                            _ = SweetAlert().showAlert("Email Sent !!", subTitle: "Password reset email successfully sent to \(email)", style: AlertStyle.success)
                        }
                    }
            }
            else{
                emailTxtField.shake()
                snakbarcustom(string: "Enter your Email id")
            }
            }
    }
    
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        startReachability()
        signinBtn.layer.cornerRadius=10.0
        signupBtn.layer.cornerRadius=10.0
        checkBtn.imageView?.frame = CGRect(x: 16, y: 361, width: 28, height: 28)
        checkBtn.imageView?.contentMode = .scaleAspectFit
        
       GIDSignIn.sharedInstance().uiDelegate = self
//       GIDSignIn.sharedInstance().signIn()
GIDSignIn.sharedInstance().delegate=self

        // Do any additional setup after loading the view.
    }

  
    func startReachability(){
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                isInternetConnected = true
                IR.showremoveReachabilityIndicator()
            } else {
                isInternetConnected = true
                IR.showremoveReachabilityIndicator()
                
            }
        }
        reachability.whenUnreachable = { _ in
            isInternetConnected = false
            IR.showremoveReachabilityIndicator()
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTxtField.resignFirstResponder()
        passwordTxtField.resignFirstResponder()
    }
    var isChecked:Bool = false
    @IBAction func checkmarkBtn(_ sender: Any) {
        if isChecked == false{
            let checkedimage = #imageLiteral(resourceName: "ic_check_box")
            openLink(urlString: "http://boozenation.in/app/tos.html")
            let tintedImage = checkedimage.withRenderingMode(.alwaysTemplate)
            checkBtn.tintColor = UIColor.orange
            checkBtn.setImage(tintedImage, for: .normal)
            isChecked = true
        }
        else{
            let uncheckedImage = #imageLiteral(resourceName: "ic_check_box_outline_blank")
            checkBtn.setImage(uncheckedImage, for: .normal)
            isChecked = false
        }
    }
   
    
    @IBOutlet weak var checkBtn: UIButton!
    public func callKrr(){
        self.performSegue(withIdentifier: "MainLoginSegue", sender: nil)

        
    }

    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if !isChecked {
            policyLabel.shake()
            snakbarcustom(string: "Kindly agree our terms of service to continue")
        }
        else{
            
          spinnerView.showSpinner(ttitle: "Logging You In ..:)", text: "Please Be Patient...")

        
        if let error = error {
            
            spinnerView.removeSelf(completition: {
                
            })

            let str=error.localizedDescription
            
            let mySubstring = str.prefix(23)
            let myString = String(mySubstring)
            
            print(myString)
            let str1 = myString.lowercased()
            
        _ = SweetAlert().showAlert("Uh-Oh!", subTitle: "\(str1)", style: AlertStyle.error)
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        
        
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                spinnerView.removeSelf(completition: {
                    
                })
            
                let str=error.localizedDescription
                
                let mySubstring = str.prefix(23)
                let myString = String(mySubstring)
                
                print(myString)
                let str1 = myString.lowercased()
                
               
                    _ = SweetAlert().showAlert("Uh-Oh!", subTitle: "\(str1)", style: AlertStyle.error)
                
                return
            }
            
            UID=user!.uid
            UserDefaults.standard.set(UID, forKey: "uid")
            UserDefaults.standard.synchronize()
            
            UserDefaults.standard.set((user?.email)!, forKey: "email")
            
            

            spinnerView.removeSelf(completition: {
                
            })
            self.performSegue(withIdentifier: "MainLoginSegue", sender: nil)

            
            print("logged in daarubaaz")
        }
        
        
        }
        
        
        
    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        //nkjnknk
    }
    

    
    @IBOutlet weak var policyLabel: UILabel!
    
    
    
    @IBAction func signInUserBtn(_ sender: Any) {
        if !isChecked {
            policyLabel.shake()
            snakbarcustom(string: "Kindly agree our terms of service to continue")
        }
        else{
            
            spinnerView.showSpinner(ttitle: "Signing In", text: "Please wait while we sign you in")
            
            
            Auth.auth().signIn(withEmail: emailTxtField.text!, password: passwordTxtField.text!, completion: {user,error in
                if error != nil{
                    
                    spinnerView.removeSelf(completition: {
                        
                    })
                    let str=error?.localizedDescription
                    print(str)
                    let mySubstring = str!.prefix(23)
                    let myString = String(mySubstring)
                    
                    print(myString)
                    let str1 = myString.lowercased()
                    
                    if str1 == ("the password is invalid"){
                        _ = SweetAlert().showAlert("Uh-Oh!", subTitle: "\(str1)", style: AlertStyle.error)                    }
                    else if str1 == ("there is no user record"){
                         _ = SweetAlert().showAlert("Uh-Oh!", subTitle: "\(str1)", style: AlertStyle.error)
                    }
                        
                        
                    else{
                        _ = SweetAlert().showAlert("Uh-Oh!", subTitle: "\(str1)", style: AlertStyle.error)
                    }
                }
                else{
                    spinnerView.removeSelf(completition: {})
                    
                    if (user?.isEmailVerified)! == false{
                        
                         _ = SweetAlert().showAlert("STOP!", subTitle: "Please verify your emsil first!!", style: AlertStyle.error)
                       
                        do{   try Auth.auth().signOut()
                            
                        }
                        catch{
                            
                        }
                        
                    }
                    else{
                        UID=(user?.uid)!
                        
                        
                        UserDefaults.standard.set((user?.email)!, forKey: "email")
                       
                        UserDefaults.standard.set(UID, forKey: "uid")
                        UserDefaults.standard.synchronize()
                        
                        self.performSegue(withIdentifier: "MainLoginSegue", sender: nil)
                    }
                }
            })
        }
        
    }
    @IBAction func signUpUserBtn(_ sender: UIButton) {
        if !isChecked {
            policyLabel.shake()
            snakbarcustom(string: "Kindly agree our terms of service to continue")
        }
        else{
            spinnerView.showSpinner(ttitle: "Signing In", text: "please wait while we sign you up")
            
            Auth.auth().createUser(withEmail:emailTxtField.text!, password: passwordTxtField.text!, completion: {
                user,error in
                if error != nil{
                    spinnerView.removeSelf(completition: {
                        
                    })
                    let str=error?.localizedDescription
                    
                    let mySubstring = str!.prefix(23)
                    let myString = String(mySubstring)
                    
                    print(myString)
                    let str1 = myString.lowercased()
                 
               _ = SweetAlert().showAlert("Uh-Oh!", subTitle: "\(str1)", style: AlertStyle.error)
                
                
                }
             
                else{
                    
                    spinnerView.removeSelf(completition: {
                        
                    })
                    
                    spinnerView.showSpinner(ttitle:"Sending Verification email", text: "please verify your email to sign up with us")
                    user?.sendEmailVerification(completion: { error in
                        if error != nil {
                            
                            spinnerView.removeSelf(completition: {
                                
                            })
                            let str=error?.localizedDescription
                            
                            let mySubstring = str!.prefix(23)
                            let myString = String(mySubstring)
                            
                            print(myString)
                            let str1 = myString.lowercased()
                            spinnerView.removeSelf(completition: {
                                
                            })
                            _ = SweetAlert().showAlert("Email not sent!", subTitle: "\(str1)", style: AlertStyle.error)
                           
                            
                        }
                        else{
                            
                            spinnerView.removeSelf(completition: {
                                
                            })
                             _ = SweetAlert().showAlert("Email sent!", subTitle: "Please verify your email to log in and enjoy our services!", style: AlertStyle.success)
                           
                        }
                    })
                    
                    
                    do{   try Auth.auth().signOut()
                        
                    }
                    catch{
                        
                    }
                }
                
            })
        }
        
    }
  
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    


}
extension UILabel{
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
}

extension UIButton{
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
}
extension UITextField{
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
extension UIViewController{
    func displayMyAlertMessage(userMessage:String,title:String)
    {
        let myAlert = UIAlertController(title:title,message:userMessage,preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil)
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil)
        
    }
}

