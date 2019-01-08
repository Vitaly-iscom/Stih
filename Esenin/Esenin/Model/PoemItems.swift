//
//  PoemItems.swift
//  Esenin
//
//  Created by Виталий Исхаков on 23/11/2018.
//  Copyright © 2018 IScom. All rights reserved.
//

import Foundation

struct PoemItems {
    
    static let shared = PoemItems()
    
    var titlePoems: String?
    var desc: String?
    var body: String?
    var like: Bool?
    
    private init() {}
}
