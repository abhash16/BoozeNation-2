//
//  TransactionHistoryViewController.swift
//  BoozeNation
//
//  Created by Bimlesh Singh on 02/10/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit
import Firebase
class TransactionCell : UITableViewCell{
    
    @IBOutlet weak var TransactionImage: UIImageView!
    
    @IBOutlet weak var transactionLabel1: UILabel!
    
    @IBOutlet weak var transactionLocation: UILabel!
    
    @IBOutlet weak var transactionDate: UILabel!
    
    @IBOutlet weak var transactionTypeAndStatus: UILabel!
    
    @IBOutlet weak var transactionValue: UILabel!
}
class TransactionHistoryViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    var transactionData=[[String:Any]]()
    
    func dataLoader(){
        Database.database().reference().child("user_transactions").child(UID).child("transaction_overview").observe(.childAdded, with:{ snapshot in
            
            let data = snapshot.value as! [String:Any]
            self.transactionData.append(data)
            print(data)
            if self.transactionData.count == 0 {
                let imageView = UIImageView(image: #imageLiteral(resourceName: "cart_empty"))
                imageView.frame.size = CGSize(width: imageView.frame.width/2.0, height: imageView.frame.height/2.0)
                imageView.center = self.view.center
                imageView.contentMode = .scaleAspectFit
                self.view.addSubview(imageView)
            } else {
                self.tableView.reloadData()
            }
        })
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        dataLoader();
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.transactionData.count
    }
   
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactioncell", for: indexPath) as! TransactionCell
        
        if (self.transactionData[indexPath.row]["transaction_type"]! as! String).lowercased() == "redeem"{
           cell.transactionLabel1.text=(self.transactionData[indexPath.row]["transaction_type"]! as! String)
            if let a = (self.transactionData[indexPath.row]["transaction_area"] ){
                cell.transactionLocation.text="\(self.transactionData[indexPath.row]["transaction_area"]!),\(self.transactionData[indexPath.row]["transaction_city"]! )"
                
            }else{
                
               cell.transactionLocation.text="\(self.transactionData[indexPath.row]["transaction_city"]! )"
            }
           cell.transactionDate.text="\(self.transactionData[indexPath.row]["transaction_date"]! )"
            
            cell.transactionValue.text="Transaction Value : \(self.transactionData[indexPath.row]["transaction_value"]! )"
            
            cell.transactionTypeAndStatus.text="\(self.transactionData[indexPath.row]["transaction_type"]!),"
            
        }else if (self.transactionData[indexPath.row]["transaction_type"]! as! String).lowercased() == "gift"{
            
            
        }else if (self.transactionData[indexPath.row]["transaction_type"]! as! String).lowercased() == "cashout"{
            
            
        }else if (self.transactionData[indexPath.row]["transaction_type"]! as! String).lowercased() == "giftie"{
            
            
        }else if (self.transactionData[indexPath.row]["transaction_type"]! as! String).lowercased() == "purchase"{
            
            
        }else if (self.transactionData[indexPath.row]["transaction_type"]! as! String).lowercased() == "expired"{
            
            
        }
       
       // cell.transactionDate.text="\(self.transactionData[indexPath.row]["transaction_date"]!)"
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 144
    }
    
    

}
