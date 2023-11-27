//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 03/11/2023.
//

import Foundation
///`SpaceEdge` for objects  which have two indexes of `Space` corners `from` and `to`
///
///`Space` is always descibed as a hypercube (zero, one, three, four or more dimensional) and every corner of this cube has index from 0 to n power of 2. `SpaceEdge` defines which corners of space hypercube it connects

///Implementation  of ``SpaceEdgeProtocol`` used by ``StyledAxisProtocol`` to count instances in many dimensions
struct SpaceEdge {
    ///Index of hypercube corner edge is from
    public var from: Int
    ///Index of hypercube corner edge connects to
    public var to: Int
    public init(from: Int, to: Int) {
        self.from = from
        self.to = to
    }
}

extension SpaceEdge {
    ///Index of an `axis`, which egde is prallel to
    ///- returns: number of axis which `edge` is parallel to.
    public var axisNr: Int {
        return (from ^ to).log2!
    }
}

extension SpaceEdge {
    public var description: String {
        return "\(from)⟷\(to)"
    }
}

extension SpaceEdge{
    ///Number of edges parallel to one axis. 2D has two parallel edges (up and down or left and right)
    static func oneAxisEdgesCount(for dimensionsNr: Int) -> Int {
        return 1<<(dimensionsNr - 1)
    }
}



extension SpaceEdge{
    ///Number of all hypercube edges. 1D has one eedge, 2D has 4, 3D has 12...
    static func edgesCount (for dimensionsNr: Int) -> Int {
        return dimensionsNr * oneAxisEdgesCount(for: dimensionsNr)
    }
}

extension SpaceEdge {
    ///Array of all edges of  `dimensions` hypercube, grouped by axis
    public static func edges(of dimensions: Int) -> [[Self]] {
        
        var result:[[Self]] = []
        let verticesNr = 1<<dimensions
        for axisNr in (0..<dimensions) {
            var axisResult:[Self] = []
            for vertexNr in 0 ..< verticesNr>>1 {
                let v1 = (vertexNr << 1)
                let v2 = ((vertexNr << 1) + 1)
                let b1 = v1 ⥀ (dimensions, axisNr)
                let b2 = v2 ⥀ (dimensions, axisNr)
                axisResult.append(Self(from:b1, to:b2))
            }
            result.append(axisResult)
        }
        return result
    }
    
    ///Returns Indexes of corners of `edgeNr`
    public static func edgeNr(_ edgeNr: Int, of dimensions: Int) -> Self {
        precondition((0 ... edgesCount(for: dimensions)).contains(edgeNr))
        
        let axisNr = edgeNr >> (dimensions - 1)
        let axisEdgesNumberMask = (1 << (dimensions - 1)) - 1
        let axisEdgeNr = edgeNr & axisEdgesNumberMask
        let from = axisEdgeNr.insert(bit: false, at: axisNr)
        let to   = axisEdgeNr.insert(bit: true,  at: axisNr)
        return Self(from: from, to: to)
    }
}

