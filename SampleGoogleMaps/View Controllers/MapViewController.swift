//
//  MapViewController.swift
//  SampleGoogleMaps
//
//  Created by Bhanuteja on 03/08/22.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol SaveAddressDataDelegate: AnyObject {
    func saveAddress(info: AddressesData)
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressTF: UITextField!

    var currentLat : Double!
    var currentLong : Double!
    var marker = GMSMarker()
    let customMarker = CustomMarkerView(tag: 1)

    let locationManager = CLLocationManager()
    weak var saveAddressDataDelegate: SaveAddressDataDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpMapView()
        setUpLocationManager()
    }
    
    @IBAction func addLocationBtnTap(_ sender: Any) {
        let notesVC = self.storyboard?.instantiateViewController(withIdentifier: "NotesVC") as! NotesViewController
        notesVC.saveAddressDataDelegate = self
        self.navigationController?.pushViewController(notesVC, animated: true)
    }
    
    func setUpMapView() {
        marker.iconView = customMarker
        marker.map = self.mapView

        mapView.isMyLocationEnabled = true
        mapView?.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.gettingCurrentLocation()
        })
    }
    
    func setUpLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
//        locationManager.startUpdatingLocation()
//        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func setLocationAnnotation(location: CLLocationCoordinate2D) {
        marker.position = CLLocationCoordinate2D(latitude: currentLat!, longitude: currentLong!)
        
        DispatchQueue.main.async {
            self.getAddressForLocation()
        }
    }
}

extension MapViewController: SaveNotesDelegate {
    func saveAddress(notes: String) {
        self.saveAddressDataDelegate?.saveAddress(info: AddressesData(latitude: self.currentLat,
                                                                        longitude: self.currentLong,
                                                                        address: self.addressTF.text!,
                                                                        description: notes))
        _ = self.navigationController?.popViewController(animated: false)
    }
}

/*
//MARK: - Google AutoComplete Delegate
extension MapViewController: GMSAutocompleteViewControllerDelegate {
    @objc func pickUpData(){
        placePickerDelegates()
    }

    func placePickerDelegates(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        //autocompleteController.accessibilityLanguage = "en-US"
        let filter = GMSAutocompleteFilter()
        //filter.type = .establishment
//        filter.country = loginCountrydicval?.alphaCode
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dismiss(animated: true, completion: nil)
        let location = place.coordinate
        currentLat = location.latitude
        currentLong = location.longitude
        DispatchQueue.main.async {
            self.initializingmapView()
            //self.getAddressForLocation()
        }
        pickupandDroplocation(place.formattedAddress!)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    }
    func pickupandDroplocation(_ address: String) {
        marker.position = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong)
        addressTF.text = address
    }
}
*/
extension MapViewController {
    func gettingCurrentLocation(){
        DispatchQueue.main.async {
            var currentLocation = CLLocation()
            currentLocation = self.locationManager.location!
            self.currentLat = currentLocation.coordinate.latitude
            self.currentLong = currentLocation.coordinate.longitude
            self.initializingmapView()
        }
    }
    
    func initializingmapView() {
        let camera = GMSCameraPosition.camera(withLatitude: currentLat!,
                                              longitude: currentLong!,
                                              zoom: 19.0)
        mapView.camera = camera
        mapView?.animate(toLocation: CLLocationCoordinate2D.init(latitude: currentLat!, longitude: currentLong!))
        setLocationAnnotation(location: CLLocationCoordinate2D(latitude: currentLat!, longitude: currentLong!))
    }

    func getAddressForLocation() {
        DispatchQueue.main.async {
            let geocoder = GMSGeocoder()
            geocoder.accessibilityLanguage = "en-US"
            let coordinate = CLLocationCoordinate2DMake(Double(self.currentLat), Double(self.currentLong))
            geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
                if let address = response?.firstResult() {
                    var straddress: String = ""
                    if let thoroughfare = address.thoroughfare {
                        if !thoroughfare.contains("Unnamed Road") {
                            straddress = thoroughfare
                        }
                    }
                    if let thoroughfare = address.lines {
                        if !thoroughfare[0].contains("CX") {
                            if address.thoroughfare != nil{
                                straddress = straddress + ", " + thoroughfare.joined(separator: ",")
                            } else {
                                straddress = straddress + "" + thoroughfare.joined(separator: ",")
                            }
                        }
                    }

                    if let sublocality = address.subLocality{
                        if address.thoroughfare != nil{
                            straddress = straddress + ", " + sublocality
                        }else{
                            straddress = straddress + "" + sublocality
                        }
                    }
                    if let locality = address.locality{
                        straddress = straddress + ", " + locality
                    }
                    if let administrativeArea = address.administrativeArea{
                        straddress = straddress + ", " + administrativeArea
                    }
                    if let postalcode = address.postalCode{
                        straddress = straddress + ", " + postalcode
                    }
                    if let country = address.country{
                        straddress = straddress + ", " + country
                    }
                    self.addressTF.text = straddress
                }}}
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let point: CGPoint = (self.mapView?.center)!
        let circleCenter: CLLocationCoordinate2D = mapView.projection.coordinate(for: point)
        currentLat = circleCenter.latitude
        currentLong = circleCenter.longitude
        DispatchQueue.main.async {
            self.getAddressForLocation()
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        if (gesture) {
            mapView.selectedMarker = nil
        }
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Ended")
    }
        
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let point: CGPoint = (self.mapView?.center)!
        let circleCenter: CLLocationCoordinate2D = mapView.projection.coordinate(for: point)
        currentLat = circleCenter.latitude
        currentLong = circleCenter.longitude
        setLocationAnnotation(location: CLLocationCoordinate2D(latitude: currentLat, longitude: currentLong))
    }
    /*
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else {
            return false
        }
        let customMarker = CustomMarkerView(tag: customMarkerView.tag)
        marker.iconView = customMarker
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        textEntryView = Bundle.main.loadNibNamed("TextEntryView", owner: nil, options: nil)?[0] as? TextEntryView
        textEntryView.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        textEntryView.layer.borderWidth = 1
        return textEntryView
    }
        
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let customMarker = CustomMarkerView(tag: customMarkerView.tag)
        marker.iconView = customMarker
    }*/
}

//MARK: CLLocationManager Delegates
extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let currentLocation = manager.location!
        currentLat = currentLocation.coordinate.latitude
        currentLong = currentLocation.coordinate.longitude
        initializingmapView()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
        currentLat = currentLocation?.coordinate.latitude
        currentLong = currentLocation?.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print(error.localizedDescription)
    }
}
