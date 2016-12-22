//
//  DealsViewController.swift
//  CoupCon
//
//  Created by apple on 15/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class DealsViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
 var screenWidth:CGFloat! = nil
    var dealsArray : NSMutableArray! = nil
    
    var dealsDic : NSDictionary?
    var selectedName: String!
    var isFromFavorites : Bool = false
    @IBOutlet weak var collectionview: UICollectionView!
  
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.dealsArray = NSMutableArray()
        self.navigationController?.navigationBar.hidden = false
        let nib = UINib(nibName: "DealsCollectionViewCell", bundle: nil)
        self.collectionview.registerNib(nib, forCellWithReuseIdentifier: "DealsCollectionViewCell")
        self.collectionview.backgroundColor = UIColor.clearColor()
        // print("\(self.dealsDic) \(self.dealsDic!.allKeys)")
        
        if self.isFromFavorites {
            self.navigationController?.navigationBarHidden = false
            self.navigationItem.setHidesBackButton(true, animated:true);
            let navigation:UINavigationItem = navigationItem
            navigation.title  = "Favourites"
            let stores : NSArray = CX_Stores.MR_findAll()
            for dic in stores {
                let store : CX_Stores = dic as! CX_Stores
                self.dealsArray.addObject(CXDataService.sharedInstance.convertStringToDictionary(store.json!))
            }
            self.addTheBarButtonItem()
            self.setUpSideMenu()
        }else{
            self.getTheDealsFromServer()
            self.addTheBarButtonItem()
            if selectedName == "Birthday Offers" {
                self.setUpSideMenu()
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false

     //   self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController!.navigationBar.barTintColor = CXAppConfig.sharedInstance.getAppTheamColor()
        self.view.backgroundColor = UIColor.whiteColor()
        
      
    }
    
    
    func getTheDealsFromServer(){
       // selectedName = "Fine Dining"
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":selectedName,"mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            //print(responseDict)
            self.dealsArray = NSMutableArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
            self.collectionview.reloadData()
            LoadingView.hide()
        }
    }
    
    func setUpSideMenu(){
        
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        menuItem.tintColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = menuItem
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.title = self.selectedName
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.navigationController?.navigationBar.hidden = false
        
        
        //self.sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpOutside)
    }
    
    func addTheBarButtonItem(){
        //UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DealsViewController.backButtonAction))
        
        let sendButton = UIBarButtonItem(image: UIImage(named: "search"), style: .Plain, target: self, action: #selector(DealsViewController.searchButtonAction))
        sendButton.tintColor = UIColor.whiteColor()
       // self.navigationController!.navigationBar.barTintColor = UIColor(red: 160.0/255, green: 57.0/255, blue: 135.0/255, alpha: 0.0)
        //myLabel.backgroundColor = UIColor(red: 50.0/255, green: 150.0/255, blue: 65.0/255, alpha: 1.0)

        self.navigationItem.rightBarButtonItem = sendButton
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
    }

    func searchButtonAction(){
        var dealsVc : SearchViewController = SearchViewController()
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        dealsVc = storyBoard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        
        let backItem = UIBarButtonItem()
        backItem.title = "Search Deals"
        navigationItem.backBarButtonItem = backItem
        
        
        self.navigationController?.pushViewController(dealsVc, animated: true)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
         return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.dealsArray.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell : DealsCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("DealsCollectionViewCell", forIndexPath: indexPath) as? DealsCollectionViewCell)!
        
//        cell.layer.masksToBounds = false
//        cell.layer.contentsScale = UIScreen.mainScreen().scale
//        cell.layer.shadowOpacity = 0.75
//        cell.layer.shadowRadius = 5.0
//        cell.layer.shadowOffset = CGSize.zero
//        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).CGPath
//        cell.layer.shouldRasterize = true
        
        let categoryDic : NSDictionary = self.dealsArray[indexPath.item] as! NSDictionary
        
        
        if ((categoryDic.valueForKey("Image_URL")) != nil){
             cell.dealsImageView.setImageWithURL(NSURL(string:(categoryDic.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        }
        
       // cell.dealsImageView.setImageWithURL(NSURL(string:(categoryDic.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        
        cell.dealName.text = categoryDic.valueForKey("Name") as?String
        if cell.dealArea.text == "Label"{
            cell.dealArea.text = ""
        }else{
            cell.dealArea.text = categoryDic.valueForKey("Location") as? String
        }
        cell.callBtn.tag = indexPath.item+1
        cell.likeBtn.tag = indexPath.item+1
        
        cell.likeBtn.selected = CXDataService.sharedInstance.productIsAddedinList(CXAppConfig.resultString(categoryDic.valueForKey("id")!))

        cell.callBtn.addTarget(self, action: #selector(DealsViewController.phoneBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        cell.likeBtn.addTarget(self, action: #selector(DealsViewController.likeBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(self.view.frame.size.width,185)
        
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5
    }


    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dealsDic : NSDictionary = self.dealsArray[indexPath.item] as! NSDictionary
        var fineDinigVc : FineDiningViewController = FineDiningViewController()
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())

        fineDinigVc = storyBoard.instantiateViewControllerWithIdentifier("FineDining") as! FineDiningViewController
        fineDinigVc.dealsDic = dealsDic
        print(dealsDic)
       
//        let backItem = UIBarButtonItem()
//        backItem.title = dealsDic.valueForKey("Name")! as? String
//        navigationItem.backBarButtonItem = backItem
        
        self.navigationController?.pushViewController(fineDinigVc, animated: true)
       
//        var cell : CollectionViewCell = (collectionView.cellForItemAtIndexPath(indexPath) as? CollectionViewCell))
//        cell.clickToLabel.textColor = UIColor.redColor()
//        cell!.layer.borderWidth = 1.0
//        cell!.layer.borderColor = UIColor(red: 80.0/255.0, green: 159.0/255.0, blue: 192.0/255.0, alpha: 1.0).CGColor
//        
//        if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
//            let label = cell.viewWithTag(50) as? UILabel
//            label!.textColor = UIColor.redColor()
//            .
//        }
        
    }
    
    func phoneBtnAction(button : UIButton!){
        
        let dealsDataDict : NSDictionary = self.dealsArray[button.tag-1] as! NSDictionary
//        let phoneNumber = dealsDict.valueForKey("PhoneNumber") as?String
//        if (phoneNumber != nil) {
//            if  UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel://\(phoneNumber!)")!) {
//                UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber!)")!)
//
//            }
//        }
        
        
        var addressArray : NSMutableArray = NSMutableArray()
        
        if ((dealsDataDict.valueForKey("PhoneNumber") as? [String]) != nil) {
            //Array
            addressArray  = NSMutableArray(array: (dealsDataDict.valueForKey("PhoneNumber"))! as! NSArray)
        }else{
            //String
            
            if ((dealsDataDict.valueForKey("PhoneNumber")) != nil){
                let primaryNumber = dealsDataDict.valueForKeyPath("PhoneNumber") as! String!
                addressArray.addObject(primaryNumber)
            }
            
            
        }
        
        if addressArray.count == 1 {
            self.callNumber((addressArray.lastObject as? String)!)
            
        }else{
            
            let alert = UIAlertController(title: "Mobile", message: "Please Select Number", preferredStyle: .ActionSheet) // 1
            
            for item in addressArray {
                let firstAction = UIAlertAction(title: item as! String, style: .Default) { (alert: UIAlertAction!) -> Void in
                    self.callNumber(alert.title!)
                } // 2
                alert.addAction(firstAction) // 4
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (alert: UIAlertAction!) -> Void in
            }
            alert.addAction(cancelAction)
            presentViewController(alert, animated: true, completion:nil)
        }

 
    }
    private func callNumber(phoneNumber:String) {
        print(phoneNumber)
 
//        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel://\(phoneNumber))")!) {
//            UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber))")!)
//
//        }
        
//        let telephoneURL = NSURL(string: "telprompt://\(phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: ""))")
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: ""))")!)

//        if let telephoneURL = NSURL(string: "telprompt://\(phoneNumber.stringByReplacingOccurrencesOfString(" ", withString: ""))") {
//            UIApplication.sharedApplication().openURL(telelphoneURL)
//        }
    }
    
    func likeBtnAction(button : UIButton!){
       LoadingView.show("Loading...", animated: true)
        let dealsDict : NSDictionary = self.dealsArray[button.tag-1] as! NSDictionary
        let productId = CXAppConfig.resultString(dealsDict.valueForKey("id")!)
        CXDataService.sharedInstance.productAddedToFavorites(productId, likeStatus: button.selected ? "-1":"1",product: dealsDict) { (responseDict) in
            button.selected = !button.selected
            LoadingView.hide()
            dispatch_async(dispatch_get_main_queue(),{
                if self.isFromFavorites {
                    self.dealsArray.removeAllObjects()
                    let stores : NSArray = CX_Stores.MR_findAll()
                    print(stores.description)
                    if stores.count == 0{
                        self.dealsArray.removeAllObjects()
                        self.collectionview.reloadData()
                
                    }else{
                        for dic in stores {
                            let store : CX_Stores = dic as! CX_Stores
                            self.dealsArray.addObject(CXDataService.sharedInstance.convertStringToDictionary(store.json!))
                            self.collectionview.reloadData()
                        }
                    }
                }
            })
        }
    }

}
