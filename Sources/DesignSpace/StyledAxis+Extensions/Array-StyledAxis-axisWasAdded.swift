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
    func axisWasAdded(on newIndex: Int) {
        for axisIndex in self.indices {
            let rightValuesCount = self.oneAxisEdgesCount
            for instanceIndex in self[axisIndex].axisInstances.indices {
                do {
                    var valuesCount = self[axisIndex].axisInstances[instanceIndex].axisEdgesValues.count
                    
                    while valuesCount != rightValuesCount {
                        //print (valuesCount, rightValuesCount)
                        if valuesCount < rightValuesCount {
                            try self[axisIndex].axisInstances[instanceIndex].axisEdgesValues.doubled(by: newIndex )
                            valuesCount = valuesCount << 1
                        } else if valuesCount > rightValuesCount {
                            try self[axisIndex].axisInstances[instanceIndex].axisEdgesValues.halved(by: valuesCount.log2! )
                            valuesCount = valuesCount >> 1
                        }
                    }
                } catch {
                    print (error)
                }
            }
        }
    }
}
