//
//  HomeViewController.swift
//  CoupCon
//
//  Created by apple on 13/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, ICSDrawerControllerPresenting{

    
    var drawer : ICSDrawerController!
    var storeCategoryArray : NSArray! = nil
    var refresher : UIRefreshControl = UIRefreshControl()
    var coverPageImagesList: NSMutableArray!
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sideMenuBtn: UIButton!
    @IBOutlet weak var homecollectionview: UICollectionView!
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var nearByBtn: UIButton!
    @IBOutlet weak var dealsBtn: UIButton!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var pagerView: KIImagePager!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSideMenu()
        refresher = UIRefreshControl()
        self.homecollectionview!.alwaysBounceVertical = true
        refresher.tintColor = UIColor.redColor()
        self.setUPTheNavigationProperty()
        //refresher.addTarget(self, action: #selector(loadData), forControlEvents: .ValueChanged)
       // homecollectionview!.addSubview(refresher)
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let nib = UINib(nibName: "HomeCollectionViewCell", bundle: nil)
        
        self.homecollectionview.registerNib(nib, forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        self.storeCategoryArray = NSArray()
        self.coverPageImagesList = NSMutableArray()
        self.addSidePanelButton()
        LoadingView.show("Loading...", animated: true)
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"ProductCategories","mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            self.storeCategoryArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
            self.homecollectionview.reloadData()
            LoadingView.hide()
        }
        self.getTheGalleryItems()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "appBg")!)
        
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 30, right: 30)
        layout.itemSize = CGSize(width: screenWidth-30, height: 250)
        //layout.minimumInteritemSpacing = 0
        //layout.minimumLineSpacing = 0
        homecollectionview!.collectionViewLayout = layout
        
        
       /* let menuItem = UIBarButtonItem(image: UIImage(named: "reveal-icon"), style: .Plain, target: self.revealViewController(), action: "revealToggle:")
        self.navigationItem.leftBarButtonItem = menuItem
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())*/
        // Do any additional setup after loading the view.
    }
    
    
    func setUPTheNavigationProperty(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true

    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    func setUpSideMenu(){
        let menuItem = UIBarButtonItem(image: UIImage(named: "sidePanelMenu"), style: .Plain, target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)))
        self.navigationItem.leftBarButtonItem = menuItem
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())

        //self.sideMenuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), forControlEvents: .TouchUpOutside)
    }
    
    func loadData()
    {
        //code to execute during refresher
        //Call this to stop refresher
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"ProductCategories","mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            self.storeCategoryArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
            self.homecollectionview.reloadData()
            self.refresher.endRefreshing()
            
        }
    }
    
    
    func getTheGalleryItems(){
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"Stores","mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            let jobs : NSArray =  responseDict.valueForKey("jobs")! as! NSArray
            let jobDic : NSDictionary = (jobs.lastObject as? NSDictionary)!
            let attachMents : NSArray =  jobDic.valueForKey("Attachments")! as! NSArray
            for attachMent in attachMents {
                let galaryData : NSDictionary = (attachMent as? NSDictionary)!
                if galaryData.valueForKey("isCoverImage") as? String == "true" {
                    self.coverPageImagesList.addObject((galaryData.valueForKey("URL") as? String)!)
                }
            }
            self.pagerView.checkWetherToToggleSlideshowTimer()
            self.pagerView.slideshowTimeInterval = 3
            self.pagerView.reloadData()
    
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addSidePanelButton(){
    
    
    
    }
    
    
    func applyTheButtonProperties(button:UIButton){
        button.layer.cornerRadius = 8.0
        button.layer.borderColor = UIColor.blackColor().CGColor
        button.layer.borderWidth = 2.0
        
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

extension HomeViewController{
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return.LightContent
    }
    
    func drawerControllerWillOpen(drawerController: ICSDrawerController!) {
        self.view.userInteractionEnabled = false;
    }
    
    func drawerControllerDidClose(drawerController: ICSDrawerController!) {
        self.view.userInteractionEnabled = true;

    }
    @IBAction func sideMenuAction(sender: AnyObject) {
       // self.drawer.open()
        //SWRevealViewController.revealToggle(_:)
        self.revealViewController().revealToggle(nil)

    }
}

extension HomeViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return self.storeCategoryArray.count
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell : HomeCollectionViewCell = (collectionView.dequeueReusableCellWithReuseIdentifier("HomeCollectionViewCell", forIndexPath: indexPath)as? HomeCollectionViewCell)!
        
        cell.layer.masksToBounds = false
        //cell.layer.borderColor = UIColor.whiteColor().CGColor
        //cell.layer.borderWidth = 7.0s
        cell.layer.contentsScale = UIScreen.mainScreen().scale
        cell.layer.shadowOpacity = 0.75
        cell.layer.shadowRadius = 5.0
        cell.layer.shadowOffset = CGSize.zero
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).CGPath
        cell.layer.shouldRasterize = true
        
        let categoryDic : NSDictionary = self.storeCategoryArray[indexPath.item] as! NSDictionary
        cell.categoryImageView.setImageWithURL(NSURL(string:(categoryDic.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        cell.subCategoryLbl.text =  categoryDic.valueForKey("Name") as? String
       // cell.subCategoryLbl.text = categoryDic

        return cell
        
        
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        
        
       return 1
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let categoryDic : NSDictionary = self.storeCategoryArray[indexPath.item] as! NSDictionary
        var dealsVc : DealsViewController = DealsViewController()
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        dealsVc = storyBoard.instantiateViewControllerWithIdentifier("DealsViewController") as! DealsViewController
        dealsVc.selectedName = categoryDic.valueForKey("Name")! as! String
        self.navigationController?.pushViewController(dealsVc, animated: true)
        
        var fineDinigVc : CXSigninViewController = CXSigninViewController()
        //dealsVc = storyBoard.instantiateViewControllerWithIdentifier("DealsViewController") as! DealsViewController
        //dealsVc.selectedName = categoryDic.valueForKey("Name")! as! String
        fineDinigVc = storyBoard.instantiateViewControllerWithIdentifier("CXSigninViewController") as! CXSigninViewController
        //self.navigationController?.pushViewController(fineDinigVc, animated: true)
        
    }
    
    
    }


extension HomeViewController:KIImagePagerDelegate,KIImagePagerDataSource {
    
    //    }
    
    func contentModeForImage(image: UInt, inPager pager: KIImagePager!) -> UIViewContentMode {
        
        return .ScaleAspectFill
    }
    
    func arrayWithImages(pager: KIImagePager!) -> [AnyObject]! {
        return self.coverPageImagesList as [AnyObject]
    }
    
}

extension HomeViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked( searchBar: UISearchBar)
    {
//        self.productSearhBar.resignFirstResponder()
//        self.doSearch()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
       
        
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Do a default fetch of the beers
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        
        var dealsVc : SearchViewController = SearchViewController()
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        dealsVc = storyBoard.instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        self.navigationController?.pushViewController(dealsVc, animated: true)
        return false
    }
    
}




    
  /*  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeCategoryArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : HomeTableCell = (tableView.dequeueReusableCellWithIdentifier("HomeTableCell", forIndexPath: indexPath) as? HomeTableCell)!
        
        let categoryDic : NSDictionary = self.storeCategoryArray[indexPath.row] as! NSDictionary

        cell.categoryImgView.setImageWithURL(NSURL(string:(categoryDic.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let categoryDic : NSDictionary = self.storeCategoryArray[indexPath.row] as! NSDictionary
        var dealsVc : DealsViewController = DealsViewController()
    
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        
       
        dealsVc = storyBoard.instantiateViewControllerWithIdentifier("DealsViewController") as! DealsViewController
        dealsVc.selectedName = categoryDic.valueForKey("Name")! as! String
         let delasNav : UINavigationController = UINavigationController(rootViewController: dealsVc)
        
        var fineDinigVc : FineDiningViewController = FineDiningViewController()
        fineDinigVc = storyBoard.instantiateViewControllerWithIdentifier("FineDining") as! FineDiningViewController

        
        
        self.presentViewController(delasNav, animated: true) {
        }

        //self.navigationController?.pushViewController(dealsVc, animated: true)

        //FineDining
    }
    */
    

