//
//  OffersViewController.swift
//  CoupCon
//
//  Created by apple on 18/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class OffersViewController: UIViewController {

    
    
    var offersDic : NSDictionary?
    var offersList : NSArray!

    @IBOutlet weak var offersTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        offersList = NSArray()
        let nib = UINib(nibName: "OfferTableViewCell", bundle: nil)
        self.offersTableView.registerNib(nib, forCellReuseIdentifier: "OfferTableViewCell")
        let offerString :String =  self.offersDic?.valueForKey("Offers") as! String
        print(offerString)
        offersList = NSArray(array: offerString.componentsSeparatedByString("#"))
        //Offers
        // Do any additional setup after loading the view.
    }
    
    
    
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        return self.offersList.count
        
        
    }
    
    
    func getTheofferDisplayString(inputString : String) -> String{
        let component = inputString.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let list = component.filter({ $0 != "" })
        let number: Int64? = Int64(list.last!)
        return String(number)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell : OfferTableViewCell = (tableView.dequeueReusableCellWithIdentifier("OfferTableViewCell", forIndexPath: indexPath) as? OfferTableViewCell)!
        tableView.separatorStyle = .None
        
        let offerTitle : String = (self.offersList[indexPath.row] as?String)!

        let component = offerTitle.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let list = component.filter({ $0 != "" })
        print(component)
        print(list)
        let number: Int64? = Int64(list.last!)
        print(number)

        print(offerTitle.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).last)
        cell.offersLblText.text = offerTitle // offerTitle.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).last
        tableView.allowsSelection = false
        return cell
        
    }
    


    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        tableView.rowHeight = 110
        return 110
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
