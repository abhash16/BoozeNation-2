//  MenuViewController.swift
//  BoozeNation
//
//  Created by Starlord on 23/08/17.
//  Copyright © 2017 Starlord. All rights reserved.
//
import UIKit
import FirebaseCore
import FirebaseDatabase
import Canvas
import SwiftGifOrigin
import MaterialComponents.MaterialSnackbar
var isCartEmpty = true // Global to show circular reveler on menu
var collectionClicked = false
var currentStripItem = String()
var  pastItem = String()
class MenuViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    @IBOutlet var cartNotifier: UIView!   //shows added to casrt notification on screen
    
    @IBAction func _buttonInsideCartNotifier(_ sender: Any) {
        moveToCartView()
    }
    @IBOutlet weak var animationViewforStripView: CSAnimationView!
    @IBOutlet weak var animationMainCollectionView: UIView!
    @IBOutlet weak var floatButton: UIButton!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var stripView: UICollectionView!
    @IBOutlet weak var mainCollection: UICollectionView!
    var mainDaaruNames=[[String:Any]]()
    let stripItemTitles=["beer","whiskey","vodka","rum","wine","cocktail","mocktail","specials","event"]
    var stripItems = ["beer.png","whiskey.png","vodka.png","rum.png","wine.png","cocktail.png","mocktails.png","specials-2.png","event_transaction.png"]
    var blackStripItems = [UIImage]()
    var mystring=[String]()
    var hogya = false
    
    override func viewWillAppear(_ animated: Bool) {
        loadItem(completition: {
            
        })
        stripView.reloadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        cartNotifier.frame.size.height = 0 ; cartNotifier.frame.size.width = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        if(!hogya){
            animationViewforStripView.startCanvasAnimation()
          csAnime()
           hogya = true
        }
        cartChecker()
    }
    func csAnime(){
        animationMainCollectionView.startCanvasAnimation()
    }
   //image for loader::::::::::::::::::::::::::
    let leloIMAGE=UIImageView()
    
    var initialHeightofCartNotifier = CGFloat()
    var initialWidthofCartNotifier = CGFloat()
    
    func cartChecker(){
        Database.database().reference().child("usercart").child(UID).observe(.value, with:{ snapshot in
            
            
            if(snapshot.childrenCount>0){
                isCartEmpty=false
                self.showCartNotifier()
            }
            
            else{
                isCartEmpty=true
                self.cartNotifier.removeFromSuperview()
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      // cartChecker()
     cartNotifier.center = CGPoint(x: self.view.frame.width/2, y: stripView.frame.height*2.8)
        initialHeightofCartNotifier = cartNotifier.frame.height;initialWidthofCartNotifier = cartNotifier.frame.width
        cartNotifier.frame.size.height = 0 ; cartNotifier.frame.size.width = 0
        let notificationName = NSNotification.Name("notificationsegueofmenu")
        NotificationCenter.default.addObserver(self, selector: #selector(moveToCartView), name: notificationName, object: nil)
        
        //loder dimension:::::::::::::::::::::::::::::::::::::::::::
        leloIMAGE.image=UIImage(named: "bar1.png")
        leloIMAGE.frame.size=self.mainCollection.frame.size
       // self.mainCollection.addSubview(leloIMAGE)
        addLoadingScreen()
        
        
        hogya = false
        stripView.dataSource=self
        stripView.delegate=self
        mainCollection.dataSource=self
        mainCollection.delegate=self
 
        
        self.navigationItem.titleView = UIImageView.init(image: UIImage(named: "boozenation_logo.png"))
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2.0;
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0;
        self.navigationController?.navigationBar.layer.masksToBounds = false;
        self.navigationController?.navigationBar.layer.shadowPath = UIBezierPath(roundedRect:        (self.navigationController?.navigationBar.bounds)!, cornerRadius:        (self.navigationController?.navigationBar.layer.cornerRadius)!).cgPath;
        self.navigationController?.navigationBar.backgroundColor=UIColor.white
        print("viewdidload")
        for items in stripItems {
            let ciimg = CIImage.init(image: UIImage(named: items)!)?.applyingFilter("CIPhotoEffectMono", withInputParameters: nil)
            let newBlackImg = UIImage(ciImage: ciimg!)
            blackStripItems.append(newBlackImg)
            
        }
       
        let width = (mainView.frame.size.width - 32) / 2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width+25)
        layout.sectionInset.left=8.0
        layout.sectionInset.right=8.0
        layout.sectionInset.top=8.0
        mainCollection.collectionViewLayout=layout
        
        floatButton.layer.cornerRadius=floatButton.frame.size.width/2
//        floatButton.layer.shadowColor = UIColor.gray.cgColor
//        floatButton.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        floatButton.layer.shadowRadius = 7.0;
//        floatButton.layer.shadowOpacity = 2.0;
        floatButton.layer.masksToBounds = false;
        floatButton.layer.shadowPath = UIBezierPath(roundedRect:floatButton.bounds, cornerRadius:floatButton.layer.cornerRadius).cgPath;
   
    }
    
    func showCartNotifier(){
        if isCartEmpty==false{
        self.cartNotifier.isHidden=false
        }
        self.view.addSubview(cartNotifier)
        self.cartNotifier.frame.size.width = self.initialWidthofCartNotifier
        self.cartNotifier.frame.size.height = self.initialHeightofCartNotifier
        cartNotifier.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.5, delay: 0, options: .allowAnimatedContent, animations: {
         self.cartNotifier.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    //loading items for menu screen here::::::::::::::::::::::::::::::;
    func loadItem(completition:(()->())) {
        if currentStripItem==""{
            currentStripItem="beer"
        }
        
        self.mainDaaruNames.removeAll()
        Database.database().reference().child("drinks_menu").child("\(CurrentCityLocation)").child("\(currentStripItem)").observe(.childAdded){(snapshot:DataSnapshot) in

            var dict = [String:Any]()
            dict = snapshot.value as! [String:Any]
            self.mainDaaruNames.append(dict)
            self.mainCollection.reloadData()
        }
        completition()
    }
    
    //Loader:::::::::::::::::::::::::::::::::::::::
    let loadingView = UIView() ; let loadingImageView = UIImageView()
    func addLoadingScreen(){
        let width = mainView.frame.width ; let height = mainView.frame.height
        loadingView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        loadingView.backgroundColor = UIColor.init(red: 245, green: 245, blue: 225, alpha: 1)
        loadingImageView.loadGif(name: "source")
        loadingImageView.frame.size = CGSize(width: 150, height: 150)
        loadingImageView.center.x = loadingView.center.x; loadingImageView.center.y = loadingView.center.y-100
        loadingView.addSubview(loadingImageView)
        loadingView.isHidden = false
        self.mainCollection.addSubview(loadingView)
    }
    func removeLoadingScreen(){
            loadingView.isHidden = true
    }
    
    @IBAction func changeLocation(_ sender: Any) {
        
        self.snakbarcitydikhao()

    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.cartNotifier.removeFromSuperview()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if isCartEmpty == false{
            showCartNotifier()
        }
    }


func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if collectionView==stripView{
            return stripItemTitles.count
        }
            else{
                
                //loader gets hidden here :::::::::::::::::::::::::::::::::::::
                if mainDaaruNames.count != 0 {
                    
                   // self.leloIMAGE.isHidden=true
                    removeLoadingScreen()
                }
                return mainDaaruNames.count
            }
            
    }
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
            if collectionView==stripView{
            let item=collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! stripCell
            item.layer.borderWidth=1.0
            item.layer.borderColor=UIColor(red: 255/255, green: 213/255, blue: 0255, alpha: 0.4).cgColor
            item.layer.cornerRadius=10.0
                if currentStripItem != stripItemTitles[indexPath.item] {
                    item.stripCellImage.image = blackStripItems[indexPath.item]
                }
                else{
                    item.stripCellImage.image = UIImage(named: stripItems[indexPath.item])
                }
            return item
            }
            
            else{
                var reuseCell = UICollectionViewCell()
                if currentStripItem == "event"||currentStripItem == "specials"{
                    let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "largeitem2", for: indexPath) as! mainCollectionLargeCell
                    cell.frame.size.width = collectionView.frame.size.width
                    cell.frame.size.height = 231
                    cell._eventNameLabel.text=mainDaaruNames[indexPath.item]["drinkName"]! as! String
                    
                    cell._imageView.sd_setImage(with: URL(string: mainDaaruNames[indexPath.item]["thumbnail"]! as! String))
                    cell._priceLabel.text="₹ \(mainDaaruNames[indexPath.item]["drinkPrice"]!)"
                    
                    cell._eventVenueLabel.text=mainDaaruNames[indexPath.item]["drinkPub"]! as! String
                    
                    cell._eventType.text=mainDaaruNames[indexPath.item]["drinkCategory"]! as! String
                    
                    reuseCell = cell
                }
                else{
       
                print("\n\ncurrent strip item == \(currentStripItem)\n\n")
        
                let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "item2", for: indexPath) as! mainCollectionCell
                
               cell.mainCellImageView.sd_setImage(with: URL(string: mainDaaruNames[indexPath.item]["thumbnail"]! as! String))
                    
                   print(mainDaaruNames[indexPath.item]["drinkOffer"]!)
                    print("wfdsf")
                    
               let offer = mainDaaruNames[indexPath.item]["drinkOffer"]! as! Int
                    
                    if offer == 1{
                    cell.offerImage.isHidden=false
                        
                    }
                    else{
                       cell.offerImage.isHidden=true
                    }
                cell.daaruNamelabel.text=mainDaaruNames[indexPath.item]["drinkName"]! as! String
                cell.daaruTypeLabel.text=mainDaaruNames[indexPath.item]["drinkCategory"]! as! String
            
                    cell.mainDaaruPrice.text="₹ \(mainDaaruNames[indexPath.item]["drinkPrice"]!)"
                cell.frame.size.width=(collectionView.frame.size.width-16)/2
            
                cell.layer.shadowColor = UIColor.gray.cgColor
                cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
                cell.layer.shadowRadius = 1.0;
                cell.layer.shadowOpacity = 1.0;
                cell.layer.masksToBounds = false;
                cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath;
                
               reuseCell = cell
    }
                return reuseCell
            }
            
    }
    let addvc = MenuSlider()
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       // mainDaaruNames.removeAll()
        
        if collectionView == stripView{
            
            let item = collectionView.cellForItem(at: indexPath) as! stripCell
           print(stripItemTitles[indexPath.item])
            //item.animationViewforStripItems.startCanvasAnimation()
            if currentStripItem != stripItemTitles[indexPath.item]{
            //self.leloIMAGE.isHidden=false
            addLoadingScreen()
           
            print("lolo,\(indexPath.item)")
           // pastItem = currentStripItem
            currentStripItem=stripItemTitles[indexPath.item]
            stripView.reloadData()
            self.loadItem(completition: {
                self.csAnime()
            })
            }
        }
        else if collectionView==mainCollection{
            
                //let cell = collectionView.cellForItem(at: indexPath) as! mainCollectionCell
            addvc.selectedMenuDetailsDictionary=mainDaaruNames[indexPath.row]

            print("lololove")
            addvc.modalPresentationStyle = .overCurrentContext
            self.present(addvc, animated: false, completion: nil)
            print("lolo")

        }
}
    func moveToCartView(){
        print("move 2 sefue func")
        self.performSegue(withIdentifier: "showcartpage", sender: self)
    }

}
class stripCell:UICollectionViewCell{
    
