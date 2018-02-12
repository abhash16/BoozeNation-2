//
//  File.swift
//  BoozeNation
//
//  Created by Abhishek on 12/11/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import Foundation

extension UIViewController{
    
    func sucessAlert(Title:String,Subtitle:String){
        _ = SweetAlert().showAlert("\(Title)", subTitle: "\(Subtitle)", style: AlertStyle.success)
    }
    
}

//@IBAction func aBasicMessageAlert(_ sender: AnyObject) {
//    _ = SweetAlert().showAlert("Here's a message!")
//}
//
//
//@IBAction func subtitleAlert(_ sender: AnyObject) {
//
//    _ = SweetAlert().showAlert("Here's a message!", subTitle: "It's pretty, isn't it?", style: AlertStyle.none)
//}
//
//@IBAction func sucessAlert(_ sender: AnyObject) {
//    _ = SweetAlert().showAlert("Good job!", subTitle: "You clicked the button!", style: AlertStyle.success)
//}
//
//@IBAction func warningAlert(_ sender: AnyObject) {
//    _ = SweetAlert().showAlert("Are you sure?", subTitle: "You file will permanently delete!", style: AlertStyle.warning, buttonTitle:"Cancel", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
//        if isOtherButton == true {
//
//            print("Cancel Button  Pressed", terminator: "")
//        }
//        else {
//            _ = SweetAlert().showAlert("Deleted!", subTitle: "Your imaginary file has been deleted!", style: AlertStyle.success)
//        }
//    }
//}
//
//@IBAction func cancelAndConfirm(_ sender: AnyObject) {
//    _ = SweetAlert().showAlert("Are you sure?", subTitle: "You file will permanently delete!", style: AlertStyle.warning, buttonTitle:"No, cancel plx!", buttonColor:UIColor.colorFromRGB(0xD0D0D0) , otherButtonTitle:  "Yes, delete it!", otherButtonColor: UIColor.colorFromRGB(0xDD6B55)) { (isOtherButton) -> Void in
//        if isOtherButton == true {
//
//            _ = SweetAlert().showAlert("Cancelled!", subTitle: "Your imaginary file is safe", style: AlertStyle.error)
//        }
//        else {
//            _ = SweetAlert().showAlert("Deleted!", subTitle: "Your imaginary file has been deleted!", style: AlertStyle.success)
//        }
//    }
//
//}
//
//@IBAction func customIconAlert(_ sender: AnyObject) {
//    _ = SweetAlert().showAlert("Sweet!", subTitle: "Here's a custom image.", style: AlertStyle.customImag(imageFile: "thumb.jpg"))
//}

