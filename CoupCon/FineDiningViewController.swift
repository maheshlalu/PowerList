//
//  FineDiningViewController.swift
//  CoupCon
//
//  Created by apple on 17/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class FineDiningViewController: UIViewController {
    var dealsDic: NSDictionary!
    
    @IBOutlet weak var dealBackgroundImg: UIImageView!
    @IBOutlet weak var dealLogoImg: UIImageView!
    @IBOutlet weak var dealNameLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
     weak var currentViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dealsDic)
        self.dealBackgroundImg.setImageWithURL(NSURL(string:(dealsDic.valueForKey("BackgroundImage_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
       // print(dealsDic.valueForKey("BackgroundImage_URL"))
        self.dealLogoImg.setImageWithURL(NSURL(string:(dealsDic.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        NSUserDefaults.standardUserDefaults().setObject(dealsDic.valueForKey("Image_URL"), forKey: "POPUP_LOGO")
        self.dealNameLbl.text = dealsDic.valueForKey("Name") as?String
        //Background Image_URL
        //Image_URL
        //Name
        
        // Do any additional setup after loading the view.
        
        //self.currentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutUsViewController")
        
        let offersController : AboutUsViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("AboutUsViewController") as? AboutUsViewController)!
        offersController.offersDic = NSDictionary(dictionary: self.dealsDic)
        self.currentViewController = offersController
        self.currentViewController!.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.currentViewController!)
        self.addSubview(self.currentViewController!.view, toView: self.containerView)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "appBg")!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(FineDiningViewController.showPopUp(_:)), name: "ShowPopUp", object: nil)
        
    }
    
    func showPopUp(notification: NSNotification){

        let popup = PopupController
            .create(self)
            .customize(
                [
                    .Animation(.SlideUp),
                    .Scrollable(false),
                    .Layout(.Center),
                    .BackgroundStyle(.BlackFilter(alpha: 0.7))
                ]
            )
            .didShowHandler { popup in
            }
            .didCloseHandler { _ in
        }
        let container = DemoPopupViewController2.instance()
        container.closeHandler = { _ in
            popup.dismiss()
            print("pop up closed")
        }
        popup.show(container)
        
    }
    
    func addSubview(subView:UIView, toView parentView:UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[subView]|",
            options: [], metrics: nil, views: viewBindingsDict))
    }
    
    
    @IBAction func offerButtonAction(sender: AnyObject) {
        let offersController : OffersViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("OffersViewController") as? OffersViewController)!
        offersController.offersDic = NSDictionary(dictionary: self.dealsDic)
        offersController.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.cycleFromViewController(self.currentViewController!, toViewController: offersController)
        self.currentViewController = offersController
        
        
    }
    
    @IBOutlet weak var offerButtonAction: UIButton!
    @IBAction func aboutButtonAction(sender: AnyObject) {
        
        
        let newViewController : AboutUsViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("AboutUsViewController") as? AboutUsViewController)!
        newViewController.offersDic = NSDictionary(dictionary: self.dealsDic)
        newViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.cycleFromViewController(self.currentViewController!, toViewController: newViewController)
        self.currentViewController = newViewController
    }
    
    @IBAction func mapButtonAction(sender: AnyObject) {
        
        let newViewController : MapViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("MapViewController") as? MapViewController)!
        if (dealsDic.valueForKey("Latitude")) != nil {
            newViewController.lat = Double(dealsDic.valueForKey("Latitude")! as! String)
            newViewController.lon =  Double(dealsDic.valueForKey("Longitude")! as! String)
            newViewController.view.translatesAutoresizingMaskIntoConstraints = false
            self.cycleFromViewController(self.currentViewController!, toViewController: newViewController)
            self.currentViewController = newViewController
        }else{
            let alert = UIAlertController(title: "Alert!!!", message: "Sorry!!Location Not Available!!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default) {
                UIAlertAction in
                //self.navigationController?.popViewControllerAnimated(true)
                
            }
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        //dealsDic.valueForKey("BackgroundImage_URL") as?String)
        //Latitude, Longitude  lat = 17.3850
       // lon = 78.4867
        
    }
    
    
    func cycleFromViewController(oldViewController: UIViewController, toViewController newViewController: UIViewController) {
        oldViewController.willMoveToParentViewController(nil)
        self.addChildViewController(newViewController)
        self.addSubview(newViewController.view, toView:self.containerView!)
        newViewController.view.alpha = 0
        newViewController.view.layoutIfNeeded()
        UIView.animateWithDuration(0.5, animations: {
            newViewController.view.alpha = 1
            oldViewController.view.alpha = 0
            },
                                   completion: { finished in
                                    oldViewController.view.removeFromSuperview()
                                    oldViewController.removeFromParentViewController()
                                    newViewController.didMoveToParentViewController(self)
        })
    }
    @IBAction func likeBtnAction(sender: AnyObject) {
        
        
    }

    @IBAction func callBtnAction(sender: AnyObject) {
        let primaryNumber = self.dealsDic.valueForKeyPath("Phone number") as! String!
        callNumber(primaryNumber!)
        
    }
    
    @IBAction func shareBtnAction(sender: AnyObject) {
        
        let description = "Coupcon"
        let url = self.dealsDic.valueForKey("publicURL") as? String
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: [description,url!], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToWeibo, UIActivityTypeCopyToPasteboard, UIActivityTypeAddToReadingList, UIActivityTypePostToVimeo]
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    private func callNumber(phoneNumber:String) {
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber)")!)
    }
}
