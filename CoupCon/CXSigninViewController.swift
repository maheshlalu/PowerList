//
//  ViewController.swift
//  CoupCon
//
//  Created by apple on 13/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit

class CXSigninViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var userBtn: UIButton!
    
    
    @IBOutlet weak var passwordBtn: UIButton!
    
    @IBOutlet weak var usernameTf: UITextField!
    
    @IBOutlet weak var passwordTf: UITextField!
    
    @IBOutlet weak var checkBoxBtn: UIButton!
    
    @IBOutlet weak var rememberLabel: UILabel!
    
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var loginBtn2: UIButton!
    
    
    @IBOutlet weak var facebookBtn: UILabel!
    
    
    @IBOutlet weak var gmailBtn: UILabel!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.usernameTf.layer.borderColor = UIColor.whiteColor().CGColor
        self.usernameTf.layer.borderWidth = 1
        self.usernameTf.layer.cornerRadius = 5
        self.usernameTf.clipsToBounds = true
        self.usernameTf.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        
        
        self.passwordTf.layer.borderColor = UIColor.whiteColor().CGColor
        self.passwordTf.layer.borderWidth = 1
        self.passwordTf.layer.cornerRadius = 5
        self.passwordTf.clipsToBounds = true
        self.passwordTf.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.3)
        
        self.checkBoxBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.checkBoxBtn.layer.borderWidth = 1
        self.checkBoxBtn.layer.cornerRadius = 5
        self.checkBoxBtn.clipsToBounds = true
        
        self.loginBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.loginBtn.layer.borderWidth = 1
        self.loginBtn.layer.cornerRadius = 5
        self.loginBtn.clipsToBounds = true
        
        self.facebookBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.facebookBtn.layer.borderWidth = 1
        self.facebookBtn.layer.cornerRadius = 4
        self.facebookBtn.clipsToBounds = true
        
        
        self.gmailBtn.layer.borderColor = UIColor.whiteColor().CGColor
        self.gmailBtn.layer.borderWidth = 1
        self.gmailBtn.layer.cornerRadius = 4
        self.gmailBtn.clipsToBounds = true
        
        

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

