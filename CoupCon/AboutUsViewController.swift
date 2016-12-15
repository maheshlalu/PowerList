//
//  AboutUsViewController.swift
//  CoupCon
//
//  Created by apple on 18/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

struct StoreLocations {
    var Latitude: String
    var longitude: String
    var location: String
    var phoneNumber: String
    var address: String
    
    
    //    init(Latitude: String,
    //     longitude: String,
    //     location: String,
    //     phoneNumber: String,
    //     address: String) {
    //        self.Latitude = Latitude
    //        self.longitude = longitude
    //        self.location = location
    //        self.phoneNumber = phoneNumber
    //        self.address = address
    //    }
    
    
}

class AboutUsViewController: UIViewController {
    var offersDic : NSDictionary?
    var merchantDict : NSMutableDictionary?
    
    var storeLocationArray = [StoreLocations]()
    
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var aboutWebView: UIWebView!
    @IBOutlet weak var aboutTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(offersDic)
        
        
        self.aboutTableView.estimatedRowHeight = 50
        self.aboutTableView.rowHeight = UITableViewAutomaticDimension
        
        /* let aboutTxt :String =  self.offersDic?.valueForKey("Description") as! String
         
         //let aboutTxt :String =  self.offersDic?.valueForKey("Offers") as! String
         // self.aboutTextView.text = aboutTxt
         let descriptionTxt = "<span style=\"font-family: Roboto-Regular; font-size: 14\">\(aboutTxt)</span>"
         
         self.aboutWebView.loadHTMLString(descriptionTxt, baseURL: nil)*/
        self.view.backgroundColor = UIColor.clearColor()
        self.intializeNibs()
        self.parsingAboutUsDetails()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func intializeNibs(){
        
        self.aboutTableView.delegate = self
        self.aboutTableView.dataSource = self
        
        let nib = UINib(nibName: "MerchantDetailsTableViewCell", bundle: nil)
        self.aboutTableView.registerNib(nib, forCellReuseIdentifier: "MerchantDetailsTableViewCell")
        
        let locationNib = UINib(nibName: "MerchantLocationTableViewCell", bundle: nil)
        self.aboutTableView.registerNib(locationNib, forCellReuseIdentifier: "MerchantLocationTableViewCell")
    }
    
    func parsingAboutUsDetails(){
        
        let keys = ["jobTypeName","Timings","Image_URL","Address","PhoneNumber","Latitude","Longitude","Location"]
        let dictionaryKeys : NSArray = (offersDic?.allKeys)!
        var isContains : Bool = false
        for string in keys {
            if dictionaryKeys.containsObject(string) {
                isContains = true
            }else{
                isContains = false
                break
            }
   

        }
       
        if isContains {
        self.merchantDict = NSMutableDictionary()
        self.merchantDict! .setObject((offersDic?.valueForKey("jobTypeName"))!, forKey: "Category")
        self.merchantDict! .setObject((offersDic?.valueForKey("Timings"))!, forKey: "Timings")
        self.merchantDict! .setObject((offersDic?.valueForKey("Image_URL"))!, forKey: "Image_URL")
        self.aboutTableView.reloadData()
        //jobTypeName
        if ((offersDic?.valueForKey("Address") as? [String]) != nil) {
            //Array
            let addressArray : NSArray = (offersDic?.valueForKey("Address"))! as! NSArray
            let phoneArray : NSArray = (offersDic?.valueForKey("PhoneNumber"))! as! NSArray
            let latitudeArray : NSArray = (offersDic?.valueForKey("Latitude"))! as! NSArray
            let longitudeArray : NSArray = (offersDic?.valueForKey("Longitude"))! as! NSArray
            let location : NSArray = (offersDic?.valueForKey("Location"))! as! NSArray
          //  print("\(addressArray)\(phoneArray)\(latitudeArray)\(longitudeArray)\(location)")
            for var i = 0; i < addressArray.count; i += 1 {
                let locationStruct : StoreLocations = StoreLocations(Latitude: latitudeArray[i] as! String, longitude: longitudeArray[i] as! String , location: location[i] as! String, phoneNumber: phoneArray[i] as! String, address: addressArray[i] as! String)
                storeLocationArray.append(locationStruct)
            }
        }else{
        //String
            let locationStruct : StoreLocations = StoreLocations(Latitude: offersDic?.valueForKey("Latitude") as! String, longitude: (offersDic?.valueForKey("Longitude"))! as! String, location: (offersDic?.valueForKey("Location")) as! String, phoneNumber: (offersDic?.valueForKey("PhoneNumber")) as! String, address: (offersDic?.valueForKey("Address")) as! String)
            storeLocationArray.append(locationStruct)
        }
    }
        
    }
    
    
}


