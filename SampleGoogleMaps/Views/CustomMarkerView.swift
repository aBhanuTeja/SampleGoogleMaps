//
//  CustomMarkerView.swift
//  SampleGoogleMaps
//
//  Created by Bhanuteja on 04/08/22.
//

import Foundation
import UIKit

class CustomMarkerView: UIView {
    
    init(tag: Int) {
        super.init(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.tag = tag
        setupViews()
    }
    
    func setupViews() {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "location")
        imgView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imgView.clipsToBounds = true
        self.addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
