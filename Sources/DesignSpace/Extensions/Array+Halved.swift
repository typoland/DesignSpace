//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
extension Array {
    
    enum DoubledAndHalvedErrors:Error {
        case ArrayCountIsNotPowerOf2(Int)
        case axisIndexOverflow(Int, Any)
        case arrayTooShort
        case emptyArray(Any)
    }
    
    ///Doubles size of array by repreating elements
    /// - parameter by: which chunks of values sholud be repeated
    /// - returns: For `at == 0` array `ABCD` will become `AABBCCDD`, `at == 1` give `ABABCDCD`, `at == 1` give `ABCDABCD`
    
    mutating func doubled(by addedIndex: Int) throws {
        guard (self.count.isPowerOf2) else {throw DoubledAndHalvedErrors.ArrayCountIsNotPowerOf2(self.count)}
        //guard (self.count > 0) else {throw DoubledAndHalvedErrors.emptyArray(#function)}
        guard (addedIndex <= self.count) else {throw DoubledAndHalvedErrors.axisIndexOverflow(addedIndex, #function)}
        
        if addedIndex == self.count {
            //last axis is added, simply double an array
            self = self+self
        } else {
            // if an axis is inserted before first or after first axis
            // result will be the same -> AaBbCcDd == aAbBcCdD, so chunk will be size 1
            let chunkSize = addedIndex > 0 ? 1<<(addedIndex - 1) : 1
            let loops = self.count / chunkSize
            var result = Self()
            for loop in 0..<loops {
                let chunk = self[loop*chunkSize..<loop*chunkSize+chunkSize]
                result.append(contentsOf: chunk+chunk)
            }
            self = result
        }
        
    }
    /**
     Halves size of array by removing elements
     
     - parameter by: which chunks of values sholud be removed
     
     if `self` has 16 elements (4 dimensions):
     
     when by == 0 removes `[0, 2, 4, 8, 10, 12, 14, ...]`
     
     when by == 1 removes `[1, 3, 5, 7, 9, 11, 13, 15, ...]`
     
     when by == 2 removes `[2,3,  6,7,  10,11,  14,15, ...]`
     
     when by == 3 removes `[ 4,5,6,7,    12,13,14,15,  ...]`
     
     when by == 4 removes `[   8,9,10,11,12,13,14,15,  ...]`
     
     etc..
     */
    mutating func halved (by removedIndex: Int) throws {
        guard (self.count.isPowerOf2) else {throw DoubledAndHalvedErrors.ArrayCountIsNotPowerOf2(self.count)}
        guard (self.count >= 1) else {throw DoubledAndHalvedErrors.arrayTooShort}
        guard (removedIndex <= self.count) else {throw DoubledAndHalvedErrors.axisIndexOverflow(removedIndex, #function)}
        var result = Self()
        if removedIndex == 0 {
            // remove [0, 2, 4, 8, 10, 12, 14, ...]
            let loops = self.count / 2
            for loop in 0..<loops {
                result.append(self[loop*2 + 1])
            }
        } else {
            // when index == 1 remove [1, 3, 5, 7, 9, 11, 13, 15, ...]
            // when index == 2 remove [2,3,  6,7,  10,11,  14,15, ...]
            // when index == 3 remove [ 4,5,6,7,    12,13,14,15,  ...]
            // when index == 4 remove [   8,9,10,11,12,13,14,15,  ...]
            // etc..
            let chunkSize = 1<<(removedIndex)
            let loops = self.count / chunkSize
            for loop in 0..<loops {
                let chunk = Array(self[loop*chunkSize..<loop*chunkSize+chunkSize])
                result.append(contentsOf: chunk[0..<chunk.count>>1])
            }
        }
        self = result
    }
}
