//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
extension Array
{
    /// indexes of corners of all quads (sides) of space, grouped by axis
    var quads: [[SpaceQuad]] {
        var result: [[SpaceQuad]] = []
        let cacheEdges: [[SpaceEdge]] = edges
        for axisNr in 0..<cacheEdges.count {
            var planes: [SpaceQuad] = []
            for pairNr in 0..<(cacheEdges[axisNr].count / 2) {
                let lower = cacheEdges[axisNr][pairNr*2]
                let upper = cacheEdges[axisNr][pairNr*2 + 1]
                planes.append(SpaceQuad(lowerLeft: lower.from,
                                        lowerRight: lower.to,
                                        upperLeft: upper.from,
                                        upperRigth: upper.to))
            }
            result.append(planes)
        }
        return result
    }
}

extension Array
{
    /// Returns  all space edges gruped by  in subarrays for each dimension
    var edges: [[SpaceEdge]] {
        return SpaceEdge.edges(of: self.count)
    }
    
    /// Returns Indexes of corners of `edgeNr`
    func edgeNr(_ edgeNr: Int) -> SpaceEdge {
        return SpaceEdge(edgeNr: edgeNr, of: self.count)
    }
}
