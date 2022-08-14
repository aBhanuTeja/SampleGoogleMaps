//
//  StorableData.swift
//  SampleGoogleMaps
//
//  Created by Bhanuteja on 03/08/22.
//

import Foundation

struct AddressesStorableData: Codable {
    let id: Int
    let addressesData: [AddressesData]
}
 
struct AddressesData: Codable {
    let latitude: Double
    let longitude: Double
    let address: String
    let description: String
}

enum NavigatingFrom {
    case homeScreen
    case locationDetailsScreen
}
