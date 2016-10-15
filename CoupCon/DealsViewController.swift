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
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":selectedName,"mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            print(responseDict)
            self.dealsArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
            self.collectionview.reloadData()
            
        }
        
        //Name

        // Do any additional setup after loading the view.
        let tap = UITapGestureRecognizer(target: self, action: #selector(CXSigninViewController.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        
        //        let fbLoginBtn = FBSDKLoginButton.init(frame: CGRectMake((self.view.frame.size.width-200)/2, hLabel.frame.size.height+hLabel.frame.origin.y+10, 200, 40))
        //        fbLoginBtn.delegate = self
        //        fbLoginBtn.readPermissions = ["public_profile", "email", "user_friends"];
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func handleTap(sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.dismissViewControllerAnimated(false) { 
            
        }    }

    
    
    
    
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
        screenWidth =  UIScreen.mainScreen().bounds.size.width
        
        return CGSize(width: screenWidth/2-19, height: 170)
        
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
