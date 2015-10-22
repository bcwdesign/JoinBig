//
//  ViewController.swift
//  Where Am I
//
//  Created by Rob Percival on 13/03/2015.
//  Copyright (c) 2015 Appfish. All rights reserved.
//

import UIKit
import Parse
import Bolts
import MapKit
import CoreLocation
import AddressBook

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!
    
    var manager:CLLocationManager!
    var annotation = MKPointAnnotation()
    var customannotation = MKPointAnnotation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy - kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        
        uilpgr.minimumPressDuration = 2
        
        map.addGestureRecognizer(uilpgr)
        
        //Test Parse
        //let testObject = PFObject(className: "TestObject")
        //testObject["foo"] = "bar"
        //testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
           // print("Object has been saved.")
         //}
    
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       // <#code#>
    //}
   // }
    
    //func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [(CLLocation!) {
        
        print(locations)
        
        var userLocation:CLLocation = locations[0]
        
        var latitude:CLLocationDegrees = userLocation.coordinate.latitude
        
        var longitude:CLLocationDegrees = userLocation.coordinate.longitude
        
        var latDelta:CLLocationDegrees = 0.05
        
        var lonDelta:CLLocationDegrees = 0.05
        
        var span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        var location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        var region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
       map.setRegion(region, animated: false)
        
        //Remove existing annotation
        map.removeAnnotation(annotation)
        
        //Set the new one if we are moving
        annotation.coordinate = location
        
        annotation.title = "Current Location"
        
        annotation.subtitle = "On the move..."
        //annotation.pinColor = MKPinAnnotationColor.Green;
        
        map.addAnnotation(annotation)
        
        
        }
        
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func action(gestureRecognizer: UIGestureRecognizer) {
        
        if(gestureRecognizer.state == UIGestureRecognizerState.Began) { //only do this once
            
            print("Gesture Recognized")
            
            //Remove existing custom annotation since user can only put one
            map.removeAnnotation(customannotation)
            
            var touchPoint = gestureRecognizer.locationInView(self.map)
            
            var newCoordinate: CLLocationCoordinate2D = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            
            var location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                
                if (error == nil) {
                    //if let p = CLPlacemark(placemark: placemarks?[0] as! CLPlacemark)
                    
                    if let p = placemarks!.first {
                        
                        
                        var subThoroughfare:String = ""
                        var thoroughfare:String = ""
                        
                        if p.subThoroughfare != nil {
                            
                            subThoroughfare = p.subThoroughfare!
                            
                        }
                        
                        if p.thoroughfare != nil {
                            
                            thoroughfare = p.thoroughfare!
                            
                        }
                        
                        title = "\(subThoroughfare) \(thoroughfare)"
                        
                        
                    }
                    
                }
                
                if title == "" {
                    
                    title = "Added \(NSDate())"
                    
                }
                
                places.append(["name":title,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                print(["name":title,"lat":"\(newCoordinate.latitude)","lon":"\(newCoordinate.longitude)"])
                
                self.customannotation = MKPointAnnotation()
                
                self.customannotation.coordinate = newCoordinate
                
                self.customannotation.title = title
                
                self.customannotation.subtitle = "Where we are headed..."
                
                self.map.addAnnotation(self.customannotation)
                
                let mapObject = PFObject(className: "mapObject")
                mapObject["long"] = newCoordinate.longitude
                mapObject["lat"] = newCoordinate.latitude
                mapObject["name"] = "Johnny"
                mapObject["location"] = title
                mapObject["display"] = true
                mapObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                 print("MapObject has been saved.")
                }
            })
            
            
        }
        
    }

}

