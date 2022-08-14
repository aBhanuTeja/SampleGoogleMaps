//
//  DesignTableViewCell.swift
//  InitialClass
//
//  Created by Bhanuteja on 02/08/22.
//

import UIKit

class CompletedCell: UITableViewCell {
    
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var sourceLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
