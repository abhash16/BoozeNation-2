//
//  MenuViewController.swift
//  BoozeNation
//
//  Created by Starlord on 23/08/17.
//  Copyright © 2017 Starlord. All rights reserved.
//
import UIKit
import DropDown
import Firebase

class UpdateProfileViewController: UIViewController,UITextFieldDelegate,UIPickerViewDelegate{
    @IBOutlet weak var _birthdayTxtField: UITextField!
    @IBOutlet weak var _nameTxtField: UITextField!
    @IBOutlet weak var _mobileTxtField: UITextField!
    @IBOutlet weak var _emailTxtField: UITextField!
    @IBOutlet weak var _cityTxtField: UITextField!
    
    var profilelInfo=[String:Any]()
    
    var isMobileVerified=false
    
    @IBOutlet var otpView: UIView!
    @IBOutlet weak var _otpTextField: UITextField!
    @IBAction func resendOTPBtn(_ sender: Any) {
    }
    @IBAction func cancelBtnOTP(_ sender: Any) {
       
        removeOtpView()
    }
    
    
    func sendOtpToMobile(){
        
        
        
        let url = URL(string: "https://2factor.in/API/V1/31cba0f9-9f08-11e7-94da-0200cd936042/SMS/\(_mobileTxtField.text!)/AUTOGEN")
        
        URLSession.shared.dataTask(with: url!, completionHandler: {
            
            (data, response, error) in
            
            if(error != nil){
                
                print("error")
                
            }else{
                
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]
                    
                    
                    self.report=json
                    if json["Status"]as! String=="Success"{
                         DispatchQueue.main.async {
                       self.addOtpView()
                        }
                    }else{
                        DispatchQueue.main.async {
                            if let window = UIApplication.shared.keyWindow{
                              window.showToast(message: "\(json["Details"]!)")
                            }
                            
                        }
                        
                    }
                    
                }catch let error as NSError{
                    
                    print(error)
                    
                }
                
            }
            
        }).resume()
        
        
        
    }
    
    
    
    @IBAction func verifyBtnOTP(_ sender: Any) {
        
    self.view.endEditing(true)
        let url = URL(string:"https://2factor.in/API/V1/31cba0f9-9f08-11e7-94da-0200cd936042/SMS/VERIFY/\(report["Details"]!)/\(_otpTextField.text!)")
        
        URLSession.shared.dataTask(with: url!, completionHandler: {

            (data, response, error) in

            if(error != nil){

                print("error")

            }else{

                do{

                    let json = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : AnyObject]


                    if json["Status"]as! String=="Success"{
                        DispatchQueue.main.async {
                        self.removeOtpView()
                        UserDefaults.standard.set(self._mobileTxtField.text!, forKey: "phone")
                            self.profileUpdater()
                        }
                    }else{
                        DispatchQueue.main.async {
                            if let window = UIApplication.shared.keyWindow{
                                window.showToast(message: "\(json["Details"]!)")
                            }

                        }
                        
                    }
 }catch let error as NSError{

                    print(error)

                }

            }

        }).resume()


        
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        
        
            profileUpdater()

       
        
    }
    var today=String()
    
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy/MM/dd"
        let birthdayDate = dateFormater.date(from: birthday)
        print(birthdayDate)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
         today = dateFormater.string(from: now)
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        
        let age = calcAge.year
        print(age)
        return age!
    }
    
    
    var report = [String:Any]()
    
    
   
    
    
    
    
    func profileUpdater(){
       
        if (_birthdayTxtField.text?.isEmpty)! || (_nameTxtField.text?.isEmpty)! || (_mobileTxtField.text?.isEmpty)! || (_cityTxtField.text?.isEmpty)! || (_birthdayTxtField.text?.isEmpty)! {
            
          displayMyAlertMessage(userMessage: "All fields are neccessary")
            
        }
        else{
            
            if calcAge(birthday: _birthdayTxtField.text!) < 25{
                
                self.displayMyAlertMessage(userMessage: "You are below the legal age")

            }
            else if let a=UserDefaults.standard.value(forKey: "phone"){
                
                if UserDefaults.standard.value(forKey: "phone")as! String == _mobileTxtField.text!{
                
            UserDefaults.standard.set(_nameTxtField.text!, forKey: "name")
            UserDefaults.standard.set(_cityTxtField.text, forKey: "city")
            UserDefaults.standard.set(_mobileTxtField.text, forKey: "phone")
            UserDefaults.standard.set(_birthdayTxtField.text, forKey: "dob")
                CurrentCityLocation=_cityTxtField.text!
                UserDefaults.standard.set("done", forKey: "userInfoUpdated")
            
                var sex = "Male"
                if genderCheck==1{
                    sex = "Male"
                    UserDefaults.standard.set("Male", forKey: "sex")
                }else{
                    sex="Female"
                    UserDefaults.standard.set("Female", forKey: "sex")

                }
        
       Database.database().reference().child("userinfo").child(UID).setValue(
        
        ["age":"\(calcAge(birthday: _birthdayTxtField.text!))",
         "city":"\(CurrentCityLocation)",
         "dob":"\(_birthdayTxtField.text!)",
         "email":UserDefaults.standard.object(forKey: "email") as! String,
         "fullName":UserDefaults.standard.object(forKey: "name") as! String,
         "gender":sex,
         "os":"iOS",
         "phone":"\(_mobileTxtField.text!)",
         "signUp_Date":"\(today)"
        
        
        ]
        )
                
                self.performSegue(withIdentifier: "profileUpdater", sender: self)

                }else{
                    sendOtpToMobile()
                    
                }
            }else{
                
                sendOtpToMobile()
            }
        
        }
        
        
        
        
   // }//if end for otp.......
        
        
        
        
    }
    
    
    @IBAction func cancelLogin(_ sender: Any) {
        
        if let loggedIn = UserDefaults.standard.value(forKey: "name"){
            _ = self.navigationController?.popViewController(animated: true)
            
        }else{
        
        do{
            
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: "uid")
            UserDefaults.standard.removeObject(forKey: "name")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "phone")
            UserDefaults.standard.removeObject(forKey: "userInfoUpdated")
            UserDefaults.standard.removeObject(forKey: "sex")
            
            
            self.performSegue(withIdentifier: "cancelLogin", sender: self)
            
        }catch{
            self.performSegue(withIdentifier: "cancelLogin", sender: self)

        }
        }
        
        
    }
    
    
    
    
    
    var details = [String:Any]()
    func dataloader(){
        
        spinnerView.showSpinner(ttitle: "Fetching User Data", text: "")

        Database.database().reference().child("userinfo").child(UID).observe(.value, with:{ snapshot in
            if snapshot.exists(){
                self.details=snapshot.value as! [String:Any]
                guard let a=(UserDefaults.standard.value(forKey: "email") as? String)
                    
                
                else{
                    spinnerView.removeSelf(completition: {
                        
                    })
                    self.performSegue(withIdentifier: "cancelLogin", sender: self)

                    return
                    
                }
                self._emailTxtField.text = a
           self._mobileTxtField.text="\(self.details["phone"]!)"
                self._nameTxtField.text="\(self.details["fullName"]!)"
                self._birthdayTxtField.text="\(self.details["dob"]!)"
                self._cityTxtField.text="\(self.details["city"]!)"
                
                
                UserDefaults.standard.set("\(self.details["phone"]!)", forKey: "phone")

                
                if ("\(self.details["gender"]!)") == "Male"{
                    self.genderCheck=1
                    
                }else{
                    self.genderCheck=0
                }
                
                self.genderer()

            }
            else{
                
                self.genderer()
                self._emailTxtField.text=(UserDefaults.standard.value(forKey: "email") as! String)
               
            }
            
            spinnerView.removeSelf(completition: {
            
            })
        })
        
    }
    
    
    
    
    
    
