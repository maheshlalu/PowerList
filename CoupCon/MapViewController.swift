//
//  MapViewController.swift
//  CoupCon
//
//  Created by apple on 18/10/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    let screenSize = UIScreen.mainScreen().bounds.size
    let locationManager = CLLocationManager()
    var lat:Double!
    var lon:Double!
    var mapView: MKMapView = MKMapView ()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.designMapview()
        self.locationManager.requestWhenInUseAuthorization()
            if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func designMapview () {
        
        self.mapView = MKMapView.init(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
        self.view.addSubview(self.mapView)
        self.mapView.delegate = self
        self.zoomToRegion()
       // self.addShowDirectionButton()
    }
    
   /* func addShowDirectionButton () {
        let showDirectionBtn : UIButton = UIButton.init(frame: CGRectMake(0, 0, 250, 30))
        self.mapView.addSubview(showDirectionBtn)
        showDirectionBtn.setTitle("Show Direction", forState: UIControlState.Normal)
        showDirectionBtn.titleLabel?.textColor = UIColor.whiteColor()
        showDirectionBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        showDirectionBtn.center = CGPointMake(screenSize.width/2, screenSize.height-100)
        self.view.bringSubviewToFront(showDirectionBtn)
        showDirectionBtn.addTarget(self, action: #selector(MapViewCntl.showMapDirection), forControlEvents: UIControlEvents.TouchUpInside)
    }*/
    
    func zoomToRegion() {
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        let annotation = Station(latitude: location.latitude, longitude: location.longitude)
        
        mapView.addAnnotation(annotation)
        
        mapView.setRegion(region, animated: true)
    }
    
    func showMapDirection(){
        
        self.showMapPointLocation()
        
    }
    func showMapPointLocation () {
        
        //18.5184° N, 84.1514° E
        
        //        self.lat = 18.5184
        //        let long = 84.1514
        
        var annotations:Array = [Station]()
        let annotation = Station(latitude:lat, longitude:lon)
        //let annotation1 = Station(latitude: 17.3840500	, longitude:  78.4563600)
        
        //annotations.append(annotation1)
        annotations.append(annotation)
        
        self.mapView.addAnnotation(annotation)
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        
        for annotation in annotations {
            points.append(annotation.coordinate)
        }
        
        
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        
        mapView.addOverlay(polyline)
        
    }
    
    
}

extension MapViewController :MKMapViewDelegate,CLLocationManagerDelegate {
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = UIColor.redColor()
            polylineRenderer.lineWidth = 3
            
        }
        return polylineRenderer
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        //
        //        let location = locations.last! as CLLocation
        //
        //        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        //
        //        self.mapView.setRegion(region, animated: true)
    }
    
   }

