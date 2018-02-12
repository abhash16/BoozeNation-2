//
//  AboutUsViewController.swift
//  BoozeNation
//
//  Created by Bimlesh Singh on 02/10/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
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
