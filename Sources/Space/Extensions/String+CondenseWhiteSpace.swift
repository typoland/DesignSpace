//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
public extension String {
    ///String with truncated multiple whitespace characters to one space
    ///`too    many   spaces` coverts to `too many spaces`
    var condenseWhitespace: String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
