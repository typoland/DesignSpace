//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation

public struct AxisInstanceSelection: Hashable, Identifiable

{
    public var axisId: UUID
    public var instanceId: UUID
    
    public var position: Double
    public var id: Int { hashValue }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(axisId)
        hasher.combine(instanceId)
    }
}

extension AxisInstanceSelection: Equatable {
     public static func == (lhs:Self, rhs:Self) -> Bool {
         lhs.axisId == rhs.axisId
        && lhs.instanceId == rhs.instanceId
    }
}

public struct StyleInstance : Identifiable, Hashable
{
    init(position: [AxisInstanceSelection]) {
        self.positionsOnAxes = position
    }
    
    public var positionsOnAxes: [AxisInstanceSelection]
    public var id: Int {hashValue}
    
    public func hash(into hasher: inout Hasher) {
        positionsOnAxes.forEach { pos in
            hasher.combine(pos.id)
        }
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
       lhs.positionsOnAxes == rhs.positionsOnAxes 
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
