//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation

public struct StyleInstance : Identifiable, Hashable
{
    init(position: [AxisInstanceSelection]) {
        self.positionsOnAxes = position
    }
    
    public var positionsOnAxes: [AxisInstanceSelection]
    public var id: Int { hashValue }
    
    public func hash(into hasher: inout Hasher) {
        positionsOnAxes.forEach { pos in
            hasher.combine(pos.id)
        }
    }
}

extension Array 
where Element == AxisInstanceSelection {
    public mutating func addAxis<A>(_ axis: A)
    where A: StyledAxisProtocol 
    {
        self.append(AxisInstanceSelection(axisId: axis.id, 
                                                     instanceId: axis.axisInstances.first!.id, 
                                                     position: axis.position))
    }
    
}


extension StyleInstance {
    public var name : String {
        positionsOnAxes.reduce(into: "", {$0 = $0+"\($1.instanceId) "})
    } 
    public var coordinates: [Int] {
        positionsOnAxes.map{Int($0.position)}
    }
}

extension StyleInstance {
    public static func == (lhs: Self, rhs: Self) -> Bool {
       lhs.id == rhs.id 
       && lhs.positionsOnAxes == rhs.positionsOnAxes
       && lhs.coordinates == rhs.coordinates
    }
}

extension StyleInstance {
    public var description: String {
        return "\"\(name)\": \(coordinates)"
    }
}

extension StyleInstance {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.name < rhs.name && //lhs.coordinates < rhs.coordinates
        zip(lhs.coordinates,rhs.coordinates).reduce(into: true) {r, z in
            r = r && z.0 < z.1
        }
    }
}
