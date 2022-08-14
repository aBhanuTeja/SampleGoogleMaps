//
//  LocationDetailsViewController.swift
//  SampleGoogleMaps
//
//  Created by Bhanuteja on 03/08/22.
//

import UIKit

class LocationDetailsViewController: UIViewController {

    @IBOutlet weak var displatTableView: UITableView!
    @IBOutlet weak var addLocation: UIButton!
    @IBOutlet weak var proceedBtn: UIButton!

    var savingAllAddresses = [AddressesData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        hideOrShowButtons()
        displatTableView.register(UINib(nibName: "AddAddressTableViewCell", bundle: nil), forCellReuseIdentifier: "AddAddressTableViewCell")
    }

    @IBAction func addLocationButtonTap(_ sender: Any) {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapViewController
        mapVC.saveAddressDataDelegate = self
        self.navigationController?.pushViewController(mapVC, animated: true)
    }

    @IBAction func proceedButtonTap(_ sender: Any) {
        let trackingVC = self.storyboard?.instantiateViewController(withIdentifier: "TrackingVC") as! TrackingViewController
        trackingVC.savingAllAddresses = savingAllAddresses
        trackingVC.navigatingFrom = .locationDetailsScreen
        self.navigationController?.pushViewController(trackingVC, animated: true)
    }

    func hideOrShowButtons() {
        proceedBtn.isHidden = true
        
        if savingAllAddresses.count == 10 {
            addLocation.isHidden = true
        }
        
        if savingAllAddresses.count >= 2 {
            proceedBtn.isHidden = false
        }
    }
}

extension LocationDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savingAllAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddAddressTableViewCell") as! AddAddressTableViewCell
        cell.addressLbl.text = savingAllAddresses[indexPath.row].address
        return cell
    }
}

extension LocationDetailsViewController: SaveAddressDataDelegate {
    func saveAddress(info: AddressesData) {
        savingAllAddresses.append(.init(latitude: info.latitude, longitude: info.longitude, address: info.address, description: info.description))
        hideOrShowButtons()
        DispatchQueue.main.async {
            self.displatTableView.reloadData()
        }
    }
}

struct UserDefaultsAddressData {
    static let KeyForUserDefaults = "UserDefaultsAddressData"

    static func save(_ books: [AddressesStorableData]) {
        let data = books.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: KeyForUserDefaults)
    }

    static func load() -> [AddressesStorableData] {
        guard let encodedData = UserDefaults.standard.array(forKey: KeyForUserDefaults) as? [Data] else {
            return []
        }
        return encodedData.map { try! JSONDecoder().decode(AddressesStorableData.self, from: $0) }
    }
}
