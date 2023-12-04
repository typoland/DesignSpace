//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation

public struct StyleAxisPosition<A>: Hashable
where A: StyledAxisProtocol
{
    public var axis: A
    public var style: AxisInstance
    public var position: Double
    public var id = UUID()
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(axis)
        hasher.combine(style)
    }
}

extension StyleAxisPosition: Equatable {
     public static func == (lhs:Self, rhs:Self) -> Bool {
         lhs.axis.name == rhs.axis.name
        && lhs.position == rhs.position
    }
}

public struct StyleInstance<A> : Identifiable, Hashable
where A: StyledAxisProtocol
{
    init(position: [StyleAxisPosition<A>]) {
        self.positionsOnAxes = position
    }
    
    public var positionsOnAxes: [StyleAxisPosition<A>]
    public var id = UUID()
    
    public func hash(into hasher: inout Hasher) {
        positionsOnAxes.forEach { pos in
            hasher.combine(pos.axis)
            hasher.combine(pos.style)
            hasher.combine(pos.id)
        }
    }
}

extension StyleInstance {
    public var name : String {
        positionsOnAxes.reduce(into: "", {$0 = $0+"\($1.style.name) "})
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
