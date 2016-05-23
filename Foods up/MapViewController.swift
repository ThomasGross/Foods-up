//
//  MapViewController.swift
//  BurningFood
//
//  Created by Thomas Rasmussen on 12/05/2016.
//  Copyright © 2016 Thomas Rasmussen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Font_Awesome_Swift

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var btn_refreshPlacesOutlet: UIBarButtonItem!
    
    @IBAction func refreshPlaces(sender: UIButton) {
        refreshPlaces()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    var userLocation = CLLocation()
    
    var userRegion = MKCoordinateRegion()
    
    var locationManager = CLLocationManager() // håndterer positioner
    
    var relocation : Bool = false
    
    var closestItemName = ""
    
    var searchString : String = ""
    
    var customAnnotations : [CustomPointAnnotation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        

        self.navigationItem.rightBarButtonItem?.image = UIImage(icon: FAType.FARefresh, size: CGSize(width: 30, height: 30))
        
        
        
        // sets the delegate to be self
        locationManager.delegate = self
        
        // set the disired location to be best possible
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // We only want to use locationmanager when the app is used
        locationManager.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view.
        
    }
    
    func refreshPlaces() {
        textSearch(searchString)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        
        if relocation{
            refreshPlaces()
            relocation = true
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){ // when authorization is changed
        print ("Authorization status changed to \(status.rawValue)")
        switch status {
        case .Authorized, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation() // method that start looking for a location
            print("started updating")
            mapView.showsUserLocation = true
            relocation = true
            
        default:
            locationManager.stopUpdatingLocation()
            print("stopped updating")
            mapView.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        self.userLocation = location!
        
        let region = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate,700,700)
        
        self.userRegion = region
        self.mapView.setRegion(region, animated: true) //vis området på kortet
        
        
        if relocation{
            locationManager.stopUpdatingLocation()
            relocation = false
        }
        

        
    }//end locationManager
    
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            
            let btn = UIButton(type: .DetailDisclosure)
            
            btn.setFAIcon(FAType.FAInfo, forState: .Normal)
            btn.setFATitleColor(UIColor(red: 237.0/255.0, green: 67.0/255.0, blue: 55.0/255.0, alpha: 1), forState: .Normal)
            anView!.rightCalloutAccessoryView = btn
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        
        let image = UIImage(named: cpa.imageName)
        
        anView!.image = image
        
        
        return anView
    }
    
    func textSearch (searchString : String){ // egen funktion til at lede efter string fra UItextfiled via MapKit metode
        
        let request = MKLocalSearchRequest() // Core Location søgefunktion
        request.naturalLanguageQuery = searchString // hvad der skal søges efter udfra UItextfield indhold
        request.region = self.userRegion // området der søges udfra
        
        let search = MKLocalSearch(request: request) //udførslen af selve søgningen via MKLocalSearch
        search.startWithCompletionHandler { (response, error) in // processerer søgeresultater (respons.mapItems = liste af mapItems)
            guard let response = response else {
                print("Search error: \(error)")
                
                return
            }
            
            for item in response.mapItems { // looper igennem listen af mapItems
                print("Name = \(item.name!)") // printer resultaterne i konsollen
                
                
                let customAnnotation = CustomPointAnnotation() // lav annotation for hver item
                customAnnotation.coordinate = item.placemark.coordinate // assign koordinat
                customAnnotation.title = item.name // assign titel
                customAnnotation.subtitle = item.placemark.title
                customAnnotation.imageName = "annotation-icon"
                customAnnotation.phonenr = item.phoneNumber
                customAnnotation.homepageurl = "\(item.url)"
                
                print(item.phoneNumber)
                print(item.url)
                
                self.mapView.addAnnotation(customAnnotation) // placer pin
            }
        }
        
    }// end textSearch
}
