//
//  DemoPopupViewController2.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit

class DemoPopupViewController2: UIViewController, PopupContentViewController, UITextFieldDelegate{
    var closeHandler: (() -> Void)?
    var redeemJsonArr:NSArray! = nil
    
    var termsArray:NSMutableArray!
    var i = 0
    var str: String = ""
    var timer = NSTimer()
    
    @IBOutlet weak var termsConditionTxtView: UITextView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productDesLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DemoPopupViewController2.methodOfReceivedNotification(_:)), name:"PopUpData", object: nil)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 4
    }
    
    /*let screenSize: CGRect = UIScreen.mainScreen().bounds
     then you can access the width and height like this:
     
     let screenWidth = screenSize.width
     let screenHeight = screenSize.height
     if you want 75% of your screen's width you can go:
     
     let screenWidth = screenSize.width * 0.75*/
    
    func testFunc() {
        str += "- \(termsArray[i])\n"
        termsConditionTxtView.text = str
        if i == termsArray.count - 1 {
            timer.invalidate()
        }
        i += 1
    }
    
    func methodOfReceivedNotification(notification:NSNotification)  {
        
        var popUpDic = notification.object as! [String:AnyObject]
        let imageUrlStr = popUpDic["popUpLogo"] as! String
        let lblDesc = popUpDic["popUpName"] as! String
        let terms = popUpDic["terms"]
        print(terms)
        
        if terms == nil{
            //termsArray.addObject("No Terms and Conditions to Show")
            
        }else{
            
            termsArray = terms as! NSMutableArray
            
        }
        
        productImageView.sd_setImageWithURL(NSURL(string:imageUrlStr))
        productDesLbl.text = lblDesc
        
        if (termsArray != nil) {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: #selector(DemoPopupViewController2.testFunc), userInfo: nil, repeats: true)
        } else {
            termsConditionTxtView.text = "- Terms and Conditions Not Available"
        }
    }
    
    
    
    class func instance() -> DemoPopupViewController2 {
        let storyboard = UIStoryboard(name: "DemoPopupViewController2", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DemoPopupViewController2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSizeMake(280, 350)
    }
    @IBAction func okButtonAction(sender: AnyObject) {
        closeHandler?()
    }
    
    @IBAction func redeemBtnAction(sender: AnyObject) {
        redeemCall()
        closeHandler?()
    }
    
    func redeemCall(){
        //http://storeongo.com:8081/Services/getMasters? type=macidinfo&mallId=20217&jobId=196278
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"macidinfo","mallId":CXAppConfig.sharedInstance.getAppMallID(),"jobId":CXAppConfig.sharedInstance.getMacJobID()]) { (responseDict) in
            self.redeemJsonArr = ((responseDict.valueForKey("jobs") as? NSArray)!)
            let dict = self.redeemJsonArr.firstObject as! NSDictionary
            let currentJobStatus = dict.valueForKey("userStatus") as! String
            LoadingView.hide()
            if currentJobStatus == "active" || currentJobStatus == ""{
                let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let redeemView = storyBoard.instantiateViewControllerWithIdentifier("REDEEM_HISTORY") as! ReedemViewController
                redeemView.showBackBtn = true
                self.navigationController?.pushViewController(redeemView, animated: true)
                
            }else{
            
                let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let profileView = storyBoard.instantiateViewControllerWithIdentifier("PROFILE_MEMBERSHIP") as! ProfileMembershipViewController
                self.navigationController?.pushViewController(profileView, animated: true)
                
            }

            
        }
    }
    
    


}


