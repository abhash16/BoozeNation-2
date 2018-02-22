//
//  AboutUsViewController.swift
//  BoozeNation
//
//  Created by Bimlesh Singh on 02/10/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    @IBAction func privacyPolicyBtn(_ sender: Any) {
        openLink(urlString:"http://boozenation.in/app/privacy_policy.htm")
    }

    @IBAction func termsOfServiceBtn(_ sender: Any) {
      openLink(urlString: "http://boozenation.in/app/tos.html")
        }
    

    @IBAction func faceBookAction(_ sender: Any) {
        facebookURL()
    }
    @IBAction func twitterAction(_ sender: Any) {
        twitterURL()
    }
    @IBAction func instagramAction(_ sender: Any) {
        instagramURL()
    }
    @IBAction func googleAction(_ sender: Any) {
        googleURL()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIViewController{
    
    func openLink(urlString: String){
        let showViewController = UIViewController()
        self.navigationController?.pushViewController(showViewController, animated: true)
    
        let webView = UIWebView()
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        showViewController.view.addSubview(webView)
      webView.loadRequest(URLRequest(url: URL(string: urlString)!))
        
    }
    
    
    
}
