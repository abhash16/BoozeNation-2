//
//  CartViewController.swift
//  BoozeNation
//
//  Created by Abhishek Chaudhary on 29/09/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit
import Firebase
var merchantKey=String()
var cartDetailsArray=[[String:Any]]()


class CartViewController: UIViewController , UITableViewDataSource, UITableViewDelegate  {
    

  // var sum=0
    var price=0
  
    let aView = UIView()

    @IBOutlet weak var payingButton: UIButton!
    @IBOutlet weak var _remainingBZCredits: UILabel!
    @IBOutlet weak var _boozeNationCredits: UILabel!

    @IBOutlet weak var _totalCartValueLabel: UILabel!
    @IBOutlet weak var _BNCreditsLabel: UILabel!
    @IBOutlet weak var _payBtnOutlet: UIButton!
    @IBAction func TaptoPay(_ sender: Any) {
        
        _totalValueinCIView.text="\(price)"
        _boozeNationCredits.text="\((UserDefaults.standard.value(forKey: "bnCredits") as! Int))"
        
        if ((UserDefaults.standard.value(forKey: "bnCredits") as! Int)>=price){
         creditsTobeUsed=price
            price=0
            _remainingBZCredits.text="\((UserDefaults.standard.value(forKey: "bnCredits") as! Int)-creditsTobeUsed)"
            _payAmountInCiVIew.text="\(price)"

        }else{
           creditsTobeUsed=(UserDefaults.standard.value(forKey: "bnCredits") as! Int)
            price=price-creditsTobeUsed
            _remainingBZCredits.text="0"
            _payAmountInCiVIew.text="\(price)"

        }
        
        self.view.addSubview(aView)
        self.view.addSubview(checkInView)
        
    }
    @IBOutlet weak var mytabeView: UITableView!
    
    @IBOutlet var checkInView: UIView!         // View opens after tap to pay pressed
    @IBOutlet weak var _totalValueinCIView: UILabel!
    @IBOutlet weak var _payAmountInCiVIew: UILabel!
    @IBAction func cancelBtnCIVIew(_ sender: Any) {
        removeCheckInView()
    }
    
    let emptyView=UIImageView()
 var mytrick="0"
    
