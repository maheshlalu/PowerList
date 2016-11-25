//
//  CXPayMentController.swift
//  Coupocon
//
//  Created by apple on 07/11/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class CXPayMentController: UIViewController {
    typealias CompletionBlock = (responceDic:NSDictionary) -> Void

    var paymentUrl : NSURL! = nil
    var webRequestArry: NSMutableArray = NSMutableArray()
    @IBOutlet weak var payMentWebView: UIWebView!
      var activity: UIActivityIndicatorView = UIActivityIndicatorView()
    var completion: CompletionBlock = { reason in print(reason) }

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingView.show("Processing...", animated: true)
      //self.webRequestArry = NSMutableArray()
        //let url =  NSURL(string: paymentUrl)
        let requestObj = NSURLRequest(URL: paymentUrl)
        self.payMentWebView.loadRequest(requestObj)
        //self.navigationItem.setHidesBackButton(true, animated:true);
        self.title = "payment Gateway "
        self.activity = UIActivityIndicatorView()
        self.activity.tintColor = CXAppConfig.sharedInstance.getAppTheamColor()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CXPayMentController : UIWebViewDelegate {
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        self.webRequestArry.addObject(String(request.URL!))
        print(request)
        return true
    }
    func webViewDidStartLoad(webView: UIWebView){
        LoadingView.show("Processing...", animated: true)
        activity.hidden = false
        activity.startAnimating()
    }
    func webViewDidFinishLoad(webView: UIWebView){
        //print(self.webRequestArry.lastObject)
        LoadingView.hide()
        let lastRequest : String = String(self.webRequestArry.lastObject!)
        print(lastRequest)
        if ((lastRequest.rangeOfString("paymentorderresponse")) != nil)  {
            LoadingView.show("Processing...", animated: true)
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(lastRequest, completion: { (responseDict) in
               // print(responseDict)
                let status : String = (responseDict.valueForKey("status") as? String)!
                if status == "Completed" {
                    //self.changeTheUserActiveStaus()
                    self.completion(responceDic: responseDict)
                }else{
                    
                }
                LoadingView.hide()
            })
        }
        activity.hidden = true
        activity.stopAnimating()
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        activity.hidden = true
        activity.stopAnimating()
    }
    
    
    func changeTheUserActiveStaus(){
        
        CX_SocialIntegration.sharedInstance.updateTheSaveConsumerProperty(["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":CXAppConfig.sharedInstance.getEmail(),"propName":"userStatus","propValue":"active"]) { (resPonce) in
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            

        }
        /*
         
         http://storeongo.com:8081/MobileAPIs/updateMultipleProperties/jobId=200400&jsonString={"PaymentType":"249","ValidTill":"11-11-2017","userStatus":"active"}&ownerId=20217
         
         
         */

        //storeongo.com:8081/MobileAPIs/userActivation?ownerId=530&consumerEmail=cxsample@gmail.com&userStatus=active
//        let userProfileData:UserProfile = CXAppConfig.sharedInstance.getTheUserDetails()
//        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile("storeongo.com:8081/MobileAPIs/userActivation?", parameters: ["ownerId":CXAppConfig.sharedInstance.getAppMallID(),"consumerEmail":userProfileData.emailId!,"userStatus":"active"]) { (responseDict) in
//        }
        
//        let userProfileData:UserProfile = CXAppConfig.sharedInstance.getTheUserDetails()
//
//        CXDataService.sharedInstance.synchDataToServerAndServerToMoblile("http://storeongo.com:8081/MobileAPIs/changeJobStatus?", parameters: ["providerEmail":"","mallId":"","jobId":"","jobStatusId":""]) { (responseDict) in
//            
//        }
        //http://storeongo.com:8081/MobileAPIs/changeJobStatus?providerEmail=balabca.chandra72@gmail.com&mallId=20217&jobId=197201&jobStatusId=167594
        
    }
}

/*
 
 {
 "allow_repeated_payments" = 0;
 amount = "99.00";
 "buyer_name" = Yernagulamahesh;
 "created_at" = "2016-11-08T11:12:38.654666Z";
 email = "yernagulamahesh@gmail.com";
 id = 0b9632ed01cd4252a9e9d01836018481;
 longurl = "https://test.instamojo.com/@ongocoupocon/0b9632ed01cd4252a9e9d01836018481";
 "mark_fulfilled" = 1;
 "modified_at" = "2016-11-08T11:14:01.503206Z";
 partner = "https://test.instamojo.com/v2/users/99003f8510dd48079341db08eacc739b/";
 "partner_fee" = "10.00";
 "partner_fee_type" = percent;
 payments =     (
 "https://test.instamojo.com/v2/payments/MOJO6b08005J79407729/"
 );
 phone = "+918096380038";
 purpose = "Coupocon Payment";
 "redirect_url" = "http://54.179.48.83:9000/CoupoconPG/paymentOrderResponse?mallId=20217&macId=3673a3bd-4461-47fa-9a9e-3781e7147d21&";
 "resource_uri" = "https://test.instamojo.com/v2/payment_requests/0b9632ed01cd4252a9e9d01836018481/";
 "send_email" = 0;
 "send_sms" = 0;
 status = Completed;
 user = "https://test.instamojo.com/v2/users/11d49dde61bb46509a383d7505ba1d87/";
 }
 */
