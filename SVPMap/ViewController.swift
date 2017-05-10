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
    var chapterVC: ChapterViewController?
    var locations = [[Double]]()
    var tasks = [Task]()
    var maxTries = 0
    
    var indexForTaskDictionary: [String:Int] = [:]
    
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
        
        parseXML()
        addPins()
        chapterVC = self.storyboard?.instantiateViewController(withIdentifier: "baseChapter") as? ChapterViewController
        chapterVC?.setMaxTries(max: maxTries)
        chapterVC?.setTasks(tasks: tasks)
        
        let homeLocation = CLLocation(latitude: 50.0767712, longitude: 14.434033)
        let regionRadius: CLLocationDistance = 600
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(homeLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func parseXML(){
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
        } catch {
            print("\(error)")
        }
    }
    
    func addPins(){
            for i in 1 ... locations.count{
                if locations[i-1][0] != 0 && locations[i-1][1] != 0 {
                    let myAnnotation: MKPointAnnotation = MKPointAnnotation()
                    myAnnotation.coordinate = CLLocationCoordinate2DMake(locations[i-1][0], locations[i-1][1])
                    myAnnotation.title = "Task\(i-1)"
                    indexForTaskDictionary["Task\(i-1)"] = i-1
                  //  print("Task\(i-1): \(locations[i-1][0]) ; \(locations[i-1][1]) ")
                    mapView.addAnnotation(myAnnotation)
                }
            }
    }
}

extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ locationManager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        print("UserCoords: \(mapView.userLocation.coordinate.latitude) ; \(mapView.userLocation.coordinate.longitude)")
        
        //debugLabel.text = "\(locations[0])"
        
       /* let spanX = 0.010
        let spanY = 0.010
        let setupRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        
        mapView.setRegion(setupRegion, animated: true)*/

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
        chapterVC?.setIndex(index: indexForTaskDictionary[((view.annotation?.title)!)!]!)
        chapterVC?.prepareSlides()
        chapterVC?.setupChapter()
        self.present(chapterVC!, animated: true, completion:nil)
    }
    
}


extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 200, y: self.view.frame.size.height-150, width: 400, height: 70))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 2
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 8.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}



