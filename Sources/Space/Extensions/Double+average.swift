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

public extension Array where Element: BinaryFloatingPoint {
    func closest(to value: Element) -> Element {
        var dist = Element.greatestFiniteMagnitude
        var resultIndex = 0
        for (index, element) in self.enumerated() {
            let space = abs(element - value)
            if space < dist {
                resultIndex = index
                dist = space
            }
        }
        return self[resultIndex]
    }
    
}