//    let cityPicker = UIPickerView()
    let dropDown = DropDown()
  var citynames = ["DELHI","haryana","mars","pluto"]
    let datePicker = UIDatePicker()

    func textfieldAcces(){
        	let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.done, target: self, action: #selector(cancelDatePicker))
        toolBar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        datePicker.datePickerMode = .date
        _birthdayTxtField.inputAccessoryView = toolBar
        _birthdayTxtField.inputView = datePicker
        
    }
    func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        _birthdayTxtField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        self.view.endEditing(true)
    }
    func genderer(){
        if genderCheck == 1 {
           
            maleBtn.setImage(radiocheck, for: .normal)
            maleBtn.tintColor = UIColor.orange
            femaleBtn.setImage(radiouncheck, for: .normal)
            femaleBtn.tintColor = UIColor.clear
        }
        else{
            femaleBtn.setImage(radiocheck, for: .normal)
            femaleBtn.tintColor = UIColor.orange
            maleBtn.setImage(radiouncheck, for: .normal)
            maleBtn.tintColor = UIColor.clear
        }
    }
    func addOtpView(){
        self._emailTxtField.endEditing(true)
        self._mobileTxtField.endEditing(true)
        self._nameTxtField.endEditing(true)
        self._birthdayTxtField.endEditing(true)

        
        let orangeLine = UIView(frame: CGRect(x: 0, y: _otpTextField.frame.height-2, width: _otpTextField.frame.width, height: 2))
        orangeLine.backgroundColor = UIColor.orange
        _otpTextField.addSubview(orangeLine)
        self.aView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.aView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.view.addSubview(self.aView)
        UIView.animate(withDuration: 0.5, animations: {
            self.otpView.frame = CGRect(x: 0, y: (self.view.frame.height-self.otpView.frame.height), width: self.view.frame.width, height: self.otpView.frame.height)
            self.aView.addSubview(self.otpView)
            
        }, completion: nil)
    }
    let aView = UIView()
    func removeOtpView(){
        UIView.animate(withDuration: 0.5, animations: {
            self.otpView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.otpView.frame.height)
        }) { (o) in
             self.aView.removeFromSuperview()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      textfieldAcces()  
        otpView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: otpView.frame.height)
        print(UID)
        
        dataloader()

        _emailTxtField.isUserInteractionEnabled=false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.orange]
        dropDown.anchorView = _cityTxtField
        dropDown.dataSource = ["DELHI","haryana","mars","pluto"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self._cityTxtField.text = "City          \(item)"
        }
        _cityTxtField.addTarget(self, action: #selector(showDropDown), for: .touchDown)
        let dropImage = #imageLiteral(resourceName: "dropdown (1)");let dropArrow = UIImageView.init(image: dropImage.withRenderingMode(.alwaysTemplate))
      dropArrow.tintColor = UIColor.orange
        _cityTxtField.rightViewMode = UITextFieldViewMode.always
        _cityTxtField.rightView = dropArrow
     llll()
}
    func showDropDown(){
        dropDown.show()
    }
    
    func llll(){
        _nameTxtField.attributedPlaceholder =
            NSAttributedString(string: "Name", attributes:[NSForegroundColorAttributeName : UIColor.gray])
        _cityTxtField.attributedPlaceholder =
            NSAttributedString(string: "City", attributes:[NSForegroundColorAttributeName : UIColor.gray])
        _mobileTxtField.attributedPlaceholder =
            NSAttributedString(string: "Phone", attributes:[NSForegroundColorAttributeName : UIColor.gray])
    }
    func changedate(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
     //   _birthdayTxtField.text = formatter.string(from: datePicker.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _otpTextField.resignFirstResponder()
        _birthdayTxtField.resignFirstResponder()
        _nameTxtField.resignFirstResponder()
        _mobileTxtField.resignFirstResponder()
        _emailTxtField.resignFirstResponder()
        _cityTxtField.resignFirstResponder()
    }
        var initialOtpFrame = CGRect()
