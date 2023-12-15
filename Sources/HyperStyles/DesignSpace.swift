//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
import Observation

@Observable
public class Space<Axis>

where Axis: StyledAxisProtocol
{
    public internal (set) var axes: [Axis] = []
    
    public init() {}
    
    public var count: Int {
        axes.count
    }
}


extension Space {

    @discardableResult
    public func addAxis(name: String, 
                        shortName:String, 
                        styleName: String = "Normal", 
                        at: Double? = nil) -> Axis {
        axes.addAxis(name:name, 
                      shortName: shortName, 
                      styleName: styleName, 
                      at: at)
    }
    @discardableResult
    public func insertAxis(name: String, 
                           shortName: String,
                           style: String = "Normal", 
                           at index: Int) -> Axis 
    {
        axes.insertAxis(at: index)
    }
    
    public func deleteAxis(at index: Int) {
        axes.deleteAxis(at: index)
    }
    
    public func delete(axis: Axis) {
        if let index = axes.firstIndex(of: axis) {
            axes.deleteAxis(at: index)
        }
    }
    
    @discardableResult
    public func addInstance(name: String = "Normal", 
                             to axisIndex: Array<Axis>.Index,
                             at position: Double? = nil) -> Axis.AxisStyleInstance 
    {
        axes.addInstance(name: name, 
                         to: axisIndex, 
                         at: position)
    }
    
    @discardableResult
    public func addInstance(name: String = "Normal", 
                             to axis: Axis,
                             at position: Double? = nil) throws -> Axis.AxisStyleInstance? 
    {
        if let index = axes.firstIndex(of: axis) {
            return axes.addInstance(name: name, 
                                    to: index, 
                                    at: position)
        } 
        throw Errors.axisDoesNotExistInSpace(axisName: axis.name)
    }
}

extension Space { 
    
    struct CornerCoordinate {
        enum Bound: CustomStringConvertible {
            case min
            case max
            
            var description: String {
                switch self {
                case .min: return "▁"//"▽"
                case .max: return "▉"//"▲"   
                }
            }
        }
        
        var axis: Axis
        var bound: Bound
    }
    
    public func instanceEdgeValueName(of axis: Axis, 
                               edge index: Int, 
                               long: Bool = true) -> String {
        ///axes.edges zwracają wszystkie krawędzie przestrzeni pogrupowane po wymiarze.
        ///Ponieważ wartości axisInstance.values przypisane są do krawędzi
        ///Interesują nas tylko te wierzchołki z których wychodzą krawędzie
        ///I tylko pozostałe osie
        
        func coordinatesOfCorner(of index: Int) -> [CornerCoordinate] 
        {
            var result: [CornerCoordinate] = []
            for (axisIndex, axis) in axes.enumerated() {
                let mask = 1<<axisIndex
                let val: CornerCoordinate.Bound = mask & index != 0 ? .max : .min
                result.append(CornerCoordinate(axis:axis, bound: val))
            }
            return result
        }
        
        if let axisIndex = axes.firstIndex(where: {$0.name == axis.name}) {
            let edge = axes.edges[axisIndex][index] 
            let a = coordinatesOfCorner(of: edge.from).filter({$0.axis.name != axis.name})
            return a.reduce(into: [String](), {$0.append("\($1.axis.shortName): \($1.bound)")}).joined(separator: "  ")
        }
        
        return  ""
    }
}
    
public extension Space {
    var styles: [StyleInstance] {
        let t = Date.now
        let r = axes.genertateStyles()
        print ("Counted in \(Date.now.timeIntervalSince(t).formatted(.number.rounded(increment: 0.00001)))s.")
        return r
    }
} 

public extension Space {
    
    var positions: [Double] {
        get {axes.map{$0.position}}
        set {
            for index in 0..<newValue.count {
                axes[index].position = newValue[index]
            }
        }
    }
    
    func setPositions(by styleInstance: StyleInstance) {
        styleInstance.coordinates.enumerated()
            .forEach({axes[$0].position = Double($1)})
    }
}


public extension Space {
    func set(instance: AxisInstance, of axis: Axis) {
        if let index = axis.axisInstances.firstIndex(of: instance) {
            axis.axisInstances[index] = instance
        }
    }
    
    func set(edge edgeIndex:Int, of instance: AxisInstance, of axis: Axis, to value: Double) {
        withObservationTracking({
            if let instanceIndex = axis.axisInstances.firstIndex(of: instance) {
                axis.axisInstances[instanceIndex]
                    .axisEdgesValues[edgeIndex] = value
            } 
        }, onChange: {print ("wow")})
        withMutation(keyPath: \.axes) {
          _axes = axes  
        }
    }
}

public extension Space {
    func name(of style: StyleInstance) -> String {
        var r = ""
        for positionOnAxis in style.positionsOnAxes {
            if let axis = self[positionOnAxis.axisId],
               let instance = self[axis, positionOnAxis.instanceId] {
                r += instance.name + " "
            }
        } 
        return r.split(separator: " ").joined(separator: " ")
    }
} 


public extension Space {
    subscript (id: UUID) -> Axis? {
        return axes.first(where: {$0.id == id})
    }
    
    subscript (axis: Axis, id: UUID) -> AxisInstance? {
        return axis.axisInstances.first(where: {$0.id == id })
    }
}
