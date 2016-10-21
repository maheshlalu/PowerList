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
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"allProducts","keyWord":self.searchBar.text!,"mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            let jobs : NSArray =  responseDict.valueForKey("jobs")! as! NSArray
            self.searchResults = jobs
            self.searchCollectionView.reloadData()
            
        }
        
    }
    
    
    
    
}


