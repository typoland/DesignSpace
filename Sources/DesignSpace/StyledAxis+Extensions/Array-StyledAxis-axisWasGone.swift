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
    func axisWasGone(on goneIndex: Int) {
        
        // for every axis and each instance half a values array
        for axisIndex in self.indices {
            for instanceIndex in self[axisIndex].axisInstances.indices {
                do {
                    try self[axisIndex].axisInstances[instanceIndex].axisEdgesValues.halved(by: goneIndex )
                } catch {
                    print (error)
                }
            }
        }
    }
}
