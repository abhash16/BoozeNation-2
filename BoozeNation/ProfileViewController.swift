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


class profilecell : UITableViewCell{
    @IBOutlet weak var profilepic: UIImageView!

    @IBOutlet weak var profileBoozeCredit: UILabel!
    @IBOutlet weak var signoutbuttn: UIButton!

    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileEmailId: UILabel!
    
}

class ProfileViewController: UIViewController {
    
    @IBAction func signingOut(_ sender: Any) {
        
        
        do{
            
            try Auth.auth().signOut()
            
           UserDefaults.standard.removeObject(forKey: "uid")
            UserDefaults.standard.removeObject(forKey: "name")
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "phone")
            UserDefaults.standard.removeObject(forKey: "userInfoUpdated")
            UserDefaults.standard.removeObject(forKey: "sex")
            
            
            self.performSegue(withIdentifier: "signOut", sender: self)
            
        }catch{
            
        }
        
        
    }
    
    
    @IBOutlet weak var floatButton: UIButton!
    @IBAction func locationBtn(_ sender: Any) {
        self.snakbarcitydikhao()
    }
    
    
    
    var pcell = ["EDIT","RESET","TRANSACTION","APP","HELP","SIGNOUT"]

    @IBOutlet weak var profiletableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView.init(image: UIImage(named: "boozenation_logo.png"))
        imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.navigationItem.titleView = imageView
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 5.0;
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0;
        self.navigationController?.navigationBar.layer.masksToBounds = false;
        self.navigationController?.navigationBar.layer.shadowPath = UIBezierPath(roundedRect:        (self.navigationController?.navigationBar.bounds)!, cornerRadius:        (self.navigationController?.navigationBar.layer.cornerRadius)!).cgPath;
        self.navigationController?.navigationBar.backgroundColor=UIColor.white

       self.profiletableview.delegate = self
        self.profiletableview.dataSource = self
    
        floatButton.layer.cornerRadius=floatButton.frame.size.width/2
//        floatButton.layer.shadowColor = UIColor.gray.cgColor
//        floatButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        floatButton.layer.shadowRadius = 7.0;
//        floatButton.layer.shadowOpacity = 2.0;
        floatButton.layer.masksToBounds = false;
        floatButton.layer.shadowPath = UIBezierPath(roundedRect:floatButton.bounds, cornerRadius:floatButton.layer.cornerRadius).cgPath;
        

        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func ResetAction(_ sender: Any) {
        
        signoutalert(title: "Are You Sure", message:"You Want To Reset Password for BoozeNation Account abc@gmail.com " )
    }
    func signoutalert (title:String,message:String)
        
    {
        
        
        
        let alert = UIAlertController(title:title,message:message,preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title:"YES", style:UIAlertActionStyle.default , handler :{(action) in
            
            alert.dismiss(animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title:"NO", style:UIAlertActionStyle.default , handler : {(action) in
            alert.dismiss(animated: true, completion: nil)
            
            
        }))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    

        
        
    
   }

extension ProfileViewController : UITableViewDelegate,UITableViewDataSource{

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            
            return 1
        }else{
            
            return 6
        }
    }
    
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var finalcell = UITableViewCell()
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilecell", for: indexPath)as! profilecell
            cell.profilepic.layer.cornerRadius = cell.profilepic.frame.size.height/2
            cell.profilepic.layer.borderWidth = 0.0
            cell.profilepic.layer.masksToBounds = true
            cell.signoutbuttn.layer.cornerRadius = 15
            cell.signoutbuttn.layer.masksToBounds = true
            
            cell.profileEmailId.text=UserDefaults.standard.object(forKey: "email") as! String
            cell.profileName.text=UserDefaults.standard.object(forKey: "name")as! String
            if UserDefaults.standard.object(forKey: "sex")as! String == "Male"{
                cell.profilepic.image=UIImage(named: "gender_male.png")
            }else
            {
                cell.profilepic.image=UIImage(named: "gender_female.png")
            }

            finalcell = cell
                      
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier:pcell[indexPath.item], for: indexPath)
            
            finalcell = cell
          }
        return finalcell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 150
            
        }else{
            return 50
            
        }
    }
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }



}




