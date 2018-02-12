//
//  MenuViewController.swift
//  BoozeNation
//
//  Created by Starlord on 23/08/17.
//  Copyright © 2017 Starlord. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import DropDown

class Pubstableviewcell : UITableViewCell{
    
    @IBOutlet weak var pubsname: UILabel!
    @IBOutlet weak var pubsimage: UIImageView!
    @IBOutlet weak var pubPhoneNumber: UILabel!
    @IBOutlet weak var pubAddress: UILabel!
    @IBOutlet weak var minimumOrder: UILabel!
    @IBOutlet weak var pubOpenHours: UILabel!
    @IBOutlet weak var pubIconImage: UIImageView!
    @IBOutlet weak var backView: UIView!
    
}



class PubsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
 
    var currentPubsArray = [String]()
    var currentPub=String()
    var pubDetailsArray=[[String:Any]]()
    @IBOutlet var _textfieldDropDown: UITextField!
    @IBAction func locationButton(_ sender: Any) {
     self.snakbarcitydikhao()
    }
    
    func downloader(){
        Database.database().reference().child("areas").child("\(CurrentCityLocation)").observe(.value, with: {snapshot in
            
            if let a = snapshot.value as? [String:Any]{
            for item in a{
                let b = item.value as! [String:Any]
                
            self.currentPubsArray.append("\(b["areaname"]!)")
                self._textfieldDropDown.text = "            \(self.currentPubsArray[0])"
            }
            let dropDownView = DropDown()
            dropDownView.reloadAllComponents()
            self.currentPub=self.currentPubsArray[0]
            self.pubChanger()
   
            }
            
        })
  
    }
    func pubChanger(){
        self.pubDetailsArray.removeAll()
        
        Database.database().reference().child("pubs").child("\(CurrentCityLocation)").child(self.currentPub.lowercased()).observe(.childAdded, with: {snapshot1 in
            
            let pubDict = snapshot1.value as! [String:Any]
            
            print(pubDict)
            self.pubDetailsArray.append(pubDict)
            
            
            self.Pubstableview.reloadData()
            
            
        })
        
        self.Pubstableview.reloadData()

       
    }

    var minimumServings=[Int]()
    var pubContacts=[String]()
    var pubStatus=[String]()
    var pubAddresses=[String]()
    var pubsnames = [String]()
    var pubImageUrls=[String]()
    
    @IBOutlet weak var Pubstableview: UITableView!
    
    @IBOutlet weak var floatButton: UIButton!
    
    let dropDownView = DropDown()
    func showDropDown(){
    
        dropDownView.anchorView = _textfieldDropDown
        dropDownView.dataSource = currentPubsArray
        dropDownView.selectionAction = { [unowned self] (index, item) in
            print("Item selected is \(item) at \(index)")
            self._textfieldDropDown.text = "            \(item)"
            self.currentPub=item
            self.pubChanger()
        }
        dropDownView.show()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //giftView.showGiftCard(friendName: "Kamlesh", daaruname: "Soluchan", daaruQuantity: "1 kilo", totalGiftValue: "Life", redeemableCity: "Bihar")
        _textfieldDropDown.layer.cornerRadius = 15.0
        _textfieldDropDown.addTarget(self, action: #selector(showDropDown), for: .touchDown)
        _textfieldDropDown.delegate = self
        let dropImage = #imageLiteral(resourceName: "dropdown (1)");let dropArrow = UIImageView.init(image: dropImage.withRenderingMode(.alwaysTemplate))
        dropArrow.tintColor = UIColor(red: 254/255, green: 99/255, blue: 0/255, alpha: 1.0)
        _textfieldDropDown.rightViewMode = UITextFieldViewMode.unlessEditing
        _textfieldDropDown.rightView = dropArrow
        downloader()
        self.navigationItem.titleView = UIImageView.init(image: UIImage(named: "boozenation_logo.png"))
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 5.0;
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0;
        self.navigationController?.navigationBar.layer.masksToBounds = false;
        self.navigationController?.navigationBar.layer.shadowPath = UIBezierPath(roundedRect:        (self.navigationController?.navigationBar.bounds)!, cornerRadius:        (self.navigationController?.navigationBar.layer.cornerRadius)!).cgPath;
        self.navigationController?.navigationBar.backgroundColor=UIColor.white
        
        floatButton.layer.cornerRadius=floatButton.frame.size.width/2
//        floatButton.layer.shadowColor = UIColor.gray.cgColor
//        floatButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        floatButton.layer.shadowRadius = 7.0;
//        floatButton.layer.shadowOpacity = 2.0;
        floatButton.layer.masksToBounds = false;
        floatButton.layer.shadowPath = UIBezierPath(roundedRect:floatButton.bounds, cornerRadius:floatButton.layer.cornerRadius).cgPath;
        
        
        
        Pubstableview.showsVerticalScrollIndicator = false
        
        self.Pubstableview.delegate = self
        self.Pubstableview.dataSource = self
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pubDetailsArray.count
        
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pubcell", for: indexPath)as! Pubstableviewcell
        cell.backView.layer.borderWidth = 0.1
        cell.backView.layer.borderColor = UIColor.orange.cgColor
        cell.backView.layer.shadowColor = UIColor.orange.cgColor
        cell.backView.layer.shadowRadius = 10.0
        cell.backView.layer.shadowOpacity = 0.8
        cell.backView.layer.masksToBounds = true
        cell.pubsname.text = "\(self.pubDetailsArray[indexPath.row]["name"]!)"
        cell.pubsimage.sd_setImage(with: URL(string: "\(self.pubDetailsArray[indexPath.row]["image"]!)"))
        cell.pubAddress.text="\(self.pubDetailsArray[indexPath.row]["address"]!)"
        cell.pubOpenHours.text="\(self.pubDetailsArray[indexPath.row]["pubstatus"]!)"
        cell.pubPhoneNumber.text="\(self.pubDetailsArray[indexPath.row]["phone"]!)"
        cell.minimumOrder.text="Minimum Order : \(self.pubDetailsArray[indexPath.row]["minredeem"]!) Serving"
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20)
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
   
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 373
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPubForRedeem=self.pubDetailsArray[indexPath.row]
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}





