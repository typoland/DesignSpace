//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
//
//  SpaceStyleArray + instances.swift
//  InstancesCalculator
//
//  Created by Łukasz Dziedzic on 16/06/2020.
//  Copyright © 2020 Łukasz Dziedzic. All rights reserved.
//

import Foundation
// import SpaceElements

protocol CoordinatesPairProtocol {
    var first: Double {get}
    var second: Double {get}
}

struct CoordinatesPair: CoordinatesPairProtocol 

{
    let first: Double
    let second: Double
} 

//extension Array where Element: Collection,
//                      Element.Element == (any CoordUnitProtocol, any CoordUnitProtocol) 
extension Array where Element: Collection,
                      Element.Element: CoordinatesPairProtocol

{
    //var coordinatesPairs: [[any CoordUnitProtocol]] {
    var coordinatesPairs: [[Double]] {
        self.map { $0
            .reduce(into: [0.0]) { axisCoordinates, intersection in
                axisCoordinates += [intersection.first, intersection.second]
            }
        }
    }
}

/// WTF this is?
extension Array where Element: BinaryFloatingPoint {
    /// Covert quads to lines
    ///
    ///
    var reduceIntersectionsAxis: [Element] {
        var result: [Element] = []
        
        for i in 0..<self.count / 4 {
            let i0 = self[i*4]
            let i1 = self[i*4+2]
            let i2 = self[i*4+1]
            let i3 = self[i*4+3]
            let (a, b) = (i0, i1) ⊗ (i2, i3)
            result.append(contentsOf: [a, b])
        }
        return result
    }
}

extension Array where Element: Collection,
                      Element.Index == Int,
                      Element.Element == Double

{
    
    
    
    var reduceIntersectionCoordinates: [[Double]] {
        return self.reduceIntersectionCoordinates()
    }
    
    func reduceIntersectionCoordinates(level: Int = 0) -> [[Double]] {
        //precondition(self[0].count.isPowerOf2, "Not 2^n count")
        var result: [[Double]] = []
        
        // Its a 2D It's a last step
        if self[0].count == 2 {
            var shifted: [[Double]] = []
            
            for thisIntersectionNumber in 0..<self.count {
                let nextIntersectionNumber = (thisIntersectionNumber+1) % self.count
                let a = self[thisIntersectionNumber][0]
                let b = self[nextIntersectionNumber][1]
                shifted.append([a, b])
            }
            return shifted
        } else {
            var intersections: [[Element.Element]] = []
            for thisIntersectionNumber in 0..<self.count {
                var lowerAxisIntersection: [Double] = []
                for intersection in 0..<self[thisIntersectionNumber].count / 2 {
                    let nextIntersectionNumber = (thisIntersectionNumber+1) %% self.count
                    lowerAxisIntersection.append(contentsOf: [
                        self[thisIntersectionNumber][intersection*2],
                        self[nextIntersectionNumber][intersection*2+1],
                    ])
                }
                intersections.append(lowerAxisIntersection.reduceIntersectionsAxis)
            }
            result.append(contentsOf: intersections.reduceIntersectionCoordinates(level: level+1))
        }
        return result
    }
}

extension Array where Element: StyledAxisProtocol

{
    /**
     Generate all instances `[StyleInstance]` (name and coordniates) from defined axisInstances.
     */
    public func genertateInstances() -> [StyleInstance]
    //where StyleInstance.SpaceInstanceCoordUnit == Element.CU
    {
        guard !self.isEmpty else { return [] }
        var result: [StyleInstance]
        let internalAxes = self.map { $0.normalizedCalculatorValues } // .distributed
        
        result = internalAxes.internalInstances().map { instance in
            let externalCoords = (0..<instance.coordinates.count).map { axisNr in
                instance.coordinates[axisNr].reversed(in: self[axisNr].bounds)
            }
            return StyleInstance(name: instance.name,
                                 coordinates: externalCoords)
        }
        return result
    }
    
    func internalInstances() -> [(name: String, coordinates: [Double])] {
        
        func styleValueIndex(edge: SpaceEdge) -> Int {
            let edgeAxisNr = edge.axisNr
            return edge.from.deleteBit(edgeAxisNr)
        }
        
        var result: [(name: String, coordinates: [Double])] = []
        let hyperspaceQuads: [[SpaceQuad]] = quads
        
        for stylesIndexes in stylesIndexList { // [[Int]]
            var name = ""
            var axesIntersections: [[CoordinatesPair]] = []
            for axisNr in 0..<dimensions {
                let styleIndex = stylesIndexes[axisNr]
                name += "\(self[axisNr].axisInstances[styleIndex].name) "
                
                var intersections: [CoordinatesPair] = []
                if hyperspaceQuads[0].isEmpty {
                    let value = self[axisNr].axisInstances[styleIndex].axisEdgesValues[0]
                    axesIntersections.append([CoordinatesPair(first:value, second:value)])
                } else {
                    for hyperspaceQuad in hyperspaceQuads[axisNr] {
                        let (axisA, axisB) = hyperspaceQuad.axesNumbers
                        
                        let styleValueIndexA0 = styleValueIndex(edge: hyperspaceQuad.edge(.down))
                        let styleValueIndexA1 = styleValueIndex(edge: hyperspaceQuad.edge(.up))
                        let styleValueIndexB0 = styleValueIndex(edge: hyperspaceQuad.edge(.left))
                        let styleValueIndexB1 = styleValueIndex(edge: hyperspaceQuad.edge(.right))
                        
                        let styleAIndex = stylesIndexes[axisA]
                        let styleBIndex = stylesIndexes[axisB]
                        
                        let valuesA = self[axisA].axisInstances[styleAIndex].axisEdgesValues
                        let valuesB = self[axisB].axisInstances[styleBIndex].axisEdgesValues
                        
                        let a0 = valuesA[styleValueIndexA0]
                        let a1 = valuesA[styleValueIndexA1]
                        let b0 = valuesB[styleValueIndexB0]
                        let b1 = valuesB[styleValueIndexB1]
                        
                        let (a, b) = (a0, a1) ⊗ (b0, b1)
                        
                        intersections.append(CoordinatesPair(first:a, second:b))
                    }
                    axesIntersections.append(intersections)
                }
            }
            // let data =  groups.flat//flat(array: groups)
            let coordinatesArray = axesIntersections.coordinatesPairs.reduceIntersectionCoordinates // (list: data)
            let coordinates = coordinatesArray.map { $0.averageD }
            
            if let range = name.range(of: #"\(.*\)"#,
                                      options: .regularExpression)
            {
                let a = String(name[..<range.lowerBound])
                let b = String(name[range.upperBound...])
                name = a+b
            }
            name = name.trimmingCharacters(in: .whitespacesAndNewlines).condenseWhitespace
            result.append((name: name, coordinates: coordinates))
        }
        return result
    }
}