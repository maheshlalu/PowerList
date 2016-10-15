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

    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var nearByBtn: UIButton!
    @IBOutlet weak var dealsBtn: UIButton!
    @IBOutlet weak var homeTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.storeCategoryArray = NSArray()
        self.addSidePanelButton()
        
        CXDataService.sharedInstance.getTheAppDataFromServer(["type":"ProductCategories","mallId":CXAppConfig.sharedInstance.getAppMallID()]) { (responseDict) in
            print(responseDict)
            
            self.storeCategoryArray = NSArray(array: (responseDict.valueForKey("jobs") as? NSArray)!)
            self.homeTableView.reloadData()

        }
        
        
       /* let menuItem = UIBarButtonItem(image: UIImage(named: "reveal-icon"), style: .Plain, target: self.revealViewController(), action: "revealToggle:")
        self.navigationItem.leftBarButtonItem = menuItem
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())*/
        // Do any additional setup after loading the view.
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
        self.drawer.open()
    }
}

extension HomeViewController:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeCategoryArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : HomeTableCell = (tableView.dequeueReusableCellWithIdentifier("HomeTableCell", forIndexPath: indexPath) as? HomeTableCell)!
        
        let categoryDic : NSDictionary = self.storeCategoryArray[indexPath.row] as! NSDictionary

        cell.categoryImgView.setImageWithURL(NSURL(string:(categoryDic.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
//sd_setImageWithURL(NSURL(string:(categoryDic.valueForKey("Image_URL") as?String)!))
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let categoryDic : NSDictionary = self.storeCategoryArray[indexPath.row] as! NSDictionary
        var dealsVc : DealsViewController = DealsViewController()
        //dealsVc.categoryDict = categoryDic
        
        let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        dealsVc = storyBoard.instantiateViewControllerWithIdentifier("DealsViewController") as! DealsViewController

        self.navigationController?.pushViewController(dealsVc, animated: true)

    }
    
    
}
