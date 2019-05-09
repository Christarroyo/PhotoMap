//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class PhotoMapViewController: UIViewController, LocationsViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate {
    
    
    var pickedImage: UIImage!
    var locationManager : CLLocationManager!
    var venuLocation: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        
        
        let mapCenter = CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667)
        let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: mapCenter, span: mapSpan)
      
        mapView.setRegion(region, animated: false)
    }
    
   
    @IBAction func cameraButton(_ sender: Any) {

   
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
       
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
            
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("PMVC - In imagePickerController")
       
        let editedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        
        pickedImage = editedImage;
  
        dismiss(animated: true) {
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        }
    }
    
    
    func addPin() {
        let annotation = MKPointAnnotation()
       
        let locationCoordinate = venuLocation
        annotation.coordinate = locationCoordinate!
        
        annotation.title = String(describing: venuLocation.latitude)
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            if let title = annotation.title! {
                print("Tapped \(title) pin")
            }
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "myAnnotationView"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
        }
        
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
       
        imageView.image = pickedImage
        
        return annotationView
    }
    func locationsPickedLocation(controller: LocationsViewController, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        print("location picked")
        venuLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude);
        addPin();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        print("PMVC - In Memory warn")
    }
    
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        
        let locationsViewController = segue.destination as! LocationsViewController
        locationsViewController.delegate = self
    }
    
    
}
