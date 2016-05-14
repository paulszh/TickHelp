//
//  GeoFireViewController.swift
//  TickHelp
//
//  Created by Hongda Xiao on 5/14/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import Firebase
import GeoFire

class GeoFireViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let geofireRef = Firebase(url: constant.userURL)
        let geoPath = geofireRef.childByAppendingPath("locations")
        let geoFire = GeoFire(firebaseRef: geoPath)
        
        /* does not work because the GeoFire data has 
            to be queried separately..
 
        var ref = Firebase(url: constant.userURL)
        var refPath = ref.childByAppendingPath("users")
            .childByAppendingPath(constant.uid)

        let geoFire = GeoFire(firebaseRef: refPath)
     //   let geoFire = GeoFire(firebaseRef: geofireRef)
        
        */
        
     //   geoFire.setLocation(CLLocation(latitude: 37.7853889, longitude: -122.4056973), forKey: "firebase-hq")
        geoFire.setLocation(CLLocation(latitude: 37.7853889, longitude: -122.4056973), forKey: constant.uid) { (error) in
            if (error != nil) {
                print("An error occured: \(error)")
            } else {
                print("Saved location successfully!")
            }
        }
        
        let center = CLLocation(latitude: 37.7832889, longitude: -122.4056973)
        // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
        var circleQuery = geoFire.queryAtLocation(center, withRadius: 0.6)
        
        // Query location by region
        let span = MKCoordinateSpanMake(0.001, 0.001)
        let region = MKCoordinateRegionMake(center.coordinate, span)
        var regionQuery = geoFire.queryWithRegion(region)
       // print("...hello")
       // print(regionQuery)
       // print("...end")
        
        var queryHandle = circleQuery.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
            print("Key '\(key)' entered the search area and is at location '\(location)'")
        })
        
        
        
        
    }
    
    


    
    

}
