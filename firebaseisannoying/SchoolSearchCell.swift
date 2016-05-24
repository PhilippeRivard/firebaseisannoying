//
//  SchoolSearchCell.swift
//  NotSureIfThisWorks
//
//  Created by Philippe Rivard on 1/11/16.
//  Copyright © 2016 Philippe Rivard. All rights reserved.
//

import UIKit

class SchoolSearchCell: UITableViewCell {
    
    @IBOutlet weak var schoolName: UILabel!
    
    
    var university: University!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(university: University) {
        self.university = university
        schoolName.text = university.uniName
    }
    
}