    @IBOutlet weak var stripCellImage: UIImageView!
    @IBOutlet weak var animationViewforStripItems: CSAnimationView!
}

class mainCollectionCell:UICollectionViewCell{
    
    @IBOutlet weak var mainCellImageView: UIImageView!
    
    @IBOutlet weak var daaruNamelabel: UILabel!
    
    @IBOutlet weak var daaruTypeLabel: UILabel!
    
    @IBOutlet weak var mainDaaruPrice: UILabel!
    
    @IBOutlet weak var offerImage: UIImageView!
    
}
    
    class mainCollectionLargeCell:UICollectionViewCell{
        @IBOutlet weak var _imageView: UIImageView!
        @IBOutlet weak var _eventVenueLabel: UILabel!
        @IBOutlet weak var _eventNameLabel: UILabel!
        @IBOutlet weak var _priceLabel: UILabel!
        @IBOutlet weak var _eventType: UILabel!
        
    }

class DaaruItems{
    
    var daaruName:String
    var daaruImage:String
    
    init(givedaaruname:String,giveDaaruUrl:String){
     daaruName=givedaaruname
        daaruImage=giveDaaruUrl
        
    }
}


    extension UIViewController {
        
        func showToast(message : String) {
            
            let toastLabel = UILabel(frame: CGRect(x: 50, y: self.view.frame.size.height-150, width:self.view.frame.size.width-100 , height: 60))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1.0)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
            toastLabel.text = message
            toastLabel.alpha = 1.0
            toastLabel.numberOfLines=2
            toastLabel.layer.cornerRadius = 10.0;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.08, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
        func snakbarcitydikhao(){
            let message = MDCSnackbarMessage()
            let time = TimeInterval(exactly: 2.0)
            message.duration = time!
            message.text = "We Are Currently Operating Only In Delhi. Follow Us On Social Media For Future Updates"
            MDCSnackbarManager.show(message)
        }
        func snakbarcustom(string:String){
            let message = MDCSnackbarMessage()
            let time = TimeInterval(exactly: 2.0)
            message.duration = time!
            message.text = string
            MDCSnackbarManager.show(message)
        }
        
    }

