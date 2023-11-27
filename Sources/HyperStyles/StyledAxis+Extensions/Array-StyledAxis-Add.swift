//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 19/11/2020.
//

import Foundation

public enum axesOperation {
    case add
    case insert(Int)
    case delete(Int)
}

public extension Array where Element: StyledAxisProtocol

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
    mutating func addAxis() -> Element  {
        //var newAxes:[Element] = self
        append(Element(name: "new", shortName: "new", bounds: 0...1000))
        addInstance(to: self.count-1)
        axisWasAdded(on: self.count-1)
        reorganize()
        return self[self.count - 1]
    }
    
    @discardableResult
    mutating func insertAxis(at index: Int)-> Element {
        insert(Element(name: "new", shortName: "new", bounds: 0...1000), at: index)
        addInstance(to: index)
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
    mutating func addInstance(to axisIndex: Int) -> Element.AxisStyleInstance
    {
        var newInstance = Element.AxisStyleInstance()
        let at = self[axisIndex].position
        newInstance.name = "\(self[axisIndex].shortName):\(String(format:"%.0f", Double(at)))"
        
        newInstance.axisEdgesValues = Array<Double>(repeating: at, 
                                                    count: oneAxisEdgesCount)
        self[axisIndex].axisInstances.append(newInstance)
        self[axisIndex].axisInstances.makeDifferent(path: \.name)
        self[axisIndex] = self[axisIndex] // STUPID ACTION TO TRIGGER VIEW
        distribute()
        let iIndex = self[axisIndex].axisInstances.count - 1
        return self[axisIndex].axisInstances[iIndex]
    }
    
    mutating func insertInstance(to axisIndex:Int, 
                                 at instanceIndex: Int, 
                                 at position: Double) 
    {
        var newInstance = Element.AxisStyleInstance()
        newInstance.name = "\(self[axisIndex].shortName):\(String(format:"%.0f", position))"
        newInstance.axisEdgesValues = Array<Double>(repeating: position, 
                                                    count: oneAxisEdgesCount)
        self[axisIndex].axisInstances.insert(newInstance, at: instanceIndex)
        self[axisIndex].axisInstances.makeDifferent(path: \.name)
        self[axisIndex] = self[axisIndex] // STUPID ACTION TO TRIGGER VIEW
        distribute()
    }
}

