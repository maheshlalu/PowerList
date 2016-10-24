//
//  SearchViewController.swift
//  CoupCon
//
//  Created by apple on 19/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var screenWidth:CGFloat! = nil
    var searchResults : NSArray! = nil
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var searchCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = NSArray()
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        
        self.searchCollectionView.registerNib(nib, forCellWithReuseIdentifier: "CollectionViewCell")
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "appBg")!)

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.searchResults.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell : CollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as? CollectionViewCell)!
        
        cell.layer.masksToBounds = false
        cell.layer.contentsScale = UIScreen.mainScreen().scale
        cell.layer.shadowOpacity = 0.75
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).CGPath
        cell.layer.shouldRasterize = true
        
        
        let categoryDic : NSDictionary = self.searchResults[indexPath.item] as! NSDictionary
        cell.dealsImgView.setImageWithURL(NSURL(string:(categoryDic.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        cell.productNameLbl.text = categoryDic.valueForKey("Name") as?String
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
        let dealsDic : NSDictionary = self.searchResults[indexPath.item] as! NSDictionary
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

    


}

extension SearchViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked( searchBar: UISearchBar)
    {
        self.searchBar.resignFirstResponder()
        self.doSearch()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        // print("search string \(searchText)")
        if (self.searchBar.text!.characters.count > 0) {
           // self.doSearch()
        } else {
           // self.loadDefaultList()
        }
    }
    
    func loadDefaultList (){
      
    }
    
    func refreshSearchBar (){
        self.searchBar.resignFirstResponder()
        // Clear search bar text
        self.searchBar.text = "";
        // Hide the cancel button
        self.searchBar.showsCancelButton = false;
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.refreshSearchBar()
        // Do a default fetch of the beers
        self.loadDefaultList()
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true;
    }
    
    func doSearch () {
        //http://storeongo.com:8081/Services/getMasters?type=allProducts&mallId=20217&keyWord=night
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"allProducts","keyWord":self.searchBar.text!,"mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            let jobs : NSArray =  responseDict.valueForKey("jobs")! as! NSArray
            self.searchResults = jobs
            self.searchCollectionView.reloadData()
            LoadingView.hide()
        }
    }
    
}