    override func viewWillAppear(_ animated: Bool) {
        checkInView.removeFromSuperview() ; aView.removeFromSuperview()
        _payBtnOutlet.isUserInteractionEnabled = true
         _BNCreditsLabel.text="\(UserDefaults.standard.value(forKey: "bnCredits")!)"
        //removeCheckInView()
        loadMyCart()
       mytrick="0"
    }
    var creditsTobeUsed=0
    func boozeNationDbPayment(){
        Database.database().reference().child("usertransaction_status").child(UID).child("Purchase").removeValue()
        
        spinnerView.showSpinner(ttitle: "Initiating Purchase", text: "Please Be Patient...")
        
        
        
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm:ss a"
        let todaysDate = dateFormatter.string(from: date)
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let tSorter = -1 * (Date().timeIntervalSince1970 * 1000)
        
        let pid = Database.database().reference().child("user_queue").child(UID).child("user_transactions").child("transaction_overview").childByAutoId()
        print(pid.key)
        
        let oId = pid.key.substring(from:pid.key.index(pid.key.endIndex, offsetBy: -6))
        print(oId)
        print("lolo")
        
        pid.setValue(["order_id":"\(oId.uppercased())","transactionUID":"\(UID)","transaction_bzcredits":"\(creditsTobeUsed)" ,"transaction_city":"\(CurrentCityLocation)","transaction_date":"\(todaysDate)","transaction_pub":"BoozeNation","transaction_pushkey":"\(pid.key)","transaction_sort":tSorter ,"transaction_type":"purchase","transaction_value":self.price ]) { (error, snap) in
            
            
Database.database().reference().child("usertransaction_status").child(UID).child("Purchase").observe(.value, with:{ snapshot in
                
                var dict = snapshot.value as? [String:Any]
                if snapshot.exists(){
                    if "\(dict!["status"]!)" == "success"{
                        
                        if self.mytrick != "success"{
                       self.mytrick="success"
                            Database.database().reference().child("usertransaction_status").child(UID).child("Purchase").removeValue()
                        cartDetailsArray.removeAll()
                        self.mytabeView.reloadData()
                        
                        print("\nsuccccccccceeeeessssssss\n");
                            
                            Database.database().reference().child("usertransaction_status").child(UID).child("Purchase").removeAllObservers()
                            spinnerView.removeSelf(completition: {
                                _ = SweetAlert().showAlert("Cheers", subTitle: "Booze Added To Your Bar", style: AlertStyle.success, buttonTitle: "OK", action: { (gaand) in
                                    
                                    self.navigationController?.popToRootViewController(animated: true)
                                    
                                })
                                
                            })
                            
                            
                        
                        }
                    }
                    else  if "\(dict!["status"]!)" == "failure"{
                        
                        
                        if self.mytrick != "failure"{
                            self.mytrick="failure"
                            Database.database().reference().child("usertransaction_status").child(UID).child("Purchase").removeValue()
                            cartDetailsArray.removeAll()
                            self.mytabeView.reloadData()
                            
                            print("\nfailllllll\n");
                            
                            Database.database().reference().child("usertransaction_status").child(UID).child("Purchase").removeAllObservers()
                            spinnerView.removeSelf(completition: {
                                _ = SweetAlert().showAlert("Uh-Oh", subTitle: "\(dict!["reason"]!)", style: AlertStyle.error, buttonTitle: "OK", action: { (gaand) in
                                    
                                    self.navigationController?.popToRootViewController(animated: true)
                                    
                                })
                                
                            })
                            
                            
                            
                        }
                        
                    }
                }
    
                self.removeCheckInView()
            })
            
        }
        
    }
    var trickTextField=UITextField()
    //PayU starts here:::::::::::::
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    
    func responseReceived(notification: Notification) {
       cartDetailsArray.removeAll()
        
       // print("Pay Response  \(notification.description)");
        let responseDict=notification.description as! String
        //print(responseDict)
        
       
        
        if let dict11=convertToDictionary(text: notification.object as! String){
            print("\(dict11)\n\n\n\n")
            
            NotificationCenter.default.removeObserver(self)

            if(dict11["status"]! as! String) == "success"{
         
           // removeCheckInView()
            boozeNationDbPayment()
           
        }else{
         
           
                _ = SweetAlert().showAlert("payment Failed", subTitle: "Please try again!", style: AlertStyle.error, buttonTitle: "OK", action: { (gaand) in
                   
                })
                
             self.navigationController?.popToRootViewController(animated: true)
           
            
            }
            
        }else{
            
            _ = SweetAlert().showAlert("payment Failed", subTitle: "Please try again!", style: AlertStyle.error, buttonTitle: "OK", action: { (gaand) in
                
                self.navigationController?.popViewController(animated: true)
                
             })
            
        }
    }
    
