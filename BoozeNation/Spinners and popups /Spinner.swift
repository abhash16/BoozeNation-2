

import UIKit
import MaterialComponents.MDCActivityIndicator
var isLoaderActive = false ; var spinnerXFactorFixed = false
class SpinnerView: NSObject {
    let aView = Bundle.main.loadNibNamed("Spinner", owner: self, options: nil)?.first as! Spinner
    let activityindicator = MDCActivityIndicator()
    func showSpinner(ttitle:String,text:String){
        if let window = UIApplication.shared.keyWindow{
            
            aView.backgroundColor = UIColor(white: 0.2, alpha: 0.4)
            aView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.height)
            if !spinnerXFactorFixed{
                activityindicator.frame.size.width = 80;activityindicator.frame.size.height = 80
                activityindicator.center = CGPoint(x: aView._loadingView.center.x-38, y: 55)
                spinnerXFactorFixed = true}
            aView._loadingView.backgroundColor = UIColor.white
            activityindicator.radius = 35.0
            activityindicator.strokeWidth = 4
            activityindicator.cycleColors = [UIColor.orange]
            aView._loadingView.layer.cornerRadius = 10.0
            activityindicator.startAnimating()
            aView._loadingView.addSubview(activityindicator)
            window.addSubview(aView)
            aView._bigLabel.text = ttitle
            aView._smallLabel.text = text
            activityindicator.startAnimating()
        }}
    
    func removeSelf(completition:(()->())){
        activityindicator.removeFromSuperview()
        aView.removeFromSuperview()
        completition()
    }

}

class Spinner: UIView {
    @IBOutlet weak var _loadingView: UIView!
    @IBOutlet weak var _bigLabel: UILabel!
    @IBOutlet weak var _smallLabel: UILabel!
}






