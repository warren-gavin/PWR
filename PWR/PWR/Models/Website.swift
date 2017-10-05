//
//  Website.swift
//  PWR
//
//  Created by Amber Spadafora on 10/3/17.
//  Copyright © 2017 Amber Spadafora. All rights reserved.
//

import Foundation

// 2: I think this can be a struct
class Website {
    // 1: Use 'let'
    // 2: Might be better to use a URL type
    var url: String
    
    // 3: Should a website know about it's senator? Is that the responsibility of a website?
    // if not, this class is effectively just a URL, so maybe it's not needed?
    unowned let senator: Senator
    
    init(url: String, senator: Senator) {
        self.url = url
        self.senator = senator
    }
}
