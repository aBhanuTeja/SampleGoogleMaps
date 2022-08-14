//
//  TrackingViewController.swift
//  SampleGoogleMaps
//
//  Created by Bhanuteja on 04/08/22.
//

import UIKit
import GoogleMaps

class TrackingViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var savingAllAddresses = [AddressesData]()
    var descriptionView: DescriptionView!
    var navigatingFrom: NavigatingFrom?

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setUpMarkers()
    }
    
    func setUpMarkers() {
        if navigatingFrom == .homeScreen {
            saveBtn.isHidden = true
        }
        
        var bounds = GMSCoordinateBounds()
        for i in 0..<savingAllAddresses.count  {
            let marker = GMSMarker()
            let customMarker = CustomMarkerView(tag: i)
            marker.iconView = customMarker
            marker.position = CLLocationCoordinate2D(latitude: savingAllAddresses[i].latitude, longitude: savingAllAddresses[i].longitude)
            marker.map = self.mapView
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50)
        mapView.animate(with: update)
    }

    @IBAction func saveDetailsBtnTap(_ sender: Any) {
        var id = 1
        var addressFullData = [AddressesStorableData]()
        addressFullData = UserDefaultsAddressData.load()

        if addressFullData.count > 0 {
            id = addressFullData.last!.id + 1
        }

        addressFullData.append(AddressesStorableData(id: id, addressesData: savingAllAddresses))
        UserDefaultsAddressData.save(addressFullData)
    }
    
//    @objc func restaurantTapped(tag: Int) {
//        print(savingAllAddresses[tag])
//    }
}

extension TrackingViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else {
            return false
        }
        let customMarker = CustomMarkerView(tag: customMarkerView.tag)
        marker.iconView = customMarker
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        let data = savingAllAddresses[customMarkerView.tag]
        descriptionView = Bundle.main.loadNibNamed("DescriptionView", owner: nil, options: nil)?[0] as? DescriptionView
        descriptionView.setData(address: data.address, title: data.description)
        descriptionView.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        descriptionView.layer.borderWidth = 1
//        self.view.addSubview(descriptionView)
        return descriptionView
    }
    
//    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
//        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
//        let tag = customMarkerView.tag
//        restaurantTapped(tag: tag)
//    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let customMarker = CustomMarkerView(tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
}
/*
extension TrackingViewController {
    func methodType(url: String, params: [String: Any]? = nil,
                           completionHandler:((_ response: Any?, _ status: Bool) -> Void)?) -> Void {
        print("url =====> \(url)")
        let endPointURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        var urlRequest = URLRequest.init(url: URL.init(string: endPointURL!)!)
        if params != nil{
            let postData = try? JSONSerialization.data(withJSONObject: params!, options: .init(rawValue: 0))
            urlRequest.httpBody = postData
            let jsonInputData = try? JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
            let requestBody = String(data:jsonInputData!, encoding:String.Encoding.utf8)
            print("requestBody ====>\(requestBody!)")
        }
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.timeoutInterval = 30
        self.sessionWithRequest(urlRequest: urlRequest, completionHandler: completionHandler)
    }
    
    //MARK:- SessionRequest
    func sessionWithRequest(urlRequest: URLRequest,
                                  completionHandler:((_ response: Any?, _ status: Bool) -> Void)?){
        let sessionConguration = URLSessionConfiguration.default
        let defaultSession = URLSession.init(configuration: sessionConguration)
        
        let dataTask = defaultSession.dataTask(with: urlRequest) { (data, response, error) in
            let responseFromServer = response as? HTTPURLResponse
            let code = responseFromServer?.statusCode
            if error == nil && data != nil{
                let jsonResponse = try? JSONSerialization.jsonObject(with: data!, options: .init(rawValue: 0))
                print(jsonResponse!)
                if code == 200 {
                    if let jSONData = data{
                        completionHandler!(jSONData, true)
                    }
                    else{
                        print("something went wrong")
                    }
                }else {
                    print(jsonResponse as Any)
                }
            }else{
                print(error.debugDescription)
            }
        }
        dataTask.resume()
    }
}
*/

