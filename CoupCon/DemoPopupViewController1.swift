//
//  DemoPopupViewController1.swift
//  PopupController
//
//  Created by 佐藤 大輔 on 2/4/16.
//  Copyright © 2016 Daisuke Sato. All rights reserved.
//

import UIKit

class DemoPopupViewController1: UIViewController, PopupContentViewController {
    
    var closeHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func instance() -> DemoPopupViewController1 {
        let storyboard = UIStoryboard(name: "DemoPopupViewController1", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DemoPopupViewController1
    }
    
    func sizeForPopup(popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 280,height: 400)
    }
    
    @IBAction func didTapCancelBtn(sender: AnyObject) {
        self.closeHandler!()
    }

    @IBAction func redeemBtnAction(sender: AnyObject) {
        print("redeem btn action")
        
    }

}
