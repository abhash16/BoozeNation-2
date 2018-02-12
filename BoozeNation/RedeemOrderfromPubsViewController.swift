//
//  RedeemOrderfromPubsViewController.swift
//  BoozeNation
//
//  Created by Bimlesh Singh on 11/11/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit 
import Firebase



var selectedPubForRedeem=[String:Any]()
class RedeemOrderfromPubsTVCell: UITableViewCell{
    
    @IBOutlet var OrderBeerImage: UIImageView!
    
    @IBOutlet var OrderBeerBrand: UILabel!
    
    @IBOutlet var OrderBeerQuantity: UILabel!
    
    @IBOutlet var DelhiPrice: UILabel!
    @IBOutlet var TotalPrice: UILabel!
    
    @IBOutlet weak var City: UILabel!
    
    
}

class RedeemOrderfromPubsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    var pubDetail=[String:Any]()
    
    @IBOutlet weak var redeemAtPubButton: UIButton!
    
    @IBOutlet var RedeemOrderFPTableView: UITableView!
    
    
    @IBOutlet var ReedemCartValue: UILabel!
    
    @IBOutlet var PubsImage: UIImageView!
    
    @IBOutlet var PubsName: UILabel!
    
    @IBOutlet var PubsAddress: UILabel!
    @IBOutlet var PubsContactNo: UILabel!
    
    
    
    
    @IBAction func addMoreDrinksToRedeem(_ sender: Any) {
        
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
       
        if viewControllers.count>3{
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
        }else{
            
            tabBarController?.selectedIndex=3
            
        }
        
        
    }
    
    
    
    
    
    var orderDetailsArray = [[String:Any]]()
    
    func loadRedeemCart(){
        
        self.orderDetailsArray.removeAll()
        redeemCartTotalValue=0
 Database.database().reference().child("userredeemcart").child(UID).observeSingleEvent(of: .value, with: {
            
            snapshot in
            if snapshot.exists(){
            var dictionary = [String:Any]()
            var item=[String:Any]()
            
            dictionary=snapshot.value as! [String:Any]
            
            for item in dictionary{
                
                let inneritem = item.value as! [String:Any]
                
                redeemCartTotalValue += Int("\(inneritem["cartTotalPrice"]!)")!
                
                self.ReedemCartValue.text="\(redeemCartTotalValue)"

            self.orderDetailsArray.append(inneritem)
            
            self.RedeemOrderFPTableView.reloadData()
            
                
            }
            }
            else{
                self.orderDetailsArray.removeAll()
            self.RedeemOrderFPTableView.reloadData()
                if self.orderDetailsArray.count==0{
                    self.emptyCartImageSetter()
                }
             self.ReedemCartValue.text="0"

            }
        })
        
        
    
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadRedeemCart()
    }
    
    let emptyView=UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emptyView.image=#imageLiteral(resourceName: "cart_empty")
        self.emptyView.contentMode = .scaleAspectFit
        self.emptyView.frame.size=self.RedeemOrderFPTableView.frame.size
        self.emptyView.frame.size=CGSize(width: self.emptyView.frame.width/2.0, height: emptyView.frame.height/2.0)
        self.emptyView.center=self.RedeemOrderFPTableView.center
        self.PubsName.text="\(selectedPubForRedeem["name"]!)"
        self.PubsContactNo.text="\(selectedPubForRedeem["phone"]!)"
        
        self.PubsAddress.text="\(selectedPubForRedeem["address"]!)"
        
        
        self.ReedemCartValue.text="\(redeemCartTotalValue)"
        RedeemOrderFPTableView.delegate = self
        RedeemOrderFPTableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    
    
   var trick=0
    
    @IBAction func redeemAtPub(_ sender: Any) {
        _ = SweetAlert().showAlert("Place Order", subTitle: "You are ordering drinks at \(selectedPubForRedeem["name"]) ", style: AlertStyle.customImag(imageFile: "buybeer.png"), buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "order", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
            if isOtherButton == true {
                
                print("Cancel Button  Pressed", terminator: "")
            }
            else {
                spinnerView.showSpinner(ttitle: "Redeeming Your Order ..", text: "Please Be Patient...")

        Database.database().reference().child("usertransaction_status").child(UID).child("redeemSpecial").removeValue()

    Database.database().reference().child("usertransaction_status").child(UID).child("RedeemAtPub").removeValue()
        
       self.trick=0
        
        
        
        
        let date : Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy hh:mm:ss a"
        let todaysDate = dateFormatter.string(from: date)
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        let tSorter = -1 * (Date().timeIntervalSince1970 * 1000)

        
        let pid=Database.database().reference().child("user_queue").child(UID).child("user_transactions").child("transaction_overview").childByAutoId()
        
        let oId = pid.key.substring(from:pid.key.index(pid.key.endIndex, offsetBy: -6))

        pid.setValue(["transaction_date":"\(todaysDate)","transaction_pub":"\(selectedPubForRedeem["name"]!)","transaction_area":"\(selectedPubForRedeem["address"]!)","transaction_sort":tSorter,"transaction_pushkey":"\(pid.key)","transactionUID":UID,"transaction_pubuid":"\(selectedPubForRedeem["pubuid"]!)","transaction_type":"redeem","transaction_value":"\(redeemCartTotalValue)","transaction_city":"\(CurrentCityLocation)"])
        
        
        Database.database().reference().child("usertransaction_status").child(UID).child("RedeemAtPub").observe(.value, with:{ snapshot in
            
            var dict = snapshot.value as? [String:Any]
            
            if snapshot.exists() && self.trick==0 && "\(dict!["status"]!)" == "success" {

                self.trick=1
                spinnerView.removeSelf(completition: {
                    _ = SweetAlert().showAlert("Done", subTitle: "Booze Added To Your BarYour", style: AlertStyle.success, buttonTitle: "OK", action: { (gaand) in
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                    
                })
               
                //self.loadRedeemCart()

                Database.database().reference().child("usertransaction_status").child(UID).child("RedeemAtPub").removeValue()

                
            }
            
        })
                
                
                Database.database().reference().child("usertransaction_status").child(UID).child("redeemSpecial").observe(.value, with:{ snapshot in
                    
                    var dict = snapshot.value as? [String:Any]
                    
                    if snapshot.exists() && self.trick==0 && "\(dict!["status"]!)" == "success" {
                        
                        self.trick=1
                        spinnerView.removeSelf(completition: {
                            _ = SweetAlert().showAlert("Done", subTitle: "Booze Added To Your BarYour", style: AlertStyle.success, buttonTitle: "OK", action: { (gaand) in
                                self.navigationController?.popToRootViewController(animated: true)
                            })
                            
                        })
                        
                        //self.loadRedeemCart()
                        
                        Database.database().reference().child("usertransaction_status").child(UID).child("redeemSpecial").removeValue()
                        
                        
                    }
                    
                })
                
                
                
                
                
                
            }}
    
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetailsArray.count
        // return orderDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Redeemorderrow", for: indexPath) as! RedeemOrderfromPubsTVCell
        
        
                cell.OrderBeerBrand.text = "\(orderDetailsArray[indexPath.row]["drinkName"]!)"
                cell.OrderBeerQuantity.text = "\(orderDetailsArray[indexPath.row]["drinkQuantity"]!) \(orderDetailsArray[indexPath.row]["drinkMeasure"]!)"
        cell.DelhiPrice.text = "\(orderDetailsArray[indexPath.row]["drinkPrice"]!)"
                cell.TotalPrice.text = "\(orderDetailsArray[indexPath.row]["cartTotalPrice"]!)"
                cell.OrderBeerImage.sd_setImage(with: URL(string:"\(orderDetailsArray[indexPath.row]["drinkThumbnail"]!)"))
        cell.City.text="\(orderDetailsArray[indexPath.row]["drinkCity"]!) Price"
        
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
            
            
            Database.database().reference().child("usertransaction_status").child(UID).child("removeFromRedeem").removeValue()
            
            spinnerView.showSpinner(ttitle: "Removing Drink From Order ..", text: "Please Be Patient...")
            
            
            Database.database().reference().child("removefromredeemcart").child(UID).child(("\(self.orderDetailsArray[indexPath.row]["drinkCity"]!)\(self.orderDetailsArray[indexPath.row]["drinkCategory"]!)\(self.orderDetailsArray[indexPath.row]["drinkName"]!)\(self.orderDetailsArray[indexPath.row]["drinkMeasure"]!)").lowercased()).setValue("true", withCompletionBlock: { (error, snap) in
                
                Database.database().reference().child("usertransaction_status").child(UID).child("removeFromRedeem").observe(.value, with:{ snapshot in
                    
                    var dict = snapshot.value as? [String:Any]
                    
                    if snapshot.exists(){
                        
                        
                        if "\(dict!["status"]!)" == "success"{
                            
                            Database.database().reference().child("usertransaction_status").child(UID).child("removeFromRedeem").removeAllObservers()
                            redeemCartTotalValue -= Int("\(self.orderDetailsArray[indexPath.row]["cartTotalPrice"]!)")!
                            
                            self.ReedemCartValue.text="\(redeemCartTotalValue)"
                            
                            if self.orderDetailsArray.count>0{
                                self.orderDetailsArray.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexPath], with: .fade)
                                
                                if self.orderDetailsArray.count==0{
                                    self.emptyCartImageSetter()
                                }
                                
                            }
                            else{
                                tableView.reloadData()
                            }
                            spinnerView.removeSelf(completition: {})
                            
                        }else{
                            
                            spinnerView.removeSelf(completition: {})
                            
                            
                        }
                        
                        
                        Database.database().reference().child("usertransaction_status").child(UID).child("removeFromRedeem").removeValue()
                        
                    }
                    
                })
                
                
                
            })
            
            
            
            
            
            
        }
        return [deleteRow]
        
    }
   
    
    
    func emptyCartImageSetter(){
        
        self.redeemAtPubButton.isUserInteractionEnabled=false
        self.redeemAtPubButton.titleLabel?.textAlignment = .center
        self.redeemAtPubButton.setTitle("Redeem Cart Empty", for: .normal)
        
        self.view.addSubview(self.emptyView)
        
    }
    
    func emptyCartImageRemover(){
        self.emptyView.removeFromSuperview()
    }
    
    
    

}