extension AboutUsViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if ((self.merchantDict?.valueForKey("Description")) != nil){
            let aboutTxt :String =  self.offersDic?.valueForKey("Description") as! String
            if aboutTxt.isEmpty {
                return 2
            }
        }else{
            return 1
        }
       
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        if section == 1 {
            return self.storeLocationArray.count
        }
        
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.allowsSelection = false
        if indexPath.section == 0 {
            let detailCell:MerchantDetailsTableViewCell = (tableView.dequeueReusableCellWithIdentifier("MerchantDetailsTableViewCell", forIndexPath: indexPath)as? MerchantDetailsTableViewCell)!
            
            if ((self.merchantDict?.valueForKey("Image_URL")) != nil){
                detailCell.iconImgView.setImageWithURL(NSURL(string:(self.merchantDict!.valueForKey("Image_URL") as?String)!), usingActivityIndicatorStyle: .Gray)
            }
        
            return detailCell
            
        }else if indexPath.section == 1 {
            let detailCell:MerchantLocationTableViewCell = (tableView.dequeueReusableCellWithIdentifier("MerchantLocationTableViewCell", forIndexPath: indexPath)as? MerchantLocationTableViewCell)!
            let storeLocation : StoreLocations =  (self.storeLocationArray[indexPath.row] as? StoreLocations)!
            let addrssText : String = storeLocation.location + "\n " + storeLocation.address + "\n " + storeLocation.phoneNumber
            detailCell.locationTextView.text = addrssText
            detailCell.locationTextView.font = CXAppConfig.sharedInstance.appLargeFont()
            detailCell.locationTextView.dataDetectorTypes = .PhoneNumber
            detailCell.aboutWebView.hidden = true
            detailCell.mapBtn.hidden = false
            detailCell.mapBtn.tag = indexPath.row
            detailCell.mapBtn.addTarget(self, action: #selector(navigateToDestionation(_:)), forControlEvents: .TouchUpInside)

            return detailCell
        }
        
        let detailCell:MerchantLocationTableViewCell = (tableView.dequeueReusableCellWithIdentifier("MerchantLocationTableViewCell", forIndexPath: indexPath)as? MerchantLocationTableViewCell)!
        detailCell.aboutWebView.hidden = false
        detailCell.mapBtn.hidden = true
        let aboutTxt :String =  self.offersDic?.valueForKey("Description") as! String
        //let aboutTxt :String =  self.offersDic?.valueForKey("Offers") as! String
        // self.aboutT.extView.text = aboutTxt
        let descriptionTxt = "<span style=\"font-family: Roboto-Regular; font-size: 13\">\(aboutTxt)</span>"
        print(aboutTxt)
        detailCell.aboutWebView.loadHTMLString(descriptionTxt, baseURL: nil)
        return detailCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return 80
        }
        return 120

    }
    
    func navigateToDestionation(button:UIButton){
        
        let storeLocation : StoreLocations =  (self.storeLocationArray[button.tag] as? StoreLocations)!
        let destinationLatitude = Double(storeLocation.Latitude)
        let destinationLongtitude = Double(storeLocation.longitude)
        let googleMapUrlString = String.localizedStringWithFormat("http://maps.google.com/?daddr=%f,%f", destinationLatitude!, destinationLongtitude!)
        UIApplication.sharedApplication().openURL(NSURL(string:
            googleMapUrlString)!)


    }
    
}