//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
extension Double 
{
    ///returns` 0...1`, describing where value is between lower and upper bounds of an axis
    func normalized(in bounds: ClosedRange<Self>) -> Self {
        (self - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        //return Self(on: self.axis, at: normalized )
    }
}

extension Double
{
    ///scales **self** to bound, assuming `self = 0...1`
    func reversed(in bounds:ClosedRange<Self>) -> Self {
        self * (bounds.upperBound - bounds.lowerBound) + bounds.lowerBound
        //return Self(on: self.axis, at: reversed)
    }
}
