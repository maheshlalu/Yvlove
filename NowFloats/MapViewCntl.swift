
//
//  MapViewCntl.swift
//  StoreOnGoApp
//
//  Created by Rama kuppa on 08/05/16.
//  Copyright © 2016 CX. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewCntl: CXViewController,MKMapViewDelegate, CLLocationManagerDelegate  {
    var mapView: MKMapView = MKMapView ()
    let screenSize = UIScreen.main.bounds.size
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var currentLat:Double! = nil
    var currentLon:Double! = nil
    var myLocation:CLLocation!
    
    var lat:Double! = nil
    var lon:Double! = nil
    
    var distance:Double! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.designMapview()
        mapView.delegate = self
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
//
//        let request = MKDirectionsRequest()
//        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 40.7127, longitude: -74.0059), addressDictionary: nil))
//        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.783333, longitude: -122.416667), addressDictionary: nil))
//        request.requestsAlternateRoutes = true
//        request.transportType = .automobile
//        
//        let directions = MKDirections(request: request)
//        directions.calculate { [unowned self] response, error in
//            guard let unwrappedResponse = response else { return }
//            
//            for route in unwrappedResponse.routes {
//                self.mapView.add(route.polyline)
//                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
//            }
//        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
      
        // Do any additional setup after loading the view.
    }
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
//        renderer.strokeColor = UIColor.blue
//        return renderer
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func designMapview () {
        
        self.mapView = MKMapView.init(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        self.view.addSubview(self.mapView)
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.zoomToRegion()
        self.addShowDirectionButton()
    }
    
    func addShowDirectionButton () {
        let showDirectionBtn : UIButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 250, height: 30))
        self.mapView.addSubview(showDirectionBtn)
        showDirectionBtn.setTitle("Show Direction", for: UIControlState())
        showDirectionBtn.titleLabel?.textColor = UIColor.white
        showDirectionBtn.backgroundColor = CXAppConfig.sharedInstance.getAppTheamColor()
        showDirectionBtn.center = CGPoint(x: screenSize.width/2, y: screenSize.height-100)
        self.view.bringSubview(toFront: showDirectionBtn)
        showDirectionBtn.addTarget(self, action: #selector(MapViewCntl.showMapDirection), for: UIControlEvents.touchUpInside)
        
    }
    
    func zoomToRegion() {
        
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let region = MKCoordinateRegionMakeWithDistance(location, 5000.0, 7000.0)
        
        let annotation = Station(latitude: location.latitude, longitude: location.longitude)
        
        mapView.addAnnotation(annotation)
        
        mapView.setRegion(region, animated: true)
    }
    
    func showMapDirection(){
        
        self.showMapPointLocation()
        
    }
    func showMapPointLocation () {
        
        let lat = 17.4371
        let lon = 78.4462
    
        let googleMapUrlString = String.localizedStringWithFormat("http://maps.google.com/?daddr=%f,%f", lat, lon)
        UIApplication.shared.openURL(NSURL(string:
                googleMapUrlString)! as URL)
        var annotations:Array = [Station]()
        let annotation = Station(latitude:lat, longitude:lon)

        annotations.append(annotation)
        
        self.mapView.addAnnotation(annotation)
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        
        for annotation in annotations {
            points.append(annotation.coordinate)
        }
        
        
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        
        mapView.add(polyline)
  
        
    }
    
    func distanceBetweenTwoLocations(_ source:CLLocation,destination:CLLocation) -> Double{
        
        let distanceMeters = source.distance(from: destination)
        let distanceKM = distanceMeters / 1000
        let roundedTwoDigit = distanceKM.roundedTwoDigit
        return roundedTwoDigit
        
    }
    
    // delegate methods
    
    /*
     func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
     let polylineRenderer = MKPolylineRenderer(overlay: overlay)
     
     if overlay is MKPolyline {
     polylineRenderer.strokeColor = UIColor.redColor()
     polylineRenderer.lineWidth = 3
     
     }
     return polylineRenderer
     }*/
    //    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
    //        print("locations = \(locValue.latitude) \(locValue.longitude)")
    ////
    ////        let location = locations.last! as CLLocation
    ////
    ////        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    ////        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    ////
    ////        self.mapView.setRegion(region, animated: true)
    //    }
    
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        let location = locations.last
//        
//        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
//        
//        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
//        
//        self.mapView.setRegion(region, animated: true)
//        
//        self.locationManager.stopUpdatingLocation()
//    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
       // print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentLat = locValue.latitude
        self.currentLon = locValue.longitude
        myLocation  = CLLocation(latitude:currentLat, longitude: currentLon)
        
        let mallLocation = CLLocation(latitude: lat, longitude: lon)
        
        distance =  distanceBetweenTwoLocations(myLocation, destination: mallLocation)
        print(distance)
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        
       let distanceInKM = formatter.string(from: distance as NSNumber)
        print(distanceInKM!)
        
 
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Errors: " + error.localizedDescription)
    }
    
    
    //MAR:Heder options enable
    override  func shouldShowRightMenu() -> Bool{
        
        return false
    }
    
    override func shouldShowNotificatoinBell() ->Bool{
        
        return false
    }
    
    override  func shouldShowCart() -> Bool{
        
        return false
    }
    
    override func shouldShowLeftMenu() -> Bool{
        
        return false
    }
    override func showLogoForAboutUs() -> Bool{
        return false
    }
    override func shouldShowLeftMenuWithLogo() -> Bool{
        
        return false
    }
    override func headerTitleText() -> String{
        return "Locate \(CXAppConfig.sharedInstance.productName())"
    }
    
    override func profileDropdown() -> Bool{
        return false
    }
    
    override func profileDropdownForSignIn() -> Bool{
        return false
    }

}


extension Double{
    
    var roundedTwoDigit:Double{
        
        return 10.0
        //return Double(round(10.00))
       // return Double(round(100*self)/100)
        
    }
}