    func payUOptionStock(){
        
       merchantKey="gtKFFx"
        
        let paymentParam:PayUModelPaymentParams = PayUModelPaymentParams();
        paymentParam.key = merchantKey;
        paymentParam.amount = "\(price)";
        paymentParam.productInfo = "Booze";
        paymentParam.firstName = "\(UserDefaults.standard.value(forKey: "name")!)";
        paymentParam.email = "\(UserDefaults.standard.value(forKey: "email")!)";
        paymentParam.userCredentials = "\(merchantKey):\(UserDefaults.standard.value(forKey: "email")!)";
        paymentParam.phoneNumber = "\(UserDefaults.standard.value(forKey: "phone")!)";
        paymentParam.surl = "https://payu.herokuapp.com/success";
//        paymentParam.surl = "https:www.someFailureUrl.com";
//        paymentParam.surl = "http://abc.com";
        paymentParam.furl = "https://payu.herokuapp.com/failure"
        paymentParam.udf1 = "\(UID)";
        paymentParam.udf2 = "iOS";
        paymentParam.udf3 = "u3";
        paymentParam.udf4 = "u4";
        paymentParam.udf5 = "u5";
        //paymentParam.transactionID = "986123785";
        let randomID = "\(IntMax(Date().timeIntervalSince1970))"
        
        paymentParam.transactionID = "\(randomID)"; //String(format: "%ld", randomID)
        paymentParam.environment = ENVIRONMENT_TEST
        
        
//paymentParam.hashes.paymentRelatedDetailsHash="885d90fbc64f86ec9ade3abab27c6a5fe259a9cd57f62a558f9001d5c81e64d06a113d6459c8e2cecbf1c4776b1fc5b5ee1bf9884eee4383ef1a3740ba09f4d3"
        
        
        
        
        let obj:PayUDontUseThisClass = PayUDontUseThisClass()
        obj.getPayUHashes(withPaymentParam: paymentParam, merchantSalt: "eCwWELxi", withCompletionBlock:{( allHashes,hashString,errorMessage)in
            
            if (errorMessage == nil) {
                
                
                
                
                //                paymentOptionVC!.paymentParam = paymentParam;
                //                paymentOptionVC!.paymentRelatedDetail = paymentRelatedDetails;
                //                //
                //                self.navigationController?.pushViewController(paymentOptionVC!, animated: true);
                paymentParam.hashes = allHashes
                
            }
            else{
                // error occurred while creating the request
            }
        });
        //        [obj getPayUHashesWithPaymentParam:paymentParam
        //        merchantSalt:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"salt"]
        //        withCompletionBlock:^(PayUModelHashes *allHashes, PayUModelHashes *hashString, NSString *errorMessage) {
        //
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        [self callSDKWithHashes:allHashes withError:errorMessage];
        //        });
        //        }];
        //obj.getPayUHashesWithPaymentParam
        
        
        let webServiceResponse:PayUWebServiceResponse = PayUWebServiceResponse();
        webServiceResponse.getPayUPaymentRelatedDetail(forMobileSDK: paymentParam, withCompletionBlock: {(paymentRelatedDetails,errorMessage,extraParam)in
            
            if (errorMessage == nil) {
                
                let stryBrd = UIStoryboard(name: "PUUIMainStoryBoard", bundle: nil) //if bundle is nil the main bundle will be used
                let paymentOptionVC = stryBrd.instantiateViewController(withIdentifier: VC_IDENTIFIER_PAYMENT_OPTION) as? PUUIPaymentOptionVC;
                
                
                paymentOptionVC!.paymentParam = paymentParam;
                paymentOptionVC!.paymentRelatedDetail = paymentRelatedDetails;
                //
                self.navigationController?.pushViewController(paymentOptionVC!, animated: true);
                
            }
            else{
                // error occurred while creating the request
            }
        });
        
        
    }
    
    

