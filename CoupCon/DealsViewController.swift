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
    @IBOutlet weak var collectionview: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let nib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionview.registerNib(nib, forCellWithReuseIdentifier: "CollectionViewCell")

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        
        
        return 1
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        
        return 30
        
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
        
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath)
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
