//
//  HelpAndSupportViewController.swift
//  BoozeNation
//
//  Created by Bimlesh Singh on 02/10/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit

class HelpAndSupportViewController: UIViewController {

    @IBOutlet weak var helpandsupportwebview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = UIImageView.init(image: UIImage(named: "boozenation_logo.png"))
        self.navigationItem.titleView?.contentMode = .scaleAspectFit
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.gray.cgColor
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 5.0;
        self.navigationController?.navigationBar.layer.shadowOpacity = 1.0;
        self.navigationController?.navigationBar.layer.masksToBounds = false;
        self.navigationController?.navigationBar.layer.shadowPath = UIBezierPath(roundedRect:        (self.navigationController?.navigationBar.bounds)!, cornerRadius:        (self.navigationController?.navigationBar.layer.cornerRadius)!).cgPath;
        self.navigationController?.navigationBar.backgroundColor=UIColor.white
        
        helpandsupportwebview.loadRequest(URLRequest(url: NSURL(string: "http://boozenation.in/app/tos.html")! as URL))
        
        

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
