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
import MaterialComponents.MaterialFeatureHighlight
var shelfFlag=0
var selectedShelfDaaru=[String:Any]()
var quantityToRedeem = 1

class ShelfSlider:UIViewController{
    
    let addSliderdownView = Bundle.main.loadNibNamed("addSlider", owner: self, options: nil)?.first as! addSliderView
    //let view = UIView()
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("\n\n\n\(selectedShelfDaaru)")
        print("lolo")
        let userdefault = UserDefaults.standard
        let featureHighlighted = userdefault.bool(forKey: "featureHighlight1")
        if !featureHighlighted {
            self.showFeatures()
            
        }}
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        view.backgroundColor = UIColor(white: 0, alpha: 0.8)
        quantityToRedeem = 1
        addSlider()
        addSliderdownView._measurePrice.text = "\(selectedShelfDaaru["drinkPrice"]!)"
        addSliderdownView.daaruDetails.text = "\(selectedShelfDaaru["drinkName"]!)\n\(selectedShelfDaaru["drinkMeasure"]!)\nQuantity on Shelf: \(selectedShelfDaaru["drinkQuantity"]!)\nReedemable in City: \(selectedShelfDaaru["drinkCity"]!)\n\(selectedShelfDaaru["drinkCategory"]!)"
        addSliderdownView.totalCost.text="\(selectedShelfDaaru["cartTotalPrice"]!)"
        addSliderdownView._quantityLabel.text="\(quantityToRedeem)"
        addSliderdownView.totalCost.text = "\(quantityToRedeem * Int("\(selectedShelfDaaru["drinkPrice"]!)")!)"
        
        
    }
    override func viewDidLoad() {
        
        
        //addSliderdownView.addToCartButton.addTarget(self, action: #selector(showloading), for: .touchUpInside)
        addSliderdownView.giftButton.addTarget(self, action: #selector(showGiftSender), for: .touchUpInside)
    }
    
    func showloading(){
        // showOrRemoveSpinner(Title: "a", Text: "bc")
    }
    
    func showGiftSender(){
        print("\nGifter\n")
        let giftSendVC = Bundle.main.loadNibNamed("GiftSendViewController", owner: self, options: nil)?.first as! GiftSendViewController
        remove()
        
        self.present(giftSendVC, animated: true, completion: nil)
        
    }
    
    func addSlider(){
        
        
        if let window = self.view {
            if whichbutton == 1{
                addSliderdownView.giftButton.isHidden = true
                addSliderdownView.CashoutButton.isHidden = true
                addSliderdownView.addToCartButton.setTitle("ORDER SPECIAL", for: .normal)
                
            }
            else{
                addSliderdownView.giftButton.isHidden = false
                addSliderdownView.CashoutButton.isHidden = false
                addSliderdownView.addToCartButton.setTitle("ADD TO ORDER", for: .normal)
                
            }
            
            self.view.isUserInteractionEnabled = true
            let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(remove))
            downSwipe.direction = .down
            self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(remove)))
            addSliderdownView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dd)))
            self.view.addGestureRecognizer(downSwipe)
            addSliderdownView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
            addSliderdownView.infoTextView.sizeThatFits(CGSize(width: addSliderdownView.infoTextView.frame.width, height:(addSliderdownView.frame.height-addSliderdownView.infoTextView.frame.minY)))
            addSliderdownView.addGestureRecognizer(downSwipe)
            addSliderdownView.giftButton.layer.cornerRadius=10.0
            addSliderdownView.CashoutButton.layer.cornerRadius=10.0
            addSliderdownView.addToCartButton.layer.cornerRadius=10.0
            addSliderdownView.daaruImage.layer.borderWidth=1.0
            addSliderdownView.daaruImage.layer.masksToBounds=false
            addSliderdownView.daaruImage.layer.cornerRadius=10.0
            addSliderdownView.daaruImage.clipsToBounds=true
            
            print("\(selectedShelfDaaru["drinkThumbnail"]!)")
            addSliderdownView.daaruImage.sd_setImage(with: URL(string:"\(selectedShelfDaaru["drinkThumbnail"]!)"))
            view.addSubview(addSliderdownView)     //
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                //self.view.alpha = 0.1
                
                self.addSliderdownView.frame = CGRect(x: 0, y: window.frame.size.height/3.0, width: window.frame.size.width, height: window.frame.size.height/1.5)
                
            }, completion:{ finished in
                
            }
            )
            addSliderdownView._plusButton.addTarget(self, action: #selector(addQuantity), for: .touchDown)
            addSliderdownView._minusButton.addTarget(self, action: #selector(subtractQuantity), for: .touchDown)
        }}
    
    func cashoutDialogue(){
        
    }
    
    
    
    
    func dd(){
        //ye jaroori hai , ise mt htaio::
    }
    
    
    func remove(){
        UIView.animate(withDuration: 0.2, animations: {
            self.addSliderdownView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }) { bool in
            self.addSliderdownView.removeFromSuperview()
            self.dismiss(animated: false, completion: nil)
        }
        
    }
    
    func removeAndShowGiftSendVC(){
        UIView.animate(withDuration: 0.2, animations: {
            self.addSliderdownView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
        }) { bool in
            self.addSliderdownView.removeFromSuperview()
            self.dismiss(animated: false, completion: {
                self.showGiftSender()
            })
            
        }
    }
    
    
    
}


