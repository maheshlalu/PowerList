
//
//  ViewController.swift
//  Banner_Swift
//
//  Created by Rambabu Mannam on 19/11/16.
//  Copyright © 2016 Rambabu Mannam. All rights reserved.
//

import UIKit

class BannerViewController: UIViewController,UIScrollViewDelegate {
    let bannerScrollView : UIScrollView = UIScrollView()
    var imagesArray : NSArray = NSArray()
    var pageCount : NSInteger = NSInteger()
    var bannerPageControl : UIPageControl = UIPageControl()
    var pageViewsArray : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        bannerScrollView.frame = CGRect(x:0,y:0,width:self.view.frame.size.width,height:self.view.frame.size.height)
        bannerScrollView.clipsToBounds = true
        bannerScrollView.pagingEnabled = true
        bannerScrollView.showsVerticalScrollIndicator = false
        bannerScrollView.showsHorizontalScrollIndicator = false
        bannerScrollView.scrollsToTop = false
        bannerScrollView.delegate = self
        self.view.addSubview(bannerScrollView)
        
        imagesArray = ["slideScreen1","slideScreen2","slideScreen3","slideScreen4"]
        pageCount = imagesArray.count
        
         // Set up the page control
        bannerPageControl.currentPage = 0
        bannerPageControl.numberOfPages = pageCount
        bannerPageControl.frame = CGRect(x: bannerScrollView.frame.size.width/2-50, y: bannerScrollView.frame.size.height-100, width: 100, height: 40)
        bannerPageControl.currentPageIndicatorTintColor = UIColor.redColor()
        bannerPageControl.pageIndicatorTintColor = UIColor.whiteColor()
        bannerPageControl.tintColor = UIColor.yellowColor()
        self.view.addSubview(bannerPageControl)
        
        // Set up the array to hold the views for each page
        for _ in 0..<pageCount {
            pageViewsArray.addObject(NSNull())
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let pagesScrollViewSize : CGSize = bannerScrollView.frame.size
        let width : NSInteger = NSInteger(pagesScrollViewSize.width)
        bannerScrollView.contentSize = CGSize(width:width*pageCount,height:NSInteger(pagesScrollViewSize.height))
        self.loadVisiblePages()
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let PageWidth : CGFloat = bannerScrollView.frame.size.width
        let page : NSInteger = NSInteger(floor((bannerScrollView.contentOffset.x*2.0+PageWidth)/(PageWidth*2.0)))
        
         // Update the page control
        bannerPageControl.currentPage = page
        
        // Work out which pages we want to load
        let firstPage : NSInteger = page-1
        let lastPage : NSInteger = page+1
        
        // Purge anything before the first page
        for i in 0..<firstPage {
           self.purgePage(i)
        }
        for i in firstPage..<lastPage+1 {
            self.loadPage(i)
        }
        for i in lastPage+1..<imagesArray.count {
        
            self.purgePage(i)
        }
        
    }
    
    func loadPage(page:NSInteger) {
        if page<0 || page>=imagesArray.count {
            // If it's outside the range of what we have to display, then do nothing
            return

        }
        
        // Load an individual page, first seeing if we've already loaded it
        if pageViewsArray[page] is NSNull {
//            let pageView : UIView = pageViewsArray[page] as! UIView
            var frame : CGRect = bannerScrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let imageView : UIImageView = UIImageView.init(image: UIImage.init(named: imagesArray[page] as! String))
            imageView.contentMode = UIViewContentMode.ScaleToFill
            imageView.frame = frame
            bannerScrollView.addSubview(imageView)
            pageViewsArray.replaceObjectAtIndex(page, withObject: imageView)
            
        }
        
    }
    
    func purgePage(page:NSInteger) {
        if page<0 || page>=imagesArray.count {
            // If it's outside the range of what we have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if pageViewsArray[page] is NSNull  {
            
        }
        else {
            let pageView : UIView = pageViewsArray[page] as! UIView
            pageView.removeFromSuperview()
             pageViewsArray.replaceObjectAtIndex(page, withObject: NSNull())
        }
    }
    
    internal func scrollViewDidScroll(scrollView: UIScrollView) {
         // Load the pages which are now on screen
        self.loadVisiblePages()
    }

    

}

