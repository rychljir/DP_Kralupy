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
    
    var locations = [[Double]]()
    var tasks = [Task]()
    var maxTries = 0
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var debugLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //set accuracy of location
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //show permission dialog
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse{
            //start getting location
            locationManager.startUpdatingLocation()
        }else{
            locationManager.requestWhenInUseAuthorization()
        }
        
        
        
        //Setup our Map View
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        addPins()
        
        let homeLocation = CLLocation(latitude: 50.0767712, longitude: 14.4371933)
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(homeLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func addPins(){
        do{
            let xmlPath = Bundle.main.path(forResource: "questions2", ofType: "xml")
            let data = try? Data(contentsOf: URL(fileURLWithPath: xmlPath!))
            let opt = AEXMLOptions()
            let xmlDoc = try AEXMLDocument(xml: data!, options: opt)
            let parser = QuestionParser(xmlDocument: xmlDoc)
            tasks = parser.getTasks()
            maxTries = parser.getTries()
            for task in tasks {
                if task.location.count>0{
                    locations.append(task.location)
                }else{
                    locations.append([0,0])
                }
            }
            
            for i in 1 ... locations.count{
                if locations[i-1][0] != 0 && locations[i-1][1] != 0 {
                    let myAnnotation: MKPointAnnotation = MKPointAnnotation()
                    myAnnotation.coordinate = CLLocationCoordinate2DMake(locations[i-1][0], locations[i-1][1])
                    myAnnotation.title = "Task\(i-1)"
                  //  print("Task\(i-1): \(locations[i-1][0]) ; \(locations[i-1][1]) ")
                    mapView.addAnnotation(myAnnotation)
                }
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
        
        let spanX = 0.010
        let spanY = 0.010
        let setupRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        print("UserCoords: \(mapView.userLocation.coordinate.latitude) ; \(mapView.userLocation.coordinate.longitude)")
      //  mapView.setRegion(setupRegion, animated: true)

    }
    
   func locationManager(_ locationManager:CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse || status == CLAuthorizationStatus.authorizedAlways{
            locationManager.startUpdatingLocation()
        }
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view:MKAnnotationView){
        print("Annotation: \(String(describing: view.annotation?.title!))")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "baseChapter") as! ChapterViewController
        self.present(vc, animated: true, completion:nil)
    }
    
}



