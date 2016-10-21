//
//  AboutUsViewController.swift
//  CoupCon
//
//  Created by apple on 18/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    var offersDic : NSDictionary?
    
    @IBOutlet weak var aboutTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(offersDic)
        
        let aboutTxt :String =  self.offersDic?.valueForKey("Description") as! String
        
        //let aboutTxt :String =  self.offersDic?.valueForKey("Offers") as! String
        self.aboutTextView.text = aboutTxt
        self.view.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
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