    @IBAction func payBtnCIView(_ sender: Any) {
        _payBtnOutlet.isUserInteractionEnabled = false
        if price==0{
          boozeNationDbPayment()
        }else{
            
    NotificationCenter.default.addObserver(self, selector: #selector(CartViewController.responseReceived(notification:)), name: NSNotification.Name(rawValue: kPUUINotiPaymentResponse), object: nil)
            
            
        payUOptionStock()
        }
    }
    
    
    func emptyCartImageSetter(){
        
        self.payingButton.isUserInteractionEnabled=false
        self.payingButton.titleLabel?.text="Cart Empty"
        self.view.addSubview(self.emptyView)
        
    }
    
    func emptyCartImageRemover(){
        self.emptyView.removeFromSuperview()
    }
    
    
    func removeCheckInView(){
        
        checkInView.removeFromSuperview() ; aView.removeFromSuperview()
        
        loadMyCart()
    }
    
    
    func loadMyCart(){
        
        self.payingButton.isUserInteractionEnabled=true
        self.payingButton.titleLabel?.text="Tap to Pay"
        
        cartDetailsArray.removeAll()
        self.price=0
        Database.database().reference().child("usercart").child(UID).observe(.childAdded, with:{ snapshot in
            if snapshot.exists(){
            var dictionary=[String:Any]()
            
            dictionary=snapshot.value as! [String:Any]
            
            self.price+=dictionary["cartTotalPrice"] as! Int
            cartDetailsArray.append(dictionary)
            self.mytabeView.reloadData()
            }
            
            self._totalCartValueLabel.text="\(self.price)"

        })
        
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
     //payu

        
        
         let CIHeight = checkInView.frame.height
        checkInView.frame = CGRect(x: 0, y:self.view.frame.height-50-CIHeight, width: self.view.frame.width, height: CIHeight)
        aView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        aView.backgroundColor = UIColor.black
        aView.alpha = 0.6
        self.emptyView.image=#imageLiteral(resourceName: "cart_empty")
        self.emptyView.contentMode = .scaleAspectFit
        self.emptyView.frame.size=self.mytabeView.frame.size
        self.emptyView.frame.size=CGSize(width: self.emptyView.frame.width/2.0, height: emptyView.frame.height/2.0)
        self.emptyView.center=self.mytabeView.center
    }


    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartrow", for: indexPath) as! CartRow
        cell._brandName.text = cartDetailsArray[indexPath.row]["drinkName"] as! String
        cell._quantity.text = "\(cartDetailsArray[indexPath.row]["drinkQuantity"]!) \(cartDetailsArray[indexPath.row]["drinkMeasure"]!)"
        cell._delhiPrice.text = "\(cartDetailsArray[indexPath.row]["drinkPrice"]!)"
        cell._totalPrice.text = "\(cartDetailsArray[indexPath.row]["cartTotalPrice"]!)"
        cell._brandImage.sd_setImage(with: URL(string: cartDetailsArray[indexPath.row]["drinkThumbnail"]! as! String))
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
   
    
    
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteRow = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
         
spinnerView.showSpinner(ttitle: "Removing Drink From Cart ..", text: "Please Be Patient...")
            
Database.database().reference().child("removefromusercart").child(UID).setValue([("\(cartDetailsArray[indexPath.row]["drinkCity"]!)\(cartDetailsArray[indexPath.row]["drinkCategory"]!)\(cartDetailsArray[indexPath.row]["drinkName"]!)\(cartDetailsArray[indexPath.row]["drinkMeasure"]!)").lowercased() : "true"], withCompletionBlock: { (error, snap) in
                
self.price -= cartDetailsArray[indexPath.row]["cartTotalPrice"]! as! Int
self._totalCartValueLabel.text="\(self.price)"
           
let handle = Database.database().reference().child("usertransaction_status").child(UID).child("removefromusercart")
    
    
        handle.observe(.value, with:{ snapshot in
        
        var dict = snapshot.value as? [String:Any]
        
    if snapshot.exists(){
        
        
      if "\(dict!["status"]!)" == "success" {
        if cartDetailsArray.count>0{
 Database.database().reference().child("usertransaction_status").child(UID).child("removefromusercart").removeAllObservers()
        cartDetailsArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        }else{
            tableView.reloadData()
        }
        
        spinnerView.removeSelf(completition: {})

        
Database.database().reference().child("usertransaction_status").child(UID).child("removefromusercart").removeValue()
        }
      
      else if "\(dict!["status"]!)" == "failed" {
        
       spinnerView.removeSelf(completition: {})
       
        
        self.showToast(message: "\(dict!["reason"]!)")
        Database.database().reference().child("usertransaction_status").child(UID).child("removefromusercart").removeValue()

        
        }

            
        
if cartDetailsArray.count==0{
                self.emptyCartImageSetter()
                            }
            
        }
    })
                
})
       
        }
        return [deleteRow]
    }
    
}

class CartRow: UITableViewCell {
    @IBOutlet weak var _brandImage: UIImageView!
    @IBOutlet weak var _brandName: UILabel!
    @IBOutlet weak var _quantity: UILabel!
    @IBOutlet weak var _delhiPrice: UILabel!
    @IBOutlet weak var _totalPrice: UILabel!
    
}

