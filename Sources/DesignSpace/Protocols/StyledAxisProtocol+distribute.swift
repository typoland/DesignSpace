//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation


public extension Array  where Element: StyledAxisProtocol{
    mutating func distribute() {
        (0..<self.count).forEach { self[$0].distribute() }
    }
}


public extension StyledAxisProtocol {
    func distribute() {
        if let distribution = distribution {
            instances.distribute(factor: distribution)
        }
    }
}

extension Array 
{
    public mutating func distribute(factor: Double)
    where Element == AxisInstance
    {
        guard self.count > 2 else {return}
        for axisInstanceNr in 0..<self[0].axisEdgesValues.count {
            var distributedInstanceValues: [Double ] = []
            for styleNr in 0..<self.count {
                distributedInstanceValues.append(self[styleNr]
                    .axisEdgesValues[axisInstanceNr])
            }
            distributedInstanceValues.distribute(by: factor)
            for styleNr in 0..<self.count {
                self[styleNr]
                    .axisEdgesValues[axisInstanceNr] = distributedInstanceValues[styleNr]
            }
        }
    }
}

extension Array where Element: BinaryFloatingPoint {
    
    mutating func distribute(by factor: Double) {
        guard self.count > 2, factor > 0 else { return }
        let min = self[0]
        let max = self.last!
        let step: Double = 1/Double(self.count-1)
        self =  (0..<self.count).map { nr in
            let mul = Element( pow ( Double(step) * Double(nr), factor) )
            return (max - min) * mul + min
        }
    }
}
