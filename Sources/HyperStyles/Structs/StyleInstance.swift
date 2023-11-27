//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation


public struct StyleInstance 
{
    public init(name: String, coordinates: [Double]) {
        self.name = name
        self.coordinates = coordinates.map {Int($0)}
    }
    
    public static var emptyName: String = "Normal"
    public var name: String
    public var coordinates: [Int]
}

extension StyleInstance {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.coordinates == rhs.coordinates
    }
}

extension StyleInstance {
    public var description: String {
        return "\"\(name)\": \(coordinates)"
    }
}

extension StyleInstance {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.name == rhs.name && lhs.coordinates == rhs.coordinates
    }
}
