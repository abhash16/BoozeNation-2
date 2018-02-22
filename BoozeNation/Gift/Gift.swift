//
//  Gift.swift
//  BoozeNation
//
//  Created by Abhishek on 15/11/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit

class Gift: UIViewController {

    @IBAction func _cheersBtn(_ sender: Any) {
        let notificationNme = NSNotification.Name("Notification_GiftClose")
        NotificationCenter.default.post(name: notificationNme, object: nil)
    }
    @IBOutlet var _friendName: UILabel!
    @IBOutlet var _daaruname: UILabel!
    @IBOutlet var _daaruQuantity: UILabel!
    @IBOutlet var _totalGiftValue: UILabel!
    @IBOutlet var _reedemableCity: UILabel!
    var friendName = "nil"; var daaruname = "nil"; var daaruQuantity = "nil";var totalGiftValue = "nil";var redeemableCity = "nil"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationNme = NSNotification.Name("Notification_GiftClose")
        NotificationCenter.default.addObserver(self, selector: #selector(removeSelf), name: notificationNme, object: nil)
        _friendName.text = friendName
        _daaruname.text = daaruname
        _daaruQuantity.text = daaruQuantity
        _totalGiftValue.text = totalGiftValue
        _reedemableCity.text = redeemableCity
    }
func showGiftCard(friendName:String,daaruname:String,daaruQuantity:String,totalGiftValue:String,redeemableCity:String){
        if let window = UIApplication.shared.keyWindow{
            self.friendName =  friendName
            self.daaruname = daaruname
            print(daaruname)
            self.daaruQuantity = daaruQuantity
            self.totalGiftValue = "Total Gift Value : Rs \(totalGiftValue)"
            self.redeemableCity = "Only Redeemable in  \(redeemableCity)"
            self.view.backgroundColor = UIColor(white: 0.2, alpha: 0.4)
            self.view.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            window.addSubview(self.view)
        }
    }
    
    
    func removeSelf(){
        self.view.removeFromSuperview()
    }

}
