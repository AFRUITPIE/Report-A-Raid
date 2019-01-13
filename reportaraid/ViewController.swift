//
//  ViewController.swift
//  reportaraid
//
//  Created by Hayden Hong on 1/12/19.
//  Copyright © 2019 Hayden Hong. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseFirestore

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITabBarDelegate {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var disclaimer: UIImageView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var reportButton: UITabBarItem!
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        
        // Location related stuff
        locationManager = CLLocationManager()
        locationManager.delegate = self as CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self

        // Check for Location Services
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        // Setup the Firebase database thing so it can live update
        let db = Firestore.firestore().collection("test")
        let testDatabaseRef = db.document("testID")
        
        testDatabaseRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            let shouldShowAction = document.data()!["testField"] as! Bool
            if (shouldShowAction) {
                let alert = UIAlertController(title: "Raid Reported", message: "John needs your help", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Track", comment: "Start tracking the user in need"), style: .default, handler: { _ in
                    self.generateDirections()
                }))
                
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ignore", comment: "Do nothing"), style: .cancel, handler: { _ in
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func changeLabel(_ sender: Any) {
        label.text = "Jordan is a nerd"
    }
    
    // MARK - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
    
    // Adds mock directions to the application
    func generateDirections() {
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 47.6657, longitude: -122.3126), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if (item.tag == 5) {
            let alert = UIAlertController(title: "Start recording", message: "INFO HERE", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "Start tracking the user in need"), style: .default, handler: { _ in
                self.generateDirections()
            }))
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Start tracking the user in need"), style: .default, handler: { _ in
                self.generateDirections()
            }))
            
            self.present(alert, animated: true, completion: nil)

        }

    }
}

