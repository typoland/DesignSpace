//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation


extension StyledAxisProtocol 

{
    
    ///Every value in axisInstance axisValues is scaled to bounds 0...1
    
    var normalizedCalculatorValues: Self {
        let result = Self(name: name, 
                          shortName: shortName,
                          bounds: lowerBound...upperBound)
        result.distribution = self.distribution
        result.instances = self.instances.map { axisInstance in
            var scaledInstance = axisInstance
            scaledInstance.axisEdgesValues = axisInstance.axisEdgesValues
                .map {$0.normalized(in: upperBound...lowerBound)}
            return scaledInstance
        }
        return result
    }
}
