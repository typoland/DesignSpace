//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
public extension Array {
    /**
     Corrects Element `String` property on `path:` If there are equal strings,  it appends numbers except first one.
     
     var a = [Some(x:"a"), Some(x:"a"), Some(x:"a")]
     a.makeDifferent(path: \.x)
     >>> [Some(x:"a"), Some(x:"a1"), Some(x:"a2")]
     */
    mutating func makeDifferent<T: Hashable & StringProtocol>(path: WritableKeyPath<Element, T>){
        var stringIndexes:[T:[Int]] = [:]
        
        for elementIndex in 0..<self.count {
            if stringIndexes.keys.contains(self[elementIndex][keyPath: path]) {
                stringIndexes[self[elementIndex][keyPath: path]]?.append(elementIndex)
            } else {
                stringIndexes[self[elementIndex][keyPath: path]] = [elementIndex]
            }
        }
        if stringIndexes.count != self.count {
            for error in stringIndexes.filter({$1.count > 1}) {
                for (count, elementIndex) in error.value.enumerated() {
                    if count != 0 {
                        var next = 0
                        var newString: T = "\(self[elementIndex][keyPath: path])\(count)"
                        while self.map({$0[keyPath: path]}).contains(newString) {
                            newString = "\(self[elementIndex][keyPath: path])\(count+next)"
                            next += 1
                        }
                        self[elementIndex][keyPath: path] = newString
                    }
                }
            }
        }
    }
}
