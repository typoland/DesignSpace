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

struct CoordinatesPair
{
    let first: Double
    let second: Double
} 

extension Array where Element: Collection,
                      Element.Element == CoordinatesPair

{
    var coordinatesPairs: [[Double]] {
        self.map { $0
            .reduce(into: [Double]()) { axisCoordinates, intersection in
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

import HyperSpace
extension Array where Element: Collection,
                      Element.Index == Int,
                      Element.Element == Double

{

    var reduceIntersectionCoordinates: [[Double]] {
        return self.reduceIntersectionCoordinates()
    }
    
    func reduceIntersectionCoordinates(level: Int = 0) -> [[Double]] {
        
        guard self[0].count.isPowerOf2 else {
            //TODO: Check this
            return []
        }
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

extension Array where Element: StyledAxisProtocol, 
                        Element: HasPositionProtocol,
                        Element: Codable

{
    /**
     Generate all instances `[StyleInstance]` (name and coordniates) from defined axisInstances.
     */
    
    public typealias Axis = Element
    
    public func genertateStyles(from space: DesignSpace<Axis>) -> [Style<Axis>]
    {
        guard !self.isEmpty else { return [] }
        guard self.count > 1 else {
            //TODO: Check this, should return styles of one-dimensional space
            return self[0].instances.map { instance in 
                let selection = StyleCoordinate(axisId: self[0].id, 
                                                      instanceId: instance.id, 
                                                      at: instance.axisEdgesValues[0])
               return  Style(position: [selection], in: space)
            }}
            var result: [Style<Axis>]
            let normalizedAxes = self.map { $0.normalizedCalculatorValues } // .distributed
            
            result = normalizedAxes.internalInstances().map { internalAxisInstances in
            let externalCoords = (0..<internalAxisInstances.count).map { axisNr in
                
                let position = internalAxisInstances[axisNr].at.reversed(in: self[axisNr].bounds)
                
                let instanceId = internalAxisInstances[axisNr].instanceId
                
                return StyleCoordinate(axisId: self[axisNr].id, 
                                         instanceId: instanceId, 
                                         at: position)
            }
            return Style(position: externalCoords, in: space)
        }
        
        return result
    }
    
    //Internal means normalized !
    func internalInstances() -> [[StyleCoordinate]] {
        
        func styleValueIndex(edge: SpaceEdge) -> Int {
            let edgeAxisNr = edge.axisNr
            return edge.from.deleteBit(edgeAxisNr)
        }
        
        var result: [[StyleCoordinate]] = []
        let hyperspaceQuads: [[SpaceQuad]] = quads
        
        for stylesIndexes in stylesIndexList { // [[Int]]
            
            var normalizedPosition: [StyleCoordinate] = []
            var axesIntersections: [[CoordinatesPair]] = []
            for axisNr in 0..<dimensions {
                let styleIndex = stylesIndexes[axisNr]
                
                var intersections: [CoordinatesPair] = []
                if hyperspaceQuads[0].isEmpty {
                    let value = self[axisNr].instances[styleIndex].axisEdgesValues[0]
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
                        
                        let valuesA = self[axisA].instances[styleAIndex].axisEdgesValues
                        let valuesB = self[axisB].instances[styleBIndex].axisEdgesValues
                        
                        let a0 = valuesA[styleValueIndexA0]
                        let a1 = valuesA[styleValueIndexA1]
                        let b0 = valuesB[styleValueIndexB0]
                        let b1 = valuesB[styleValueIndexB1]
                        
                        let (a, b) = (a0, a1) ⊗ (b0, b1)
                        
                        intersections.append(CoordinatesPair(first:a, second:b))
                    }
                    axesIntersections.append(intersections)
                }
                let virginPosition = StyleCoordinate(axisId: self[axisNr].id, 
                                                           instanceId: self[axisNr].instances[styleIndex].id, 
                                                           at: Double.nan)
                normalizedPosition.append(virginPosition)
            }

            let coordinatesArray = axesIntersections
                .coordinatesPairs
                .reduceIntersectionCoordinates 
            
            normalizedPosition.enumerated().forEach {
                index, position in
                normalizedPosition[index].at = coordinatesArray[index].averageD
            }
    
            result.append(normalizedPosition)
        }
        return result
    }
}
