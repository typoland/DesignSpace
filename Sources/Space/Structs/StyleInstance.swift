//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation

public struct StyleInstance : Identifiable, Hashable
{
    init(position: [StyleCoordinate]) {
        self.symbolicCoordinates = position
    }
    
    public var symbolicCoordinates: [StyleCoordinate]
    public var id: Int { hashValue }
    
    public func hash(into hasher: inout Hasher) {
        symbolicCoordinates.forEach { pos in
            hasher.combine(pos.id)
        }
    }
}

extension Array 
where Element == StyleCoordinate {
    public mutating func addAxis<A>(_ axis: A)
    where A: StyledAxisProtocol 
    {
        self.append(StyleCoordinate(axisId: axis.id, 
                                                     instanceId: axis.instances.first!.id, 
                                                     position: axis.position))
    }
    
}


extension StyleInstance {
    public var name : String {
        symbolicCoordinates.reduce(into: "", {$0 = $0+"\($1.instanceId) "})
    } 
    public var coordinates: [Int] {
        symbolicCoordinates.map{Int($0.position)}
    }
}

extension StyleInstance {
    public static func == (lhs: Self, rhs: Self) -> Bool {
       lhs.id == rhs.id 
       && lhs.symbolicCoordinates == rhs.symbolicCoordinates
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
