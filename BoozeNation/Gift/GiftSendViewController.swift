//
//  GiftSendViewController.swift
//  BoozeNation
//
//  Created by Abhishek Chaudhary on 01/01/18.
//  Copyright © 2018 Abhishek Chaudhary. All rights reserved.
//

import UIKit
import Firebase

class GiftSendViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var _searchBarGiftee: UISearchBar!
    @IBOutlet weak var _gifteeName: UILabel!
    @IBOutlet weak var _gifteeEmail: UILabel!
    @IBOutlet weak var _brandImage: UIImageView!
    @IBOutlet weak var _brandName: UILabel!
    @IBOutlet weak var _quantity: UILabel!
    @IBOutlet weak var _totalGiftCardValue: UILabel!
    @IBOutlet weak var _city: UILabel!
    @IBOutlet weak var _backButton: UIButton!
    @IBAction func _backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var _height: NSLayoutConstraint!
    
    @IBOutlet weak var _topSpace: NSLayoutConstraint!
    
    //        _height.constant = height ; _topSpace.constant = topC   // :::: Ye tb lagana jb price dikhana ho i.e. after phone number verification.
//        self.view.setNeedsDisplay()
    
    
    @IBAction func sendTheGift(_ sender: Any) {
        
     sendingGift()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _brandImage.sd_setImage(with: URL(string:"\(selectedShelfDaaru["drinkThumbnail"]!)"))
        _quantity.text="\(quantityToRedeem) \(selectedShelfDaaru["drinkMeasure"]!)"
        _totalGiftCardValue.text="\(quantityToRedeem * Int("\(selectedShelfDaaru["drinkPrice"]!)")!)"
        _city.text="Only Redeemable In \(selectedShelfDaaru["drinkCity"]!)"
    }
    
    var giftTakingUser=[String:Any]()

    var isUserFound=false
    func dataloader(){
    
        Database.database().reference().child("userdirectory").child("\(_searchBarGiftee.text!)").observeSingleEvent(of: .value, with: {snapshot in
            
            if snapshot.exists(){
                
                self.isUserFound=true
                
               self.giftTakingUser=snapshot.value as! [String:Any]
               self._height.constant = self.height
                self._topSpace.constant = self.topC
                self._gifteeName.text=(self.giftTakingUser["fullName"] as! String)
                self._gifteeEmail.text=(self.giftTakingUser["email"] as! String)
                
            }
            else{
            self.showToast(message:"No User Found")
                
            }
            
            
        })
        
        
    }
    
    
    
    func sendingGift(){
        
        
        let pid = Database.database().reference().child("user_queue").child(UID).child("user_transactions").child("transaction_detail").childByAutoId()
        
        if isUserFound{
            _ = SweetAlert().showAlert("Send Gift Card", subTitle: "You are gifting \(quantityToRedeem) \(selectedShelfDaaru["drinkName"]!) To \(self.giftTakingUser["fullName"] as! String)", style: AlertStyle.customImag(imageFile: "tuto3.png"), buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Gift", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
                if isOtherButton == true {
                    
                    print("Cancel Button  Pressed", terminator: "")
                }
                else {
             spinnerView.showSpinner(ttitle: "sending gift", text: "please be patient")
    pid.setValue(
        
        [
        
        "drinkQuantity":quantityToRedeem,
        "drinkCategory":selectedShelfDaaru["drinkCategory"]!,
        "drinkCity":selectedShelfDaaru["drinkCity"]!,
        "drinkMeasure":selectedShelfDaaru["drinkMeasure"]!,
        "drinkName":selectedShelfDaaru["drinkName"]!,
        "drinkPrice":selectedShelfDaaru["drinkPrice"]!,
        "drinkThumbnail":selectedShelfDaaru["drinkThumbnail"]!,
        "gifterEmail":UserDefaults.standard.object(forKey: "email") as! String,
        "gifterName":UserDefaults.standard.object(forKey: "name") as! String,
        "gifterPhone":UserDefaults.standard.object(forKey: "phone") as! String,
        "gifterUid":UID,
        "giftStatus":"GIft",
        "receiverID":self.giftTakingUser["Uid"]!,
        "cartTotalPrice":quantityToRedeem * Int("\(selectedShelfDaaru["drinkPrice"]!)")!,
        "receiverName":self.giftTakingUser["fullName"],
        "receiverPhone":"\(self.searchText)"
        
        ],
        withCompletionBlock: { (error, snapshot) in
            if error != nil {
                print("oops, an error")
            } else {
        
                
                
                let date : Date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM, yyyy hh:mm:ss a"
                let todaysDate = dateFormatter.string(from: date)
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                let tSorter = -1 * (Date().timeIntervalSince1970 * 1000)
                
                 let oId = pid.key.substring(from:pid.key.index(pid.key.endIndex, offsetBy: -6))
                Database.database().reference().child("user_queue").child(UID).child("user_transactions").child("transaction_overview").child(pid.key).setValue([
                    
                    "transaction_pub":"\(selectedShelfDaaru["drinkCategory"]!), \(selectedShelfDaaru["drinkName"]!)",
                    "transaction_type":"gift",
                    "transaction_city":"Quantity \(quantityToRedeem)",
                    "transaction_date":todaysDate,
                    "transactionUID":UID,
                    "order_id":"\(oId.uppercased())",
                    "transaction_value":quantityToRedeem * Int("\(selectedShelfDaaru["drinkPrice"]!)")!,
                    "transaction_sort":tSorter ,
                    "transaction_pushkey":pid.key
                    
                    ])
                spinnerView.removeSelf(completition: {
                _ = SweetAlert().showAlert("Success", subTitle: "Hurray Gift Sent!", style: AlertStyle.success)
                    self.dismiss(animated: true, completion: {
                    })
                })
            }
    }
            )
                    
            
                }}
        }else{
            self.showToast(message: "Enter Valid Number")
        }
        
        
        
   
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        _searchBarGiftee.resignFirstResponder()
    }
    var height:CGFloat = 0
    var topC:CGFloat = 0
    override func viewDidLoad() {
    self._searchBarGiftee.tintColor = UIColor.orange
        height = _height.constant ; topC = _topSpace.constant
       _height.constant = 0
        _topSpace.constant = 0
       self.view.setNeedsDisplay()
    }
    var searchText = String()
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text!
        searchBar.endEditing(true)
        print("\nSearch Text = \(searchText)\n\n")
        dataloader()
    }
    
    
}






