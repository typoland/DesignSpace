//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation

public extension Array 
where Element: StyledAxisProtocol

{
    /**
     returns `StyledAxisProtocol.AxisInstance` with proper values count
     */
    func newInstance(at position: Double) -> Element.AxisStyleInstance {
        var newInstance = Element.AxisStyleInstance()
        newInstance.axisEdgesValues = Array<Double>(
            repeating: position,
            count: self.oneAxisEdgesCount
        )
        return newInstance
    }
}
