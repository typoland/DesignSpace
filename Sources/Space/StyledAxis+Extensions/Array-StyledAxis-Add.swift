//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 19/11/2020.
//

import Foundation
import HyperSpace

public enum axesOperation {
    case add
    case insert(Int)
    case delete(Int)
}

public extension Array where Element: StyledAxisProtocol, 
                                Element: HasPositionProtocol

{
    //TODO: make function throwable
    //typealias Coord = Element.CU
    typealias StyledAxis = Element
    private mutating func reorganize() {
        self.makeDifferent(path: \.name)
        self.makeDifferent(path: \.shortName)
        
        let edges = self.oneAxisEdgesCount
        self = self.map{$0.recountInstances(for: edges)} 
    }
    
    @discardableResult
    mutating func addAxis(name: String = "new", 
                          shortName: String = "new", 
                          styleName: String = "Normal",
                          at: Double? = nil) -> Element  {
        //var newAxes:[Element] = self
        append(StyledAxis(name: name, shortName: shortName, bounds: 0...1000))
        addInstance(name: styleName, 
                    to: self.count-1, 
                    at: at)
        axisWasAdded(on: self.count-1)
        reorganize()
        return self[self.count - 1]
    }
    
    @discardableResult
    mutating func insertAxis(name: String = "new", 
                             at index: Int, 
                             instaceName: 
                             String = "Normal",
                             at: Double? = nil ) -> Element {
        insert(Element(name: "new", shortName: "new", bounds: 0...1000), at: index)
        addInstance(name: instaceName, 
                    to: index, 
                    at: at)
        axisWasAdded(on: index)
        reorganize()
        return self[index]
    } 
    
    mutating func deleteAxis(at index: Int) {
        remove(at: index)
        axisWasGone(on: index)
        reorganize()
    } 
    
    @discardableResult
    mutating func addInstance(name: String, 
                              to axisIndex: Int, 
                              at: Double? = nil) -> Element.Instance
    {
        let axis = self[axisIndex]
        return addInstance(name: name, to: axis, at: at)
    }
    
    @discardableResult
    mutating func addInstance(name: String = "Normal", 
                              to axis: Element, 
                              at: Double? = nil) -> Element.Instance
    {
        var newInstance = Element.Instance()
        let at = at ?? axis.at
        newInstance.name = name
        
        newInstance.axisEdgesValues = Array<Double>(repeating: at, 
                                                    count: oneAxisEdgesCount)
        axis.instances.append(newInstance)
        axis.instances.makeDifferent(path: \.name)
        //axis = axis // STUPID ACTION TO TRIGGER VIEW
        distribute()
        let iIndex = axis.instances.count - 1
        return axis.instances[iIndex]
    }
    
    
    mutating func insertInstance(to axisIndex:Int, 
                                 at instanceIndex: Int, 
                                 at position: Double) 
    {
        var newInstance = Element.Instance()
        newInstance.name = "\(self[axisIndex].shortName):\(String(format:"%.0f", position))"
        newInstance.axisEdgesValues = Array<Double>(repeating: position, 
                                                    count: oneAxisEdgesCount)
        self[axisIndex].instances.insert(newInstance, at: instanceIndex)
        self[axisIndex].instances.makeDifferent(path: \.name)
        self[axisIndex] = self[axisIndex] // STUPID ACTION TO TRIGGER VIEW
        distribute()
    }
    
    
}

extension PositionOnAxis
 {
    
    func at<A>(axis: A) -> Double
    where A: SpaceAxisProtocol,
          A: SpaceCoordinateProtocol {
        switch self {
        case .max: return axis.upperBound
        case .min: return axis.lowerBound
        case .number(let number): return number
        }
    }
}
