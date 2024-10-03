//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
public extension Array {
    /// Nuber of edges on one Axis. Imagine 4 edges of cube paralell to some axis. Or two edges of rectangle.
    var oneAxisEdgesCount: Int {
        // return 1<<(dimensions - 1)
        return SpaceEdge.oneAxisEdgesCount(for: self.dimensions)
    }
    
    /// Number of edges
    var edgesCount: Int {
        return SpaceEdge.edgesCount(for: self.dimensions)
    }
}
