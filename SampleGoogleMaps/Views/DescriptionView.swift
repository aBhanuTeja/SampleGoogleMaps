//
//  DescriptionView.swift
//  SampleGoogleMaps
//
//  Created by Bhanuteja on 05/08/22.
//

import UIKit

class DescriptionView: UIView {
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    func setData(address: String, title: String) {
        addressLbl.text = address
        descriptionLbl.text = title
    }
}