//custom class::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
class addSliderView:UIView{
    var trick = 0
    
    
    @IBAction func doCashout(_ sender: Any) {
        Database.database().reference().child("usertransaction_status").child(UID).child("cashout_transaction").removeValue()
        
        _ = SweetAlert().showAlert("Cash Out Drink", subTitle: "Drink price will be refunded to your Booze Nation wallet in the form of Booze Nation Credits. You can use available Booze Nation credits to buy any other drink from our menu. You want yo continue ?", style: AlertStyle.customImag(imageFile: "beer.png"), buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Cash out", otherButtonColor: UIColor.colorFromRGB(0x69B2FB)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                print("Cancel Button  Pressed", terminator: "")
            }
            else {
                spinnerView.showSpinner(ttitle: "Adding Drink To Order ..", text: "Please Be Patient ..")
                
                //
                
                
                
                
                
                let date : Date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM, yyyy hh:mm:ss a"
                let todaysDate = dateFormatter.string(from: date)
                dateFormatter.amSymbol = "AM"
                dateFormatter.pmSymbol = "PM"
                let tSorter = -1 * (Date().timeIntervalSince1970 * 1000)
                
                let pid =  Database.database().reference().child("user_queue").child(UID).child("user_transactions").child("transaction_detail").childByAutoId()
                
                pid.child("\(selectedShelfDaaru["drinkCity"]!)\(selectedShelfDaaru["drinkCategory"]!)\(selectedShelfDaaru["drinkName"]!)\(selectedShelfDaaru["drinkMeasure"]!)".lowercased()).setValue(
                    
                    ["cartTotalPrice":(quantityToRedeem * Int("\(selectedShelfDaaru["drinkPrice"]!)")!),"drinkCategory":"\(selectedShelfDaaru["drinkCategory"]!)","drinkCity":"\(selectedShelfDaaru["drinkCity"]!)","drinkMeasure":"\(selectedShelfDaaru["drinkMeasure"]!)","drinkName":"\(selectedShelfDaaru["drinkName"]!)","drinkPrice":(selectedShelfDaaru["drinkPrice"]!),"drinkQuantity":quantityToRedeem,"drinkThumbnail":"\(selectedShelfDaaru["drinkThumbnail"]!)" ],
                    
                    
                    withCompletionBlock: { (error, snapshot) in
                        if error != nil {
                            print("oops, an error")
                        } else {
                            
                            //.child("\(selectedShelfDaaru["drinkCity"]!)\(selectedShelfDaaru["drinkCategory"]!)\(selectedShelfDaaru["drinkName"]!)\(selectedShelfDaaru["drinkMeasure"]!)".lowercased())
                            
                            print(pid.key)
                            let oId = pid.key.substring(from:pid.key.index(pid.key.endIndex, offsetBy: -6))
                            
                            Database.database().reference().child("user_queue").child("\(UID)").child("user_transactions").child("transaction_overview").child(pid.key).setValue([
                                "order_id":"\(oId.uppercased())",
                                "transaction_city":"Quantity \(quantityToRedeem)",
                                "transaction_date":"\(todaysDate)",
                                "transaction_pub":"\(selectedShelfDaaru["drinkCategory"]!), \(selectedShelfDaaru["drinkName"]!)",
                                "transaction_pushkey":pid.key,
                                "transaction_sort":tSorter ,
                                "transaction_type": "cashout",
                                "transaction_value":"\(quantityToRedeem * Int("\(selectedShelfDaaru["drinkPrice"]!)")!)",
                                "transactionUID":UID
                                
                                ], withCompletionBlock: { (error, snapshot) in
                                    if error != nil {
                                        print("oops, an error")
                                    } else {
                                        
//                                        Database.database().reference().child("usertransaction_status").child(UID).child("cashout_transaction").child("status").observe(.value, with: { (snapshot1) in
//
//                                            if snapshot1.exists(){
//
//                                                spinnerView.removeSelf(completition: {
//                                                    _ = SweetAlert().showAlert("Cash Out Successfull", subTitle: "Booze Nation credits will be added to your Booze Nation wallet shortly", style: AlertStyle.success)                                    })
//
//                                            }
//                                        })
                                        
                                        
                                        
                                        Database.database().reference().child("usertransaction_status").child(UID).child("cashout_transaction").observe(.value, with:{ snapshot in
                                            
                                            var dict = snapshot.value as? [String:Any]
                                            
                                            if snapshot.exists() && "\(dict!["status"]!)" == "success" {
                                                
                                                spinnerView.removeSelf(completition: {
                                                    _ = SweetAlert().showAlert("Cash Out Successful", subTitle: "Booze Nation credits will be added to your Booze Nation wallet shortly", style: AlertStyle.success, buttonTitle: "OK", action: { (gaand) in
                                                        
                                                        Database.database().reference().child("usertransaction_status").child(UID).child("cashout_transaction").removeValue()
                                                        
                                                    })
                                                    
                                                })
                                                
                                                
                                                
                                                
                                            }
                                                
                                            else if snapshot.exists() && "\(dict!["status"]!)" == "failed" {
                                                
                                                spinnerView.removeSelf(completition: {
                                                    _ = SweetAlert().showAlert("Uh-Oh!", subTitle: "Transaction failed \(dict!["reason"]!)", style: AlertStyle.error)
                                                    
                                                    Database.database().reference().child("usertransaction_status").child(UID).child("cashout_transaction").removeValue()
                                                    
                                                    
                                                })
                                                
                                                
                                                
                                                
                                            }
                                            
                                            
                                            
                                            
                                            
                                        })
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                    }
                            }
                                
                            )
                            
                        }
                }
                )
                
                
            }}
        
        
    }
    
    
    
    @IBAction func addToRedeemCart(_ sender: Any) {
        Database.database().reference().child("user_queue").removeValue()
        
        
        if whichbutton==0{
            Database.database().reference().child("usertransaction_status").child(UID).child("addToRedeem").removeValue()
            
            
            trick=0
            
            spinnerView.showSpinner(ttitle: "Adding Drink To Order ..", text: "Please Be Patient ..")
            
            
            
            Database.database().reference().child("temp_userredeemcart").child("\(UID)").childByAutoId().child(("\(selectedShelfDaaru["drinkCity"]!)\(selectedShelfDaaru["drinkCategory"]!)\(selectedShelfDaaru["drinkName"]!)\(selectedShelfDaaru["drinkMeasure"]!)").lowercased()).setValue(["cartTotalPrice":quantityToRedeem * Int("\(selectedShelfDaaru["drinkPrice"]!)")!,"drinkCategory":"\(selectedShelfDaaru["drinkCategory"]!)","drinkCity":"\(selectedShelfDaaru["drinkCity"]!)","drinkMeasure":"\(selectedShelfDaaru["drinkMeasure"]!)","drinkName":"\(selectedShelfDaaru["drinkName"]!)","drinkPrice":"\(selectedShelfDaaru["drinkPrice"]!)","drinkQuantity":quantityToRedeem,"drinkThumbnail":"\(selectedShelfDaaru["drinkThumbnail"]!)","drinkTaxPrice":10,"cartTotalTaxPrice":30  ])
            
            Database.database().reference().child("usertransaction_status").child(UID).child("addToRedeem").observe(.value, with:{ snapshot in
                
                var dict = snapshot.value as? [String:Any]
                
                if snapshot.exists() && self.trick==0 && "\(dict!["status"]!)" == "success" {
                    
                    self.trick=1
                    spinnerView.removeSelf(completition: {
                        _ = SweetAlert().showAlert("Cheers", subTitle: "Booze Added To Order", style: AlertStyle.success, buttonTitle: "OK", action: { (gaand) in
                            
                            Database.database().reference().child("usertransaction_status").child(UID).child("addToRedeem").removeValue()
                            
                        })
                        
                    })
                    
                   
                    
                    
                }
                    
                else if snapshot.exists() && self.trick==0 && "\(dict!["status"]!)" == "failed" {
                    
                    self.trick=1
                    spinnerView.removeSelf(completition: {
                        _ = SweetAlert().showAlert("Cheers", subTitle: "Booze Added To Order", style: AlertStyle.success)
                        
                        Database.database().reference().child("usertransaction_status").child(UID).child("addToRedeem").removeValue()
                        
                        
                    })
                    
                   
                    
                    
                }
                
                
                
                
                
            })
            
        }else{
            Database.database().reference().child("usertransaction_status").child(UID).child("specialToRedeem").removeValue()
            
            
            trick=0
            
            spinnerView.showSpinner(ttitle: "Adding Drink To Order ..", text: "Please Be Patient ..")
            
            
            
            Database.database().reference().child("temp_userredeemcart").child("\(UID)").childByAutoId().child("\(selectedShelfDaaru["drinkCity"]!)\(selectedShelfDaaru["drinkCategory"]!)\(selectedShelfDaaru["drinkName"]!)\(selectedShelfDaaru["drinkMeasure"]!)").setValue(["cartTotalPrice":quantityToRedeem * Int("\(selectedShelfDaaru["drinkPrice"]!)")!,"drinkCategory":"\(selectedShelfDaaru["drinkCategory"]!)","drinkCity":"\(selectedShelfDaaru["drinkCity"]!)","drinkMeasure":"\(selectedShelfDaaru["drinkMeasure"]!)","drinkName":"\(selectedShelfDaaru["drinkName"]!)","drinkPrice":"\(selectedShelfDaaru["drinkPrice"]!)","drinkQuantity":quantityToRedeem,"drinkThumbnail":"\(selectedShelfDaaru["drinkThumbnail"]!)","drinkTaxPrice":10,"cartTotalTaxPrice":30  ])
            
            Database.database().reference().child("usertransaction_status").child(UID).child("specialToRedeem").observe(.value, with:{ snapshot in
                
                var dict = snapshot.value as? [String:Any]
                
                if snapshot.exists() && self.trick==0 && "\(dict!["status"]!)" == "success" {
                    
                    self.trick=1
                    spinnerView.removeSelf(completition: {
                        _ = SweetAlert().showAlert("Cheers", subTitle: "Booze Added To Order", style: AlertStyle.success)
                    })
                    
                    Database.database().reference().child("usertransaction_status").child(UID).child("specialToRedeem").removeValue()
                    
                    
                    
                }
                    
                else if snapshot.exists() && self.trick==0 && "\(dict!["status"]!)" == "failed" {
                    
                    self.trick=1
                    spinnerView.removeSelf(completition: {
                        _ = SweetAlert().showAlert("Cheers", subTitle: "Booze Added To Order", style: AlertStyle.success)
                    })
                    
                    Database.database().reference().child("usertransaction_status").child(UID).child("specialToRedeem").removeValue()
                    
                    
                    
                }
                
                
                
                
                
            })
        }
        
        
    }
    
    
    
    
    
    
    
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var _minusButton: UIButton!
    @IBOutlet weak var _plusButton: UIButton!
    @IBOutlet weak var _quantityLabel: UILabel!
    @IBOutlet weak var _measurePrice: UILabel!
    @IBOutlet weak var totalCost: UILabel!
    
    @IBOutlet weak var CashoutButton: UIButton!
    @IBOutlet weak var infoTextView: UITextView!
    @IBOutlet weak var infoImage: UIImageView!
    
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var daaruDetails: UILabel!
    
    @IBOutlet weak var daaruImage: UIImageView!
    
}









