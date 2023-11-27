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
        let result = Self(name: self.name, 
                          shortName: self.shortName,
                          bounds: self.bounds)
        result.distribution = self.distribution
        result.axisInstances = self.axisInstances.map { axisInstance in
            var scaledInstance = axisInstance
            scaledInstance.axisEdgesValues = axisInstance.axisEdgesValues
                .map {$0.normalized(in: self.bounds)}
            return scaledInstance
        }
        return result
    }
    
}
