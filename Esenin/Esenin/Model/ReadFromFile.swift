//
//  ReadFromFile.swift
//  Esenin
//
//  Created by Виталий Исхаков on 18.10.2018.
//  Copyright © 2018 IScom. All rights reserved.
//

import Foundation

final class ReadFromFile {
   
    public var titlePoems = [String]()
    public var descPoems = [String?]()
    public var bodyPoems = [String]()
    public var like = [Bool]()
    
    func readFrom(title: String, description: String?, body: String) {
        if let path = Bundle.main.path(forResource: title, ofType: "txt") {
            if let text = try? String(contentsOfFile: path) {
                titlePoems = text.components(separatedBy: "\n")
                titlePoems.removeLast()
                let array = Array(repeating: false, count: titlePoems.count)
                self.like = array
            }
        }
        if let path = Bundle.main.path(forResource: description, ofType: "txt") {
            if let text = try? String(contentsOfFile: path) {
                descPoems = text.components(separatedBy: "\n")
            }
        }
        if let path = Bundle.main.path(forResource: body, ofType: "txt") {
            if let text = try? String(contentsOfFile: path) {
                bodyPoems = text.components(separatedBy: "\n\n\n")
            }
        }
    }
}
