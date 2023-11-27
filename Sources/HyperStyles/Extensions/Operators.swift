//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
infix operator ⥀
/**
 Rotate bits left
 - parameter lhs: how many left bits will be affected
 - parameter rhs: number of positions to rotate
 - returns: Int with `lhs` right bits rotates about `rhs` postitions
 */

func ⥀ (lhs: Int, rhs: (size: Int, bits: Int)) -> Int {
    return lhs.rotate(size: rhs.size, bits: rhs.bits)
}

infix operator %%
/// c-like mod, no negative result, number `n>0`
public func %% (_ a: Int, _ n: Int) -> Int {
    precondition(n > 0, "modulus must be positive")
    let r = a % n
    return r >= 0 ? r : r + n
}

/// Normalized intersection point
infix operator ⊗


/// intersection point, where lines are (x₁,0) to (x₂,1) and (0,y₁) to (1,y₂)
///
/// !["Normalized Intersection"](NormalizedIntersection.png)
/// Also known as ``⊗(lhs:rhs:)``
func normalizedIntersection<F: FloatingPoint>(x1: F,
                                              x2: F,
                                              y1: F,
                                              y2: F)
-> (F, F)
{
    let mul = (x1 - x2) * (y1 - y2) - 1
    let x = (x1 * y1 - x1 - x2 * y1) / mul
    let y = (x1 * y1 - y1 - x1 * y2) / mul
    return (x: x, y: y)
}

/// ``normalizedIntersection(x1:x2:y1:y2:)`` intersection point, where lines are (x1,0) to (x2,1) and (0,y1) to (1,y2)
///
/// !["Normalized Intersection"](NormalizedIntersection.png)
/// Also known as ``normalizedIntersection(x1:x2:y1:y2:)``
func ⊗ <F: FloatingPoint>(lhs: (F, F), rhs: (F, F)) -> (F, F) {
    return normalizedIntersection(x1: lhs.0, x2: lhs.1, y1: rhs.0, y2: rhs.1)
}

func symbolicCoordinates(of cornerIndex: Int, in arrayCount: Int) -> [Bool] {
    var result: [Bool] = []
    let mask = (1<<arrayCount) - 1
    for dimension in 0..<(arrayCount-1) {
        let n = 1 << dimension
        result.append(cornerIndex & n == n)
    }
    return result
}
