//
//  MoodViewController.swift
//  moodmaps
//
//  Created by Shreenithi Narayanan on 12/7/16.
//  Copyright © 2016 Shreenithi Narayanan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MoodViewController: UIViewController, CLLocationManagerDelegate {
    
    var businesses: [Business]!
    var locationManager: CLLocationManager!
    var searchTerms: [String: String] = ["ice cream": "Sad", "animal": "Sad", "chocolate": "Sad", "yoga": "Stressed", "park": "Stressed", "spa": "Stressed", "movie": "Bored", "bowling": "Bored", "pool": "Bored", "mall": "Bored", "museum": "Curious", "library": "Curious", "book": "Curious", "college": "Curious", "volunteer": "Generous", "soup kitchen": "Generous", "food bank": "Generous", "donation": "Generous", "salon": "Daring", "adventure": "Daring", "casino": "Daring", "gym": "Lethargic", "dance studio": "Lethargic", "dessert": "Lethargic", "dance": "Happy", "food": "Happy", "concert": "Excited", "art": "Excited", "run": "Excited", "relaxation": "Angry", "calming": "Angry"]
    static var results : [String : String] = [:]
    var locality = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getLocation();
    }
    
    func yelpQuery(map : MapViewController, search: String) {
        Business.searchWithTerm(term: search, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            var counter: Int = 0
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    if (counter == 5) {
                        return;
                    }
                    MoodViewController.results[business.name!] = business.id!
                    let address = business.address! + ", " + business.city! + ", " + business.state! + ", " + business.country!
                    let geocoder = CLGeocoder()
                    geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                        if((error) != nil){
                            print("Error", error!)
                        }
                        if let placemark = placemarks?.first {
                            let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                            let dropPin = MKPointAnnotation()
                            dropPin.coordinate = coordinates
                            dropPin.title = business.name!
                            map.mapView.addAnnotation(dropPin)
                        }
                    })
                    counter += 1;
                }
            }
            
        })
    }
    
    static func getResults() -> [String : String] {
        return results;
    }
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied || status == .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation: CLLocation = locations[locations.count - 1]
        let latLon = "\(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)"
        YelpClient.sharedInstance.passLatLon(coordinates: latLon);
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        MoodViewController.results = [:]
        if let dest = segue.destination as? UINavigationController {
            if let target = dest.topViewController as? MapViewController {
                target.newTitle = segue.identifier!
                for (searchTerm, mood) in searchTerms {
                    if (segue.identifier == mood) {
                        yelpQuery(map : target, search : searchTerm);
                    }
                }
            }
        }
    }
    
}
