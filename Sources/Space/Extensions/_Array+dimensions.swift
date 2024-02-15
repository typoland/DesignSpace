//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

//import Foundation
//extension Array
//{
//    var dimensions: Int {
//        return self.count
//    }
//    
//    /// Number of corners of `0D - 1 corner`, ` 1D - 2 corners`,  space `2D - 4`, `3D - 8`, `4D - 16`...
//    //    var cornersCount: Int {
//    //        return 1<<dimensions
//    //    }
//    
//    /// Nuber of edges on one Axis. Imagine 4 edges of cube paralell to some axis. Or two edges of rectangle.
//    var oneAxisEdgesCount: Int {
//        // return 1<<(dimensions - 1)
//        return SpaceEdge.oneAxisEdgesCount(for: self.dimensions)
//    }
//    
//    /// Number of edges
//    var edgesCount: Int {
//        return SpaceEdge.edgesCount(for: self.dimensions)
//    }
//    
//    /// Number of vertices
//    public var cornersCountForThisSpace: Int {
//        1<<dimensions
//    }
//    
//    /// Range 0...<cornersCount
//    public var vertexNumbers: Range<Int> {
//        return 0..<cornersCountForThisSpace
//    }
//}
