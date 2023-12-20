//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation

extension StyledAxisProtocol {
    public func recountInstances(for egdesNr: Int) -> Self {
        let result = self
        for instanceIndex in self.instances.indices {
            //make sure axes have no identical axis instance name
            result.instances.makeDifferent(path: \.name)
            var instanceValuesCount = self.instances[instanceIndex].axisEdgesValues.count
            do {
                //Make instance values count fit to axes dimensions
                while instanceValuesCount != egdesNr {
                    if instanceValuesCount < egdesNr {
                        try result.instances[instanceIndex].axisEdgesValues.doubled(by: 0)
                        instanceValuesCount = instanceValuesCount << 1
                    } else if instanceValuesCount > egdesNr {
                        try result.instances[instanceIndex].axisEdgesValues.halved(by: 0)
                        instanceValuesCount = instanceValuesCount >> 1
                    }
                }
            } catch {
                print ("THERE IS AN ERROR?", error)
            }
        }
        return result
    }
}
