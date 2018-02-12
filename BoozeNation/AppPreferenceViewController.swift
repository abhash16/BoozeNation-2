//
//  AppPreferenceViewController.swift
//  BoozeNation
//
//  Created by Bimlesh Singh on 04/10/17.
//  Copyright © 2017 Abhishek Chaudhary. All rights reserved.
//

import UIKit

class AppPreferenceViewController: UIViewController {

    @IBOutlet weak var chekbButtn1: UIButton!
    @IBOutlet weak var checkButtn2: UIButton!
    @IBOutlet weak var checkbuttn3: UIButton!
    @IBOutlet weak var saveButtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
self.saveButtn.layer.cornerRadius = 15
        self.saveButtn.layer.masksToBounds = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
     var isChecked:Bool = false
    @IBAction func checkButtn1Action(_ sender: Any) {
        if isChecked == false{
            let checkedimage = UIImage(named: "checked.png")
            chekbButtn1.setImage(checkedimage, for: .normal)
            isChecked = true
        }
        else{
            let uncheckedImage = UIImage(named: "unchecked.png")
            chekbButtn1.setImage(uncheckedImage, for: .normal)
            isChecked = false
        }
    }
    
    @IBAction func checkButtn2Action(_ sender: Any) {
        if isChecked == false{
            let checkedimage = UIImage(named: "checked.png")
            checkButtn2.setImage(checkedimage, for: .normal)
            isChecked = true
        }
        else{
            let uncheckedImage = UIImage(named: "unchecked.png")
            checkButtn2.setImage(uncheckedImage, for: .normal)
            isChecked = false
        }
    }
    
    @IBAction func checkButtn3Action(_ sender: Any) {
        if isChecked == false{
            let checkedimage = UIImage(named: "checked.png")
            checkbuttn3.setImage(checkedimage, for: .normal)
            isChecked = true
        }
        else{
            let uncheckedImage = UIImage(named: "unchecked.png")
            checkbuttn3.setImage(uncheckedImage, for: .normal)
            isChecked = false
        }
    }
    
}
