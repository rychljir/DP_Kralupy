//
//  ViewController.swift
//  SVPMap
//
//  Created by Petr Mares on 09.01.17.
//  Copyright © 2017 Science in. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import AEXML

class ViewController: UIViewController {
    var locationManager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    
    var locations = [[Double]]()
    var tasks = [Task]()
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var debugLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //set accuracy of location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //show permission dialog
        locationManager.requestAlwaysAuthorization()
        
        
        //Setup our Map View
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        addPins()
        
        let homeLocation = CLLocation(latitude: 37.6213, longitude: -122.3790)
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(homeLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        //start getting location
        locationManager.startUpdatingLocation()
    }
    
    func addPins(){
        do{
            let xmlPath = Bundle.main.path(forResource: "questions2", ofType: "xml")
            let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath!))
            let opt = AEXMLOptions()
            let xmlDoc = try AEXMLDocument(xml: data!, options: opt)
            let parser = QuestionParser(xmlDocument: xmlDoc)
            tasks = parser.getTasks()
            
            var loc = [Double(50.0767542),Double(14.4201933)]
            locations.append(loc)
            loc = [Double(50.0745853),Double(14.4195711)]
            locations.append(loc)
            
            for i in 1 ... locations.count{
                let myAnnotation: MKPointAnnotation = MKPointAnnotation()
                myAnnotation.coordinate = CLLocationCoordinate2DMake(locations[i-1][0], locations[i-1][1])
                myAnnotation.title = "Task\(i)"
                mapView.addAnnotation(myAnnotation)
            }
        } catch {
            print("\(error)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Task1"{
            let pinViewCont = segue.destination as! Task1ViewController
            pinViewCont.title = "Task1"
        }
        if segue.identifier == "Task2"{
            let taskViewCont = segue.destination as! Task2ViewController
            taskViewCont.title = "Task2"
        }
    }
    
    
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ locationManager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        //debugLabel.text = "\(locations[0])"
        myLocations.append(locations[0])
        
        let spanX = 0.010
        let spanY = 0.010
        let setupRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(setupRegion, animated: true)
        
        if (myLocations.count > 1){
            let sourceIndex = myLocations.count - 1
            let destinationIndex = myLocations.count - 2
            
            let c1 = myLocations[sourceIndex].coordinate
            let c2 = myLocations[destinationIndex].coordinate
            var a = [c1, c2]
            let polyline = MKPolyline(coordinates: &a, count: a.count)
            mapView.add(polyline)
        }
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 4
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view:MKAnnotationView){
        print("Annotation: \(view.annotation?.title!)")
        if view.annotation?.title! == "Task1"{
            performSegue(withIdentifier: "Task1", sender: nil)        }
        if view.annotation?.title! == "Task2"{
            performSegue(withIdentifier: "Task2", sender: nil)         }
    }
    
}



