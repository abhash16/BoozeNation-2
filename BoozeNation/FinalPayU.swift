//
//  ViewController.swift
//  temp
//
//  Created by Ashish Kumar2 on 8/30/16.
//  Copyright © 2016 Ashish Kumar. All rights reserved.
//

import UIKit

class FinalPayU: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(FinalPayU.responseReceived(notification:)), name: NSNotification.Name(rawValue: kPUUINotiPaymentResponse), object: nil)
    }
    
    
    func responseReceived(notification: Notification) {
        
        print("Pay Response  \(notification.description)");
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func payNowBtn(_ sender: AnyObject) {
        
        
        
        let paymentParam:PayUModelPaymentParams = PayUModelPaymentParams();
        paymentParam.key = "gtKFFx";
        paymentParam.amount = "2.0";
        paymentParam.productInfo = "iPhone";
        paymentParam.firstName = "someName";
        paymentParam.email = "test@gmail.com";
        paymentParam.userCredentials = "gtKFFx:test@gmail.com";
        paymentParam.phoneNumber = "9876543210";
        paymentParam.surl = "https:www.someSuccessUrl.com";
        paymentParam.surl = "https:www.someFailureUrl.com";
        paymentParam.surl = "http://abc.com";
        paymentParam.furl = "http://abc.com"
        paymentParam.udf1 = "u1";
        paymentParam.udf2 = "u2";
        paymentParam.udf3 = "u3";
        paymentParam.udf4 = "u4";
        paymentParam.udf5 = "u5";
        //paymentParam.transactionID = "986123785";
        let randomID  = arc4random() % 90 + 200;
        
        paymentParam.transactionID = "87878787080069"; //String(format: "%ld", randomID)
        paymentParam.environment = ENVIRONMENT_TEST
        
        
        //paymentParam.hashes.paymentRelatedDetailsHash="885d90fbc64f86ec9ade3abab27c6a5fe259a9cd57f62a558f9001d5c81e64d06a113d6459c8e2cecbf1c4776b1fc5b5ee1bf9884eee4383ef1a3740ba09f4d3"
        
        
        
        
        let obj:PayUDontUseThisClass = PayUDontUseThisClass()
        obj.getPayUHashes(withPaymentParam: paymentParam, merchantSalt: "eCwWELxi", withCompletionBlock:{( allHashes,hashString,errorMessage)in
            
            if (errorMessage == nil) {
                
                
                
                
                //                paymentOptionVC!.paymentParam = paymentParam;
                //                paymentOptionVC!.paymentRelatedDetail = paymentRelatedDetails;
                //                //
                //                self.navigationController?.pushViewController(paymentOptionVC!, animated: true);
                paymentParam.hashes = allHashes
                
            }
            else{
                // error occurred while creating the request
            }
        });
        //        [obj getPayUHashesWithPaymentParam:paymentParam
        //        merchantSalt:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"salt"]
        //        withCompletionBlock:^(PayUModelHashes *allHashes, PayUModelHashes *hashString, NSString *errorMessage) {
        //
        //        dispatch_async(dispatch_get_main_queue(), ^{
        //        [self callSDKWithHashes:allHashes withError:errorMessage];
        //        });
        //        }];
        //obj.getPayUHashesWithPaymentParam
        
        
        let webServiceResponse:PayUWebServiceResponse = PayUWebServiceResponse();
        webServiceResponse.getPayUPaymentRelatedDetail(forMobileSDK: paymentParam, withCompletionBlock: {(paymentRelatedDetails,errorMessage,extraParam)in
            
            if (errorMessage == nil) {
                
                let stryBrd = UIStoryboard(name: "PUUIMainStoryBoard", bundle: nil) //if bundle is nil the main bundle will be used
                let paymentOptionVC = stryBrd.instantiateViewController(withIdentifier: VC_IDENTIFIER_PAYMENT_OPTION) as? PUUIPaymentOptionVC;
                
                
                paymentOptionVC!.paymentParam = paymentParam;
                paymentOptionVC!.paymentRelatedDetail = paymentRelatedDetails;
                //
                self.navigationController?.pushViewController(paymentOptionVC!, animated: true);
                
            }
            else{
                // error occurred while creating the request
            }
        });
        
    }
    
    
    
    
}


