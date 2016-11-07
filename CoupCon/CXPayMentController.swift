//
//  CXPayMentController.swift
//  Coupocon
//
//  Created by apple on 07/11/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class CXPayMentController: UIViewController {
    
    var paymentUrl : String! = nil
    var webRequestArry: NSMutableArray = NSMutableArray()
    @IBOutlet weak var payMentWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingView.show("Processing...", animated: true)
      //self.webRequestArry = NSMutableArray()
        let url = NSURL (string: paymentUrl)
        let requestObj = NSURLRequest(URL: url!)
        self.payMentWebView.loadRequest(requestObj)
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
        
        self.webRequestArry.addObject(String(request.URL))
        
        print(request)
        return true
    }
    func webViewDidStartLoad(webView: UIWebView){
        LoadingView.show("Processing...", animated: true)
    }
    func webViewDidFinishLoad(webView: UIWebView){
        print(self.webRequestArry.lastObject)
        let lastRequest : String = (self.webRequestArry.lastObject as? String)!
        if (lastRequest.rangeOfString("paymentOrderDetailsResponse") != nil)  {
            CXDataService.sharedInstance.synchDataToServerAndServerToMoblile(lastRequest, completion: { (responseDict) in
                print(responseDict)
                LoadingView.hide()
            })
        }
    }
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?){
        
    }
}