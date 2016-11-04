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
    var dealsArray : NSArray! = nil
    
    var dealsDic : NSDictionary?
    var selectedName: String!
    @IBOutlet weak var collectionview: UICollectionView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dealsArray = NSArray()
        self.automaticallyAdjustsScrollViewInsets = false
        let nib = UINib(nibName: "DealsCollectionViewCell", bundle: nil)
        self.collectionview.registerNib(nib, forCellWithReuseIdentifier: "DealsCollectionViewCell")
        self.collectionview.backgroundColor = UIColor.clearColor()
        // print("\(self.dealsDic) \(self.dealsDic!.allKeys)")
        self.getTheDealsFromServer()
        self.addTheBarButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    
    func getTheDealsFromServer(){
       // selectedName = "Fine Dining"
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":selectedName,"mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            //print(responseDict)
            self.dealsArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
            self.collectionview.reloadData()
            LoadingView.hide()
        }
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
        cell.dealsImageView.setImageWithURL(NSURL(string:(categoryDic.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        cell.dealName.text = categoryDic.valueForKey("Name") as?String
        if cell.dealArea.text == "Label"{
            cell.dealArea.text = ""
        }else{
            cell.dealArea.text = categoryDic.valueForKey("Location") as? String
        }
        cell.callBtn.tag = indexPath.item+1
        cell.callBtn.addTarget(self, action: #selector(DealsViewController.phoneBtnAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
//            
//        }
        
    }
    
    func phoneBtnAction(button : UIButton!){
        
        let dealsDict : NSDictionary = self.dealsArray[button.tag-1] as! NSDictionary
        let phoneNumber = dealsDict.valueForKey("PhoneNumber") as?String
        UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phoneNumber!)")!)
 
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
