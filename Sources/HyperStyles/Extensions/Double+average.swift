//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation

extension Array where Element: BinaryFloatingPoint {
    ///Average atoms in array of ``BinaryFloatingPoint`` objects.
    
    var averageD: Element {
        self.reduce(into: 0.0, {$0 += $1}) / Element (self.count)
    }
}
