//
//  MenuSlider.swift
//  BoozeNation
//
//  Created by Abhishek Chaudhary on 11/10/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit
import DropDown
import Firebase
import MaterialComponents.MaterialFeatureHighlight
var menuFlag=0

private let spinner = SpinnerView()

class MenuSlider:UIViewController,UITextFieldDelegate{
    
    var selectedMenuDetailsDictionary=[String:Any]()
   
    var quantityPrices=[String:Any]()
    var numberofDaaru=1
    var totalCartprice=0
    var unitDaaruPrice=0
    var trick=1
    
    //let _blackBGView = UIView()
    
    let addCartdownView = Bundle.main.loadNibNamed("addToCart", owner: self, options: nil)?.first as! AddToCart
    let dropDownView = DropDown()
    func offerChecker(){
      let offer = Int("\(selectedMenuDetailsDictionary["drinkOffer"]!)")!
        if offer==0{
        self.addCartdownView._hotDealImage.isHidden=true
        self.addCartdownView._hotDealLabel1.isHidden=true
        self.addCartdownView._hotDealLabel2.isHidden=true

        }
        else{
    self.addCartdownView._hotDealImage.isHidden=false
    self.addCartdownView._hotDealLabel1.isHidden=false
    self.addCartdownView._hotDealLabel2.isHidden=false

       self.addCartdownView._hotDealLabel1.text="\(self.selectedMenuDetailsDictionary["offerDetails"]!)"
        
            if let a = self.selectedMenuDetailsDictionary["drinkDescription"]{
            
            self.addCartdownView._hotDealLabel2.text = "\(self.selectedMenuDetailsDictionary["drinkDescription"]!)"
          
            }
            
            else{
                self.addCartdownView._hotDealLabel2.text = " "

            }
                
                
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        offerChecker()
      
        self.view.backgroundColor = UIColor(white: 0.1, alpha: 0.8)
        addSlider()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.dismiss(animated: false, completion: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        let userdefault = UserDefaults.standard
        let featureHighlighted = userdefault.bool(forKey: "featureHighlight")
        if !featureHighlighted {
        featureHighlights()
        }
    }
        override func viewDidLoad() {
        
        
    }
    //fuction called everytime the user hits any cell in the menu bar:::::::::::::::::::::::::::::::::::::::::::::::::::::
func addSlider(){
        
        if let window = UIApplication.shared.keyWindow{
                
                //calling the fuction to load data from the database::::::::::::::::::::::::::::::::::::
                loadCartMenuDetails()
            

            //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
                let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(remove2))
                downSwipe.direction = .down
               self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(remove2)))
            addCartdownView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dd)))
            addCartdownView.addGestureRecognizer(downSwipe)
            self.view.addGestureRecognizer(downSwipe)
                //framing and adding of cart for menu
                
                addCartdownView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height)
                addCartdownView.addGestureRecognizer(downSwipe)
           addCartdownView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dd)))
                view.addSubview(addCartdownView)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    
                    self.addCartdownView.frame = CGRect(x: 0, y: window.frame.size.height/4.0, width: window.frame.size.width, height: window.frame.size.height)
                    
                }, completion: {finish in
                    self.tabBarController?.tabBar.isUserInteractionEnabled = false
                }
            )
                
     
            // Drop Down and controll for cart for menu::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
            
            dropDownView.anchorView = addCartdownView._measureTextField
            dropDownView.dataSource = drinksMeasuresValues
            addCartdownView._measureTextField.addTarget(self, action: #selector(showDropDown), for: .touchDown)
            addCartdownView._measureTextField.delegate = self
            let dropImage = #imageLiteral(resourceName: "dropdown (1)");let dropArrow = UIImageView.init(image: dropImage.withRenderingMode(.alwaysTemplate))
            dropArrow.tintColor = UIColor(red: 254/255, green: 99/255, blue: 0/255, alpha: 1.0)
            addCartdownView._measureTextField.rightViewMode = UITextFieldViewMode.unlessEditing
            addCartdownView._measureTextField.rightView     = dropArrow
            dropDownView.selectionAction = { [unowned self] (index, item) in
                
                
                self.addCartdownView._measureTextField.text = item
                self.unitDaaruPrice=Int("\(self.drinkPriceValues[index])")!
                self.addCartdownView.daaruPrice.text="\(self.unitDaaruPrice)"
                self.totalCartprice = self.numberofDaaru * self.unitDaaruPrice
                self.addCartdownView._totolLabel.text = "\(self.totalCartprice)"
                
                
            }
            
            addCartdownView._plusButton.addTarget(self, action: #selector(addQuantity), for: .touchDown)
            addCartdownView._minusButton.addTarget(self, action: #selector(subtractQuantity), for: .touchDown)
            addCartdownView._addtoCartButton.addTarget(self, action: #selector(addingItemsToCart), for: .touchDown)
            
        }
    }
    
    func dd(){
        
        //dont fucking delete it
    }
    
    func addingItemsToCart(){
        
        
         Database.database().reference().child("usertransaction_status").child(UID).child("addToCart").removeValue()
        
        
        addCartdownView._addtoCartButton.isUserInteractionEnabled = false
        
        trick=0
        
        spinnerView.showSpinner(ttitle: "Adding Drink To Cart ..", text: "Please Be Patient ..")
        
      print("\n\n\nfsd\n")
        
        Database.database().reference().child("temp_addtouserrcart").child(UID).child(("\(CurrentCityLocation.lowercased())\(self.selectedMenuDetailsDictionary["drinkCategory"]! as! String)\(self.selectedMenuDetailsDictionary["drinkName"]! as! String)\(addCartdownView._measureTextField.text!.lowercased())").lowercased()).setValue(["cartTotalPrice":Int("\(addCartdownView._totolLabel.text!)") ,"drinkCategory":"\(self.selectedMenuDetailsDictionary["drinkCategory"]! as! String)","drinkCity":"\(CurrentCityLocation)","drinkMeasure":"\(addCartdownView._measureTextField.text!.lowercased())","drinkName":"\(self.selectedMenuDetailsDictionary["drinkName"]! as! String)","drinkPrice":Int("\(addCartdownView.daaruPrice.text!)"),"drinkQuantity":Int("\(addCartdownView._quantityLabel.text!)"),"drinkThumbnail":self.selectedMenuDetailsDictionary["thumbnail"]! as! String])
    Database.database().reference().child("usertransaction_status").child(UID).child("addToCart").observe(.value, with:{ snapshot in

            var dict = snapshot.value as? [String:Any]

            if snapshot.exists() && self.trick==0 && "\(dict!["status"]!)" == "success" {
                
                self.trick=1
                spinnerView.removeSelf(completition: {
                    self.remove2()
                    self.presentingViewController?.showToast(message: "Drink Added To Cart")
                   // _ = SweetAlert().showAlert("Done", subTitle: "Drinks Added To Cart", style: AlertStyle.success)
                    
                    
                })
          
                Database.database().reference().child("usertransaction_status").child(UID).child("addToCart").removeValue()
                

        }   else if snapshot.exists() && "\(dict!["status"]!)" == "failed" {
            
            spinnerView.removeSelf(completition: {})
                self.remove2()

            //         _ = SweetAlert().showAlert("Uh-Oh", subTitle: "Booze Added To Order", style: AlertStyle.success)
            self.presentingViewController?.showToast(message: "\(dict!["reason"]!)")
            
        }

        })
  
        
        
       
        
        
        isCartEmpty=false
        
        addCartdownView._addtoCartButton.isUserInteractionEnabled = true
    }
 
    
func featureHighlights(){
        
        menuFlag=1
      let highlightController = MDCFeatureHighlightViewController(highlightedView: self.addCartdownView._addtoCartButton, completion: nil)
        highlightController.titleText = "Measure Selector"
        highlightController.bodyText = "Tap to Choose from Pint, Bottle or Pitcher for Beer's, Large or Small from Whisky's, you catch the drift"
         highlightController.outerHighlightColor =
        UIColor.orange.withAlphaComponent(kMDCFeatureHighlightOuterHighlightAlpha)
    self.present(highlightController, animated: true, completion:{    let userdefault = UserDefaults.standard
        userdefault.set(true, forKey: "featureHighlight")}
    )
}
    
    
    //loading data from the database.:::::::::::::::::::::::::::::::::::::::::::::::::

    //getting all the data for the selected drink to show in the slide up::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    
    func loadCartMenuDetails(){
        
        
        self.addCartdownView._brandName.sd_setImage(with: URL(string: self.selectedMenuDetailsDictionary["thumbnail"]! as! String))
        self.addCartdownView._brandName.layer.cornerRadius = 15.0
        self.addCartdownView._brandName.layer.masksToBounds = true
        
    
        self.addCartdownView._aboutBrand.text=self.selectedMenuDetailsDictionary["drinkName"]! as! String
        self.addCartdownView.selectedDaaruType.text=self.selectedMenuDetailsDictionary["drinkCategory"]! as! String
        
        
        
        
        numberofDaaru=1
        totalCartprice=0
        
        self.drinkPriceValues.removeAll()
        self.drinksMeasuresValues.removeAll()
        
        Database.database().reference().child("drink_price").child("\(selectedMenuDetailsDictionary["drinkCity"]!)".lowercased()).child("\(selectedMenuDetailsDictionary["drinkCategory"]!)".lowercased()).child("\(selectedMenuDetailsDictionary["drinkName"]!)".lowercased()).observe(.childAdded){(snapshot:DataSnapshot) in
            
            
            if (snapshot.key != "tax"){
                
                self.drinksMeasuresValues.append(snapshot.key)
                self.drinkPriceValues.append(snapshot.value!)
                
                
            }
            
            self.addCartdownView._measureTextField.text = self.drinksMeasuresValues[0]
            self.unitDaaruPrice=Int("\(self.drinkPriceValues[0])")!
            self.dropDownView.dataSource=self.drinksMeasuresValues
            self.addCartdownView.daaruPrice.text="\(self.drinkPriceValues[0])"
            self.addCartdownView._totolLabel.text = "\(self.drinkPriceValues[0])"
            
            self.addCartdownView._quantityLabel.text = "\(self.numberofDaaru)"
            
        }
        
        
        
    }
    
    
    
    
    
    
    var drinksMeasuresValues=[String]()
    var drinkPriceValues=[Any]()
    
    
    
   
    func showDropDown(){
        dropDownView.show()
   
    }
    
    func addQuantity(){
        addCartdownView._plusButton.isUserInteractionEnabled = false
        let newFrame = self.addCartdownView._quantityLabel.frame
        UIView.animate(withDuration: 0.1, animations: {
            self.addCartdownView._quantityLabel.frame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y, width: newFrame.width, height: 0)
            self.addCartdownView._quantityLabel.frame.origin.y = newFrame.origin.y - 9
        }) { (Bool) in
            self.changeTotalLabel()
            UIView.animate(withDuration: 0.1, animations: {
                self.addCartdownView._quantityLabel.frame.origin.y = newFrame.origin.y + 35
                /* change label text here*/
                
                self.numberofDaaru += 1

                
                
                self.addCartdownView._quantityLabel.text = "\(self.numberofDaaru)"
            }, completion: { (Bool) in
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.addCartdownView._quantityLabel.frame = newFrame
                    self.addCartdownView._plusButton.isUserInteractionEnabled = true})})
        }
        
    }
    func subtractQuantity(){
        addCartdownView._minusButton.isUserInteractionEnabled = false
        
        let newFrame = self.addCartdownView._quantityLabel.frame
        UIView.animate(withDuration: 0.1, animations: {
            self.addCartdownView._quantityLabel.frame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y, width: newFrame.width, height: 0)
            self.addCartdownView._quantityLabel.frame.origin.y = newFrame.origin.y + 9
        }) { (Bool) in
            self.changeTotalLabel()
            UIView.animate(withDuration: 0.1, animations: {
                self.addCartdownView._quantityLabel.frame.origin.y = newFrame.origin.y - 35
                /* change label text here*/
                if self.numberofDaaru != 1 {
                    self.numberofDaaru -= 1
                }
                
                self.addCartdownView._quantityLabel.text = "\(self.numberofDaaru)"

            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.addCartdownView._quantityLabel.frame = newFrame
                    self.addCartdownView._minusButton.isUserInteractionEnabled = true})})
        }
        
    }
    
    func changeTotalLabel(){
        let newFrame = self.addCartdownView._totolLabel.frame
        UIView.animate(withDuration: 0.1, animations: {
            self.addCartdownView._totolLabel.frame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y, width: newFrame.width, height: 0)
            self.addCartdownView._totolLabel.frame.origin.y = newFrame.origin.y - 9
        }) { (Bool) in
            UIView.animate(withDuration: 0.1, animations: {
                self.addCartdownView._totolLabel.frame.origin.y = newFrame.origin.y + 35
                /* change label text here*/
                
                self.totalCartprice = self.numberofDaaru * self.unitDaaruPrice
                print(self.totalCartprice)
                print(self.unitDaaruPrice)
                self.addCartdownView._totolLabel.text = "\(self.totalCartprice)"
                
            }, completion: { (Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.addCartdownView._totolLabel.frame = newFrame })})
        }
        
        
    }
    
func remove2(){
        
    UIView.animate(withDuration: 5.0, animations: {
        self.addCartdownView.frame.origin.x = 0
    }) { bool in
        self.view.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: {
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
        }
        )
        self.addCartdownView.removeFromSuperview()
    }
    }
    
func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

/// next classs:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
class AddToCart:UIView{
    

    
    @IBOutlet weak var _plusButton: UIButton!
    @IBOutlet weak var _minusButton: UIButton!
    @IBOutlet weak var _addtoCartButton: UIButton!
    @IBOutlet weak var _quantityLabel: UILabel!
    @IBOutlet weak var _measureTextField: UITextField!
    @IBOutlet weak var _totolLabel: UILabel!
    @IBOutlet weak var _brandName: UIImageView!
    @IBOutlet weak var _aboutBrand: UILabel!
    
    @IBOutlet weak var selectedDaaruType: UILabel!
    
    @IBOutlet weak var daaruPrice: UILabel!
    @IBOutlet weak var _hotDealImage: UIImageView!
    @IBOutlet weak var _hotDealLabel1: UILabel!
    @IBOutlet weak var _hotDealLabel2: UILabel!
}