func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        initialOtpFrame = otpView.frame
        UIView.animate(withDuration: 0.4, animations: {
            self.otpView.frame = CGRect(x: 0, y:(self.view.frame.height-keyboardHeight-self.initialOtpFrame.height), width: self.initialOtpFrame.width, height: self.initialOtpFrame.height)
        }) { (_) in }
}
func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.2) {
            self.otpView.frame = CGRect(x: 0, y: self.initialOtpFrame.minY, width: self.initialOtpFrame.width, height: self.initialOtpFrame.height)
        }
}
    var genderCheck:Int = 1
    let radiocheck = #imageLiteral(resourceName: "ic_radio_button_checked").withRenderingMode(.alwaysTemplate)
    let radiouncheck = #imageLiteral(resourceName: "ic_radio_button_unchecked")
    @IBOutlet weak var maleBtn: UIButton!
    @IBAction func maleBtnAction(_ sender: Any) {
        if genderCheck == 0 {
            maleBtn.setImage(radiocheck, for: .normal)
            maleBtn.tintColor = UIColor.orange
            femaleBtn.setImage(radiouncheck, for: .normal)
            femaleBtn.tintColor = UIColor.clear
            genderCheck = 1
        }
        
    }
    @IBOutlet weak var femaleBtn: UIButton!
    @IBAction func femaleBtnAction(_ sender: Any) {
        if genderCheck == 1{
            femaleBtn.setImage(radiocheck, for: .normal)
            femaleBtn.tintColor = UIColor.orange
            maleBtn.setImage(radiouncheck, for: .normal)
            maleBtn.tintColor = UIColor.clear
            genderCheck = 0
        }
    }
    
    
    
    
    func displayMyAlertMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title:"Udpate Error",message:userMessage,preferredStyle:UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"OK",style:UIAlertActionStyle.default,handler:nil)
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil)
        
    }
    
    
    
    
}


extension UIWindow{
    func showToast(message : String) {
        let window = UIApplication.shared.keyWindow
        let toastLabel = UILabel(frame: CGRect(x: 50, y: (window?.frame.size.height)!-150, width:(window?.frame.size.width)!-100 , height: 60))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines=2
        toastLabel.layer.cornerRadius = 10.0;
        toastLabel.clipsToBounds  =  true
        window?.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.08, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