extension ShelfSlider {
    func subtractQuantity(){
        
        if quantityToRedeem == 1{
            return
        }
        else{
            quantityToRedeem-=1
            addSliderdownView._minusButton.isUserInteractionEnabled = false
            
            let newFrame = self.addSliderdownView._quantityLabel.frame
            UIView.animate(withDuration: 0.1, animations: {
                self.addSliderdownView._quantityLabel.frame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y, width: newFrame.width, height: 0)
                self.addSliderdownView._quantityLabel.frame.origin.y = newFrame.origin.y + 9
            }) { (Bool) in
                self.changeTotalLabel()
                UIView.animate(withDuration: 0.1, animations: {
                    self.addSliderdownView._quantityLabel.frame.origin.y = newFrame.origin.y - 35
                    /* change label text here*/
                    
                    self.addSliderdownView._quantityLabel.text = "\(quantityToRedeem)"
                    
                }, completion: { (Bool) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.addSliderdownView._quantityLabel.frame = newFrame
                        self.addSliderdownView._minusButton.isUserInteractionEnabled = true})})
            }
        }
        
    }
    
    
    
    func addQuantity(){
        
        if Int("\(selectedShelfDaaru["drinkQuantity"]!)") == quantityToRedeem{
            return
        }
        else{
            quantityToRedeem+=1
            addSliderdownView._plusButton.isUserInteractionEnabled = false
            let newFrame = self.addSliderdownView._quantityLabel.frame
            UIView.animate(withDuration: 0.1, animations: {
                self.addSliderdownView._quantityLabel.frame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y, width: newFrame.width, height: 0)
                self.addSliderdownView._quantityLabel.frame.origin.y = newFrame.origin.y - 9
            }) { (Bool) in
                self.changeTotalLabel()
                UIView.animate(withDuration: 0.1, animations: {
                    self.addSliderdownView._quantityLabel.frame.origin.y = newFrame.origin.y + 35
                    /* change label text here*/
                    
                    
                    self.addSliderdownView._quantityLabel.text = "\(quantityToRedeem)"
                }, completion: { (Bool) in
                    
                    UIView.animate(withDuration: 0.1, animations: {
                        self.addSliderdownView._quantityLabel.frame = newFrame
                        self.addSliderdownView._plusButton.isUserInteractionEnabled = true})})
            }
            
        }
    }
    func changeTotalLabel(){
        let newFrame = self.addSliderdownView.totalCost.frame
        UIView.animate(withDuration: 0.1, animations: {
            self.addSliderdownView.totalCost.frame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y, width: newFrame.width, height: 0)
            self.addSliderdownView.totalCost.frame.origin.y = newFrame.origin.y - 9
        }) { (Bool) in
            UIView.animate(withDuration: 0.1, animations: {
                self.addSliderdownView.totalCost.frame.origin.y = newFrame.origin.y + 35
                /* change label text here*/
                self.addSliderdownView.totalCost.text = "\(quantityToRedeem * Int("\(selectedShelfDaaru["drinkPrice"]!)")!)"
                //self.totalCartprice = self.numberofDaaru * self.unitDaaruPrice
                //print(self.totalCartprice)
                //self.addCartdownView._totolLabel.text = "\(self.totalCartprice)"
                
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.addSliderdownView.totalCost.frame = newFrame })})
        }
    }
    
    func showFeatures(){
        shelfFlag=1
        
        let completion2 = {(accepted: Bool) in
            let highlightController2 = MDCFeatureHighlightViewController(highlightedView: self.addSliderdownView.addToCartButton, completion: nil)
            highlightController2.titleText = "Build Your Order"
            highlightController2.bodyText = "Want to Order drinks on your Shelf at a Pub? Just add drinks you want to order. When done goto Pubs Screen and Order. Simple enough"
            highlightController2.outerHighlightColor =
                UIColor.orange.withAlphaComponent(kMDCFeatureHighlightOuterHighlightAlpha)
            self.present(highlightController2, animated: true, completion: {
                let userdefault1 = UserDefaults.standard
                userdefault1.set(true, forKey: "featureHighlight1")
                
            })
        }
        
        
        let completion1 = {(accepted: Bool) in
            let highlightController1 = MDCFeatureHighlightViewController(highlightedView: self.addSliderdownView.CashoutButton, completion: completion2)
            highlightController1.titleText = "Exchange Drinks"
            highlightController1.bodyText = "Pub dosen't have a drink you own abd want to order? we got you covered. CashOutany drink on your shelf and buy something else using Booze Nation Credits At No Extra  Charge."
            highlightController1.outerHighlightColor =
                UIColor.orange.withAlphaComponent(kMDCFeatureHighlightOuterHighlightAlpha)
            self.present(highlightController1, animated: true, completion:nil)
        }
        
        let highlightController = MDCFeatureHighlightViewController(highlightedView: self.addSliderdownView.giftButton, completion: completion1)
        highlightController.titleText = "Booze Nation Gift Cards"
        highlightController.bodyText = "Gift drinks to your friends. They will be notified immediately and can order that drink at any Booze Nation Partner Pub."
        highlightController.outerHighlightColor =
            UIColor.orange.withAlphaComponent(kMDCFeatureHighlightOuterHighlightAlpha)
        self.present(highlightController, animated: true, completion:nil)
    }
    
}
