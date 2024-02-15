//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation

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
