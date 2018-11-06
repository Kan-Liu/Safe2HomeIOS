//
//  ViewController.swift
//  Safe2HomeIOS
//
//  Created by Eric Le Ge on 11/1/18.
//  Copyright © 2018 Safe2Home. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HomeVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    let manager: CLLocationManager = global_manager
    var current_location: CLLocation?
    let regionRadius: CLLocationDistance = 1000
    @IBOutlet weak var map: HomeMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse,.authorizedAlways:
            break
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted, .denied:
            //prompt notification: see next slides
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to ____, please open Settings and set location access for this app to 'Always'.", preferredStyle: .alert)
            let openAction = UIAlertAction(title: "My Alert",
                style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occurred.")
            })
            alertController.addAction(openAction)
            let cancelAction = UIAlertAction(title:
                "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        manager.delegate = self
        map.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestLocation()
        
        map.showsUserLocation = true;
        
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        map.mapType = MKMapType(rawValue: 0)!
        map.userTrackingMode = MKUserTrackingMode(rawValue: 2)!
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        current_location = locations.last
        if let location = current_location{
            centerMapOnLocation(location: location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion =
            MKCoordinateRegion(
                center: location.coordinate,
                latitudinalMeters: regionRadius * 2.0,
                longitudinalMeters: regionRadius * 2.0)
        map.setRegion(coordinateRegion,animated: true)
        
    }
    
    
    


}
