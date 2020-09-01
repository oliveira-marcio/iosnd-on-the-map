//
//  CustomButton.swift
//  OnTheMap
//
//  Created by Márcio Oliveira on 9/1/20.
//  Copyright © 2020 Márcio Oliveira. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 5
        tintColor = UIColor.white
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        backgroundColor = UIColor.link
    }
    
}
