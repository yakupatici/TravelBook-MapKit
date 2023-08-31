//
//  ViewController.swift
//  JourneyBook-Map
//
//  Created by Jacob on 30.08.2023.
//

import UIKit
import MapKit
import CoreLocation // for getting users' locations
import CoreData

class ViewController: UIViewController ,MKMapViewDelegate , CLLocationManagerDelegate {
    
    
    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy  = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    // Adding Pin
    
    @objc func chooseLocation(gestureRecognizer : UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            let touchCoordinates = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            chosenLatitude = touchCoordinates.latitude
            chosenLongitude = touchCoordinates.longitude
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchCoordinates
            annotation.title = nameText.text
            annotation.subtitle = commentText.text
            self.mapView.addAnnotation(annotation)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1) // zoom part
        
        let region = MKCoordinateRegion(center: location,span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    
    @IBAction func saveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
        newPlace.setValue(nameText.text, forKey: "title")
        newPlace.setValue(commentText.text, forKey: "subtitle")
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        newPlace.setValue(UUID(), forKey: "id")
        
        
        do{
            try context.save()
            print("success")
            
            
        }catch{
            print("error")
            
        }
        
    }
    
    
}
