//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 16/12/2023.
//

import Foundation
/// `StyleCoordinate`  has defined IDs of `axis` and `axisInstance` and value for this coordinate
public struct StyleCoordinate: Hashable, Identifiable

{
    public var axisId: UUID
    public var instanceId: UUID?
    public var at: Double
    
    public var id: Int { hashValue }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(axisId)
        hasher.combine(instanceId)
        //don't hash position
    }
}

extension StyleCoordinate: Equatable {
    public static func == (lhs:Self, rhs:Self) -> Bool {
        lhs.axisId == rhs.axisId
        && lhs.instanceId == rhs.instanceId
    }
}

