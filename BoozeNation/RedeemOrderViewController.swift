//
//  RedeemOrderViewController.swift
//  BoozeNation
//
//  Created by Bimlesh Singh on 10/11/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit
import Firebase
var redeemCartTotalValue=0
class RedeemOrderTableViewCell : UITableViewCell{
    
    @IBOutlet var drinkImage: UIImageView!
    
    @IBOutlet var drinkName: UILabel!
    
    @IBOutlet var drinkQuantity: UILabel!
    
    @IBOutlet var delhiPrice: UILabel!
    @IBOutlet var totalPrice: UILabel!
    
}
class RedeemOrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet var OrderTabelView: UITableView!
    
    var redeemCartDetails=[[String:Any]]()
    
    
    @IBOutlet var orderValue: UILabel!
    @IBAction func SelectButton(_ sender: Any) {
        
    }
    
    @IBOutlet weak var selectPubButton: UIButton!
    
    func loadRedeemCart(){

      
        redeemCartTotalValue=0
        self.redeemCartDetails.removeAll()
        let ref = Database.database().reference().child("userredeemcart").child(UID)
        
            ref.observeSingleEvent(of: .value, with: {
            
            snapshot in
            if snapshot.exists(){
            var dictionary = [String:Any]()
            var item=[String:Any]()
            
            dictionary=snapshot.value as! [String:Any]
            
            for item in dictionary{
                
                let inneritem = item.value as! [String:Any]
                
                redeemCartTotalValue += Int("\(inneritem["cartTotalPrice"]!)")!

                self.orderValue.text="\(redeemCartTotalValue)"

                self.redeemCartDetails.append(inneritem)
                
                
                self.OrderTabelView.reloadData()
                
                }
                
            }
            else{
                self.OrderTabelView.reloadData()
                self.orderValue.text="\(redeemCartTotalValue)"

            }
         
          ref.removeAllObservers()
            
        })
        
        
        
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadRedeemCart()
    }
    
    let emptyView=UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    OrderTabelView.delegate = self
        OrderTabelView.dataSource = self
        
        self.emptyView.image=#imageLiteral(resourceName: "cart_empty")
        self.emptyView.contentMode = .scaleAspectFit
        self.emptyView.frame.size=self.OrderTabelView.frame.size
        self.emptyView.frame.size=CGSize(width: self.emptyView.frame.width/2.0, height: emptyView.frame.height/2.0)
        self.emptyView.center=self.OrderTabelView.center
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\nindexx  == \(redeemCartDetails.count) ")
        return redeemCartDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderrow", for: indexPath) as!RedeemOrderTableViewCell
        
        
        cell.drinkName.text = "\(redeemCartDetails[indexPath.row]["drinkName"]!)"
        cell.drinkQuantity.text = "\(redeemCartDetails[indexPath.row]["drinkQuantity"]!) \(redeemCartDetails[indexPath.row]["drinkMeasure"]!)"
        cell.delhiPrice.text = "\(redeemCartDetails[indexPath.row]["drinkPrice"]!)"
        cell.totalPrice.text = "\(redeemCartDetails[indexPath.row]["cartTotalPrice"]!)"
        cell.drinkImage.sd_setImage(with: URL(string: "\(redeemCartDetails[indexPath.row]["drinkThumbnail"]!)"))

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 131
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
   ////////////////////////////////////////////
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        print("ghusa === \(indexPath.row)")
        let deleteRow = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
            
            Database.database().reference().child("usertransaction_status").child(UID).child("removeFromRedeem").removeValue()
            
            
            spinnerView.showSpinner(ttitle: "Removing Drink From Order ..", text: "Please Be Patient...")
            
            Database.database().reference().child("removefromredeemcart").child(UID).child(("\(self.redeemCartDetails[indexpath.row]["drinkCity"]!)\(self.redeemCartDetails[indexpath.row]["drinkCategory"]!)\(self.redeemCartDetails[indexpath.row]["drinkName"]!)\(self.redeemCartDetails[indexpath.row]["drinkMeasure"]!)").lowercased()).setValue("true", withCompletionBlock: { (error, snap) in
                
                
                redeemCartTotalValue-=Int("\(self.redeemCartDetails[indexPath.row]["cartTotalPrice"]!)")!
                self.orderValue.text="\(redeemCartTotalValue)"
                
                
                Database.database().reference().child("usertransaction_status").child(UID).child("removeFromRedeem").observe(.value, with:{ snapshot in
                    
                    var dict = snapshot.value as? [String:Any]
                    
                    if snapshot.exists(){
                        
                        if "\(dict!["status"]!)" == "success" {
                            Database.database().reference().child("usertransaction_status").child(UID).child("removeFromRedeem").removeAllObservers()
                            if self.redeemCartDetails.count>0{
                                self.redeemCartDetails.remove(at: indexPath.row)
                                tableView.deleteRows(at: [indexpath], with: .fade)
                                
                                if self.redeemCartDetails.count==0{
                                    self.emptyCartImageSetter()
                                }
                            }else{
                                tableView.reloadData()
                            }
                            
                            
                            
                            spinnerView.removeSelf(completition: {
                                
                            })
                            
                        }else{
                            spinnerView.removeSelf(completition: {
                                
                            })
                            
                            _ = SweetAlert().showAlert("Uh-Oh!", subTitle: "could not remove the drink..try again", style: AlertStyle.error)
                            
                        }
                        
                        
                    }
                    
                })
                
            })
            
           
            Database.database().reference().child("usertransaction_status").child(UID).child("removeFromRedeem").removeValue()
            
            
            
        }
        
        return [deleteRow]
        
    }
    
    
    func emptyCartImageSetter(){
        
        self.selectPubButton.isUserInteractionEnabled=false
        self.selectPubButton.titleLabel?.textAlignment = .center
        self.selectPubButton.setTitle("Redeem Cart Empty", for: .normal)

        self.view.addSubview(self.emptyView)
        
    }
    
    func emptyCartImageRemover(){
        self.emptyView.removeFromSuperview()
    }
    
    
   
}
