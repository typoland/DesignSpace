//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation

public struct StyleAxisPosition: Hashable, Identifiable

{
    public var axisIndex: Int
    public var instanceIndex: Int
    
    public var position: Double
    public var id: Int { hashValue }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(axisIndex)
        hasher.combine(instanceIndex*32)
    }
}

extension StyleAxisPosition: Equatable {
     public static func == (lhs:Self, rhs:Self) -> Bool {
         lhs.axisIndex == rhs.axisIndex
        && lhs.instanceIndex == rhs.instanceIndex
    }
}

public struct StyleInstance : Identifiable, Hashable
{
    init(position: [StyleAxisPosition]) {
        self.positionsOnAxes = position
    }
    
    public var positionsOnAxes: [StyleAxisPosition]
    public var id: Int {hashValue}
    
    public func hash(into hasher: inout Hasher) {
        positionsOnAxes.forEach { pos in
            hasher.combine(pos.id)
        }
    }
}

extension StyleInstance {
    public var name : String {
        positionsOnAxes.reduce(into: "", {$0 = $0+"\($1.instanceIndex) "})
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
