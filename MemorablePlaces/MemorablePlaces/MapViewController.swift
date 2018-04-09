//
//  MapViewController.swift
//  MemorablePlaces
//
//  Created by Alexandre Henrique Silva on 22/03/18.
//  Copyright © 2018 Alexhenri. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    var     isFromCell = false
    var     activeRow = 0
    
    
    func errorManager(debugErrorMsg: String, userErrorMsg: String?){
        
        print(debugErrorMsg)

        if let userMsg = userErrorMsg {
            print(userMsg)
        } else {
            print("Sorry. An internal error occurred. Please try again.")

        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var latitude    : CLLocationDegrees = -22.9001132
        var longitude   : CLLocationDegrees = -43.301203
        var markName    = String()
        
        if(isFromCell){
            
            let placesNameArrayObject   = UserDefaults.standard.object(forKey: "placesNameArray")
            let placesLatArrayObject    = UserDefaults.standard.object(forKey: "placesLatArray")
            let placesLongArrayObject   = UserDefaults.standard.object(forKey: "placesLongArray")
            
            if var placesNameArray = placesNameArrayObject as? [String] {
                markName = placesNameArray[activeRow]
            }
            
            if var placesLatArray = placesLatArrayObject as? [Double] {
                latitude = placesLatArray[activeRow]
            }
            
            if var placesLongArray = placesLongArrayObject as? [Double] {
                longitude = placesLongArray[activeRow]
            }
        }
        
        let latDelta: CLLocationDegrees = 0.01
        
        let lonDelta: CLLocationDegrees = 0.01
        
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
        
        map.setRegion(region, animated: true)
        if(isFromCell){
            let annotation  = MKPointAnnotation()
            
            annotation.coordinate = location
            
            annotation.title = markName
            map.addAnnotation(annotation)
        } else {
            let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.longpress(gestureRecognizer:)))
        
            uilpgr.minimumPressDuration = 1.2
            map.addGestureRecognizer(uilpgr)
        }
        isFromCell = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func longpress(gestureRecognizer: UIGestureRecognizer){
        
        if (gestureRecognizer.state == UIGestureRecognizerState.began) {
            let touchPoint      = gestureRecognizer.location(in: self.map)
            let coordinate      = map.convert(touchPoint, toCoordinateFrom: self.map)
            let location        = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            var annotationTitle = ""
    
            CLGeocoder().reverseGeocodeLocation(location) {
                (placemarks, error) in
            
                if(error != nil) {
                    self.errorManager(debugErrorMsg: "Error \(#line): Error getting geocode info.", userErrorMsg: nil)
                }
            
                guard let placemark = placemarks?[0] else {
                    self.errorManager(debugErrorMsg: "Error \(#line): Error getting placemark from placemarks.", userErrorMsg: nil)
                    return
                }
                
                if let name = placemark.name {
                    annotationTitle = name
                }
            
                let annotation  = MKPointAnnotation()
                
                annotation.coordinate = coordinate
            
                annotation.title = annotationTitle
                self.map.addAnnotation(annotation)
            
                let place = Place(name: annotationTitle, latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let placesNameArrayObject   = UserDefaults.standard.object(forKey: "placesNameArray")
                let placesLatArrayObject    = UserDefaults.standard.object(forKey: "placesLatArray")
                let placesLongArrayObject   = UserDefaults.standard.object(forKey: "placesLongArray")
            
                if var placesNameArray = placesNameArrayObject as? [String] {
                    placesNameArray.append(place.name)
                    UserDefaults.standard.set(placesNameArray, forKey: "placesNameArray")
                
                }
                if var placesLatArray = placesLatArrayObject as? [Double] {
                    placesLatArray.append(place.latitude)
                    UserDefaults.standard.set(placesLatArray, forKey: "placesLatArray")
                
                }
                if var placesLongArray = placesLongArrayObject as? [Double] {
                    placesLongArray.append(place.longitude)
                    UserDefaults.standard.set(placesLongArray, forKey: "placesLongArray")
                }

            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
