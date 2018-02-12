//
//  ShelfViewController.swift
//  BoozeNation
//
//  Created by Starlord on 23/08/17.
//  Copyright © 2017 Starlord. All rights reserved.

//
import UIKit
import Firebase

var isRedeemCartEmpty=true
var whichbutton:Int = 0
 class ShelfViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBAction func locationButton(_ sender: Any) {
        self.snakbarcitydikhao()
    }
    @IBOutlet var cartNotifier: UIView!
    @IBAction func _buttonInsideCartNotifier(_ sender: Any) {
        
    }
    @IBOutlet weak var floatButton: UIButton!
    @IBOutlet var mainView: UIView!
    var initialHeightofCartNotifier = CGFloat() ; var initialWidthofCartNotifier = CGFloat()

    
    @IBOutlet weak var shelfItemsCollectionView: UICollectionView!
    
    @IBOutlet weak var boozeShelfBtn: UIButton!
    @IBAction func boozeShelfBtnAction(_ sender: Any) {
        whichbutton = 0
        shelfDetailsArray=normalDrinksArray

        boozeShelfBtn.backgroundColor = UIColor.orange
        ticketsBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        if normalDrinksArray.count>0{
        imageView.removeFromSuperview()
        shelfItemsCollectionView.reloadData()
       
        }else{
            shelfItemsCollectionView.reloadData()

          
            self.mainView.addSubview(self.imageView)
            
        }
    }
    @IBOutlet weak var ticketsBtn: UIButton!
    @IBAction func ticketsBtnAction(_ sender: Any) {
        whichbutton = 1
        shelfDetailsArray=specialsAndEventsArray

        ticketsBtn.backgroundColor = UIColor.orange
        boozeShelfBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        if specialsAndEventsArray.count>0{
            imageView.removeFromSuperview()
        shelfItemsCollectionView.reloadData()
       
        }else{
            shelfItemsCollectionView.reloadData()

          
            self.mainView.addSubview(self.imageView)
            
        }
    }
    

    func cartChecker(){
        Database.database().reference().child("userredeemcart").child(UID).observe(.value, with:{ snapshot in
            
            
            if(snapshot.childrenCount>0){
                isRedeemCartEmpty=false
                self.showCartNotifier()
            }
                
            else{
                isRedeemCartEmpty=true
                self.cartNotifier.removeFromSuperview()
                
            }
            
        })
        
    }
    
    func aiseHi(){}
    var myShelfValue=0
    var shelfDetailsArray=[[String:Any]]()
    var sum=0
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        shelfFetcher()
        cartChecker()
    }
    let imageView = UIImageView(image: #imageLiteral(resourceName: "emptybar"))

    var normalDrinksArray=[[String:Any]]()
    var specialsAndEventsArray=[[String:Any]]()
    open func shelfFetcher(){
        self.myShelfValue=0
        self.shelfDetailsArray.removeAll()
        self.normalDrinksArray.removeAll()
        self.specialsAndEventsArray.removeAll()
        Database.database().reference().child("userbar").child("\(UID)").child("\(CurrentCityLocation)").observeSingleEvent(of: .value, with:{ snapshot in
            self.imageView.removeFromSuperview()
            var dictionary=[String:Any]()
            if snapshot.exists(){
            dictionary=snapshot.value as! [String:Any]
            var item=[String:Any]()
            for item  in dictionary {
                let innerItem=item.value as! [String:Any]
                self.myShelfValue += Int("\(innerItem["cartTotalPrice"]!)")!
            
                
                if innerItem["drinkCategory"] as! String == "Specials" || innerItem["drinkCategory"] as! String == "Events"{
                    
                    self.specialsAndEventsArray.append(item.value as! [String : Any])
                    
                }else{
                    
                    self.normalDrinksArray.append(item.value as! [String : Any])

                    
                }
                if whichbutton == 0 {
                    if self.normalDrinksArray.count>0{
                        self.imageView.removeFromSuperview()

                    self.shelfDetailsArray=self.normalDrinksArray
                    self.shelfItemsCollectionView.reloadData()
                    }else{
                        self.shelfItemsCollectionView.reloadData()

                        
                        self.mainView.addSubview(self.imageView)
                        
                    }

                } else {
                    
                    if self.specialsAndEventsArray.count>0{
                        self.imageView.removeFromSuperview()
                   self.shelfDetailsArray=self.specialsAndEventsArray
                    self.shelfItemsCollectionView.reloadData()
                    }else{
                        self.shelfItemsCollectionView.reloadData()

                       
                        self.mainView.addSubview(self.imageView)
                    }

                }
                
                
            
               // self.shelfItemsCollectionView.reloadData()
            
            print(dictionary)
            
            }
            
            }
            
            else{
               
                self.mainView.addSubview(self.imageView)
                self.shelfItemsCollectionView.reloadData()

            }
            
        })
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.frame.size = CGSize(width: self.imageView.frame.width/2.0, height: imageView.frame.height/2.0)
        self.imageView.center = self.shelfItemsCollectionView.center
        
        
        aiseHi()
        
        
     self.navigationItem.titleView = UIImageView.init(image: UIImage(named: "boozenation_logo.png"))
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.4, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 5.0;
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0;
        self.navigationController?.navigationBar.layer.masksToBounds = false;
        self.navigationController?.navigationBar.layer.shadowPath = UIBezierPath(roundedRect:        (self.navigationController?.navigationBar.bounds)!, cornerRadius:        (self.navigationController?.navigationBar.layer.cornerRadius)!).cgPath;
        self.navigationController?.navigationBar.backgroundColor=UIColor.white
        cartNotifier.center = CGPoint(x: self.view.frame.width/2, y:shelfItemsCollectionView.frame.origin.y+25)
        initialHeightofCartNotifier = cartNotifier.frame.height;initialWidthofCartNotifier = cartNotifier.frame.width
        cartNotifier.frame.size.height = 0 ; cartNotifier.frame.size.width = 0
        
        floatButton.layer.cornerRadius=floatButton.frame.size.width/2
//        floatButton.layer.shadowColor = UIColor.gray.cgColor
//        floatButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        floatButton.layer.shadowRadius = 7.0;
//        floatButton.layer.shadowOpacity = 2.0;
        floatButton.layer.masksToBounds = false;
        floatButton.layer.shadowPath = UIBezierPath(roundedRect:floatButton.bounds, cornerRadius:floatButton.layer.cornerRadius).cgPath;
        

        
        
        let width = (mainView.frame.size.width - 26) / 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width+25)
        layout.sectionInset.left=8.0
        layout.sectionInset.right=8.0
        layout.sectionInset.top=8.0

        shelfItemsCollectionView.collectionViewLayout=layout
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if whichbutton == 1 {
            return shelfDetailsArray.count
        } else {
            return shelfDetailsArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if whichbutton == 1 {
            ticketsBtn.backgroundColor = UIColor.orange
            boozeShelfBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
            let item = collectionView.dequeueReusableCell(withReuseIdentifier: "largeitem", for: indexPath) as! shelfLargeCell
            item.frame.size.width = shelfItemsCollectionView.frame.width
            item._imageView.sd_setImage(with: URL(string: shelfDetailsArray[indexPath.row]["drinkThumbnail"]! as! String))
            item._eventName.text="\(shelfDetailsArray[indexPath.row]["drinkName"]! as! String) (\(shelfDetailsArray[indexPath.row]["drinkCategory"]!))"
            item._entryLabel.text="\(shelfDetailsArray[indexPath.row]["drinkQuantity"]!) \(shelfDetailsArray[indexPath.row]["drinkMeasure"]!)"
            item._priceLabel.text="Total price: \(shelfDetailsArray[indexPath.row]["cartTotalPrice"]! )"
            
            item.frame.size.height = 230
            
            return item
        } else {
            boozeShelfBtn.backgroundColor = UIColor.orange
            ticketsBtn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! shelfCell
        
        item.shelfDaaruItems.sd_setImage(with: URL(string: shelfDetailsArray[indexPath.row]["drinkThumbnail"]! as! String))
        item.shelfDaaruName.text="\(shelfDetailsArray[indexPath.row]["drinkName"]! as! String) (\(shelfDetailsArray[indexPath.row]["drinkCategory"]!))"
        item.shelfDaaruMeasure.text="\(shelfDetailsArray[indexPath.row]["drinkQuantity"]!) \(shelfDetailsArray[indexPath.row]["drinkMeasure"]!)"
        item.shelfDaaruPrice.text="Total price: \(shelfDetailsArray[indexPath.row]["cartTotalPrice"]! )"
        
        item.layer.shadowColor = UIColor.gray.cgColor
        item.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        item.layer.shadowRadius = 1.0;
        item.layer.shadowOpacity = 1.0;
        item.layer.masksToBounds = false;
        item.layer.shadowPath = UIBezierPath(roundedRect:item.bounds, cornerRadius:item.contentView.layer.cornerRadius).cgPath;
        return item
        }
    }
    let addvc = ShelfSlider()  ;
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.shelfDetailsArray.count)>0{
            addvc.modalPresentationStyle = .overCurrentContext
        selectedShelfDaaru=self.shelfDetailsArray[indexPath.item]
        self.present(addvc, animated: false, completion: nil)
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.cartNotifier.removeFromSuperview()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isCartEmpty == false{
            showCartNotifier()
        }
    }
     
    
    
    
    
    func showCartNotifier(){
        if isRedeemCartEmpty==false{
            self.cartNotifier.isHidden=false
        }
        self.mainView.addSubview(cartNotifier)
        self.cartNotifier.frame.size.width = self.initialWidthofCartNotifier
        self.cartNotifier.frame.size.height = self.initialHeightofCartNotifier
        cartNotifier.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowAnimatedContent, animations: {
            self.cartNotifier.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    

}

class shelfCell : UICollectionViewCell{
    @IBOutlet weak var shelfDaaruItems: UIImageView!

    @IBOutlet weak var shelfDaaruName: UILabel!
    
    @IBOutlet weak var shelfDaaruMeasure: UILabel!
    
    @IBOutlet weak var shelfDaaruPrice: UILabel!
}

class shelfLargeCell : UICollectionViewCell{
    @IBOutlet weak var _imageView: UIImageView!
    @IBOutlet weak var _eventName: UILabel!
    @IBOutlet weak var _entryLabel: UILabel!
    @IBOutlet weak var _priceLabel: UILabel!
    
}
