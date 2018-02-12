//
//  InternetReachability.swift
//  BoozeNation
//
//  Created by Abhishek on 11/11/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit
import MaterialComponents.MDCActivityIndicator
var isInternetConnected = false ; var isReachabilityIndicatorActive = false
class InternetReachability:NSObject{
    let aView = Bundle.main.loadNibNamed("InternetReachability", owner: self, options: nil)?.first as! IRView
    func showIR(){
        if let window = UIApplication.shared.keyWindow{
            aView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            aView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            let activityindicator = MDCActivityIndicator()
            activityindicator.radius = 6;            activityindicator.strokeWidth = 1
            aView._golgolView.addSubview(activityindicator)
            activityindicator.frame = CGRect(x: 0, y: 0, width: aView._golgolView.frame.width, height: aView._golgolView.frame.height)
            aView._connectionView.layer.cornerRadius = 10
            aView._connectionView.layer.borderWidth = 0.2
            aView._connectionView.layer.borderColor = UIColor.orange.cgColor
            activityindicator.cycleColors = [UIColor.orange]
            activityindicator.startAnimating()
            window.addSubview(aView)
        }
    }
    func removeIR(){
        aView.removeFromSuperview()
    }
    
    func showremoveReachabilityIndicator(){
        if isInternetConnected == false {
            if isReachabilityIndicatorActive == false {
                showIR()
                isReachabilityIndicatorActive = true
            }
        } else {
            if isReachabilityIndicatorActive == true{
                removeIR()
                isReachabilityIndicatorActive = false
            }
        }
    }
    
}




class IRView: UIView {
    
    @IBOutlet weak var _golgolView: UIView!
    @IBOutlet weak var _connectionView: UIView!
}

