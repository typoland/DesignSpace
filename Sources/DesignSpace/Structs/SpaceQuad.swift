//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation

///Implementation  of ``SpaceQuadProtocol`` used by ``StyledAxisProtocol`` to count instances in many dimensions
///
///Sruct to represent side of multidimensional space, `lowerleft`, `lowerRight`, `upperLeft` and `upperRight` are indexes of hypercube corners.
struct SpaceQuad {
    
    typealias Edge = SpaceEdge
    ///index of hypercube corner for lower left quad corner
    var lowerLeft: Int
    ///index of hypercube corner for lower right quad corner
    var lowerRight: Int
    ///index of hypercube corner for upper left quad corner
    var upperLeft: Int
    ///index of hypercube corner for upper right quad corner
    var upperRigth: Int
    init(lowerLeft: Int, lowerRight: Int, upperLeft: Int, upperRigth: Int) {
        self.lowerLeft = lowerLeft
        self.lowerRight = lowerRight
        self.upperLeft = upperLeft
        self.upperRigth = upperRigth
    }
}

enum SpaceEdgeSide {
    case down, up, left, right
}

extension SpaceQuad {
    var description: String {
        return ("<┗\(lowerLeft) ┛\(lowerRight) ┏\(upperLeft) ┓\(upperRigth)>")
    }
}

extension SpaceQuad {
    ///Array of indexes of quad corners: `[lowerLeft, lowerRight, upperLeft, upperRigth]`
    var corners: [Int] {
        return [lowerLeft, lowerRight, upperLeft, upperRigth]
    }
}

extension SpaceQuad{
    /// indexes of axes making plane parallel to quad
    var axesNumbers: (Int, Int) {
        return (edge(.down).axisNr, edge(.left).axisNr)
    }
}

extension SpaceQuad {
    ///`SpaceEdge` of given side of `quad`
    func edge(_ edgeType: SpaceEdgeSide) -> Edge {
        switch edgeType {
        case .down: return Edge(from: lowerLeft, to: lowerRight)
        case .up: return Edge(from: upperLeft, to: upperRigth)
        case .left: return Edge(from: lowerLeft, to: upperLeft)
        case .right: return Edge(from: lowerRight, to: upperRigth)
        }
    }
}


