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
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionview.registerNib(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionview.backgroundColor = UIColor.clearColor()
        // print("\(self.dealsDic) \(self.dealsDic!.allKeys)")
        print(selectedName)
        self.getTheDealsFromServer()
        self.addTheBarButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    
    func getTheDealsFromServer(){
       // selectedName = "Fine Dining"
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":selectedName,"mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            print(responseDict)
            self.dealsArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
            self.collectionview.reloadData()
        }
    }
    
    func addTheBarButtonItem(){
        //UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DealsViewController.backButtonAction))
        
        let sendButton = UIBarButtonItem(image: UIImage(named: "search"), style: .Plain, target: self, action: #selector(DealsViewController.searchButtonAction))
        
        self.navigationController!.navigationBar.barTintColor = UIColor(red: 160.0/255, green: 57.0/255, blue: 135.0/255, alpha: 0.0)
        
        //myLabel.backgroundColor = UIColor(red: 50.0/255, green: 150.0/255, blue: 65.0/255, alpha: 1.0)

        self.navigationItem.rightBarButtonItem = sendButton
        
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController!.navigationBar.tintColor = UIColor.grayColor()
    }

    func searchButtonAction(){
        var dealsVc : SearchViewController = SearchViewController()
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        dealsVc = storyBoard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
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
        let cell : CollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as? CollectionViewCell)!
        let categoryDic : NSDictionary = self.dealsArray[indexPath.item] as! NSDictionary
        cell.dealsImgView.setImageWithURL(NSURL(string:(categoryDic.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        return cell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake((self.view.frame.size.width/2) - 8, (self.view.frame.size.width/2) - 8);
        
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
        //dealsVc = storyBoard.instantiateViewControllerWithIdentifier("DealsViewController") as! DealsViewController
        //dealsVc.selectedName = categoryDic.valueForKey("Name")! as! String
        fineDinigVc = storyBoard.instantiateViewControllerWithIdentifier("FineDining") as! FineDiningViewController
        fineDinigVc.dealsDic = dealsDic
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
    
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
