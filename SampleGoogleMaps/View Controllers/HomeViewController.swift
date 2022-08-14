//
//  HomeViewController.swift
//  SampleGoogleMaps
//
//  Created by Bhanuteja on 27/07/22.
//

import UIKit
import GooglePlaces

class HomeViewController: UIViewController {
    
    @IBOutlet weak var displatTableView: UITableView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!

    var addressesData = [AddressesStorableData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpData()
    }
    
    func setUpUI() {
        displatTableView.register(UINib(nibName: "CompletedCell", bundle: nil), forCellReuseIdentifier: "CompletedCell")
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "plus.circle.fill", withConfiguration: largeConfig)
        addBtn.setImage(largeBoldDoc, for: .normal)
    }
    
    func setUpData() {
        let getUserData = UserDefaultsAddressData.load()
        if getUserData.count > 0 {
            addressesData = getUserData
            displatTableView.isHidden = false
            noDataLbl.isHidden = true
            displatTableView.reloadData()
        } else {
            displatTableView.isHidden = true
            noDataLbl.isHidden = false
            noDataLbl.text = "No Active data for now"
        }
    }
    
    @IBAction func buttonTap(_ sender: Any) {
        let manager = CLLocationManager()
        switch manager.authorizationStatus {
        case .authorizedAlways:
            pushToNextScreen()
        case .authorizedWhenInUse:
            pushToNextScreen()
        case .denied:
            showAlert()
        case .notDetermined:
            showAlert()
        case .restricted:
            showAlert()
        default:
            break
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "To proceed further you have to enable location permisson", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func pushToNextScreen() {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationDetailsVC") as! LocationDetailsViewController
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressesData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedCell") as! CompletedCell
        cell.sourceLbl.text = addressesData[indexPath.row].addressesData.first!.address
        cell.destinationLbl.text = addressesData[indexPath.row].addressesData.last!.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackingVC = self.storyboard?.instantiateViewController(withIdentifier: "TrackingVC") as! TrackingViewController
        trackingVC.savingAllAddresses = addressesData[indexPath.row].addressesData
        trackingVC.navigatingFrom = .homeScreen
        self.navigationController?.pushViewController(trackingVC, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
