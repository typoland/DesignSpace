//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
public extension Int {
    /// inserts one bit at position **at** and returns modified `Int`
    /// - parameters:
    ///   - bit: `false` will insert  `0` at `at` bit number
    ///   - at: bit where `0` ot `1` will be inserted
    /// - returns: modified `Int` number
    ///
    func insert(bit: Bool, at: Int) -> Int {
        let lowMask = at > 0 ? (1 << at) - 1 : 0 // 00@111
        let low = self & lowMask
        let up = (((self >> at) << 1) ^ (bit ? 1 : 0)) << at
        return up | low
    }
    
    /// Rotate bits left.
    /// - parameters:
    ///    - size: **Int** describing how many bits will be rotated - xx10001
    ///    - bits: **Int** describing how far will be moved. Left bits will be moved to right - xx00110
    ///  - returns: number with rotated to left `size` right bits
    
    func rotate(size: Int, bits: Int) -> Int {
        let mask = (1 << size) - 1
        let shift = (bits % size)
        let a = (self << shift) & mask
        let b = (self & mask) >> (size - shift)
        return a | b
    }
    
    /// Deletes bit. Bits on left from `bit` number will be moved one position right
    /// - parameter bit: which bit should disappear
    /// - returns: number with shifted right all bits above `bit` position
    func deleteBit(_ bit: Int) -> Int {
        let exp = Int.max // (1<<8)-1//
        let rightMask = (1 << bit) - 1
        let a = self & rightMask
        let leftMask = (exp &<< bit) & exp
        let b = (self >> 1) & leftMask
        return a | b
    }
    
    /// I hope it's fast log2 for integers. If possible returns log2 of Int, if not returns nil
    var log2: Int? {
        var i = -1
        var z = self
        while z > 0 {
            z = z >> 1
            i += 1
        }
        return 1 << i == self ? i : nil
    }
    
    /// Returns `false` if Int is not log2
    var isPowerOf2: Bool {
        return self.log2 != nil
    }
}
