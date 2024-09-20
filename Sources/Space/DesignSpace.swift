//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
import Observation
import HyperSpace

@Observable 
public final class DesignSpace<Axis>: SpaceProtocol, Codable
where Axis: StyledAxisProtocol,
      Axis: HasPositionProtocol
{
    public  var axes: [Axis] 
    required public init(_ axes: [Axis] = []) {
        self.axes = axes
    }
}

extension DesignSpace 
where Axis: StyledAxisProtocol
{

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
                             at position: Double? = nil) -> Axis.Instance 
    {
        axes.addInstance(name: name, 
                         to: axisIndex, 
                         at: position)
    }
    
    @discardableResult
    public func addInstance(name: String = "Normal", 
                             to axis: Axis,
                             at position: Double? = nil) throws -> Axis.Instance.ID? 
    {
        if let index = axes.firstIndex(of: axis) {
            return axes.addInstance(name: name, 
                                    to: index, 
                                    at: position).id
        } 
        throw SpaceErrors.axisDoesNotExistInSpace(axisName: axis.name)
    }
    
    var coordinates: [Double] {
        get {axes.map({$0.at})}
        set {(0..<newValue.count).forEach({axes[$0].at=newValue[$0]})}
    }
    
    func environmentStyle(styleID: Int) -> Style<Axis> {
        ( 0..<styles.count).contains(styleID) 
        ? styles[styleID] 
        : Style(in: self)
    }
}

extension DesignSpace { 
    
    struct CornerCoordinate {
        
        enum Bound: CustomStringConvertible {
            case min
            case max
            
            var description: String {
                switch self {
                case .min: return "▽"// "min"//▁"//"▽"
                case .max: return "▲"//"max"//"▉"//"▲"   
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
            return a.reduce(into: [String](), {$0.append("\($1.bound) \($1.axis.shortName)")}).joined(separator: "  ")
        }
        
        return  ""
    }
}
    
public extension DesignSpace {
    var styles: [Style<Axis>] {
        axes.genertateStyles(from: self)
    }
} 

public extension DesignSpace {
    func setPositions(by styleInstance: Style<Axis>) {
        styleInstance.coordinatesRounded.enumerated()
            .forEach({axes[$0].at = Double($1)})
    }
}


public extension DesignSpace {
    func set(instance: AxisInstance, of axis: Axis) {
        if let index = axis.instances.firstIndex(of: instance) {
            axis.instances[index] = instance
        }
    }
    
    func set(edge edgeIndex:Int, of instance: AxisInstance, of axis: Axis, to value: Double) {
        withObservationTracking({
            if let instanceIndex = axis.instances.firstIndex(of: instance) {
                axis.instances[instanceIndex]
                    .axisEdgesValues[edgeIndex] = value
            } 
        }, onChange: {print ("wow")})
        withMutation(keyPath: \.axes) {
          _axes = axes  
        }
    }
}

public extension DesignSpace {
    func name(of style: Style<Axis>) -> String {
        var r = ""
        if style.isSpaceStyle {
            for positionOnAxis in style.styleCoordinates {
                if let axis = self[positionOnAxis.axisId],
                   let instance = positionOnAxis.instanceId,
                   let instance = self[axis, instance] {
                    r += instance.name + " "
                }
            } 
        } else {
            for styleCoordinate in style.styleCoordinates {
                if let axis = axes.first(where: {$0.id == styleCoordinate.axisId}) {
                    r += "\(axis.name): \(axis.at.formatted(.number.precision(.fractionLength(0...1)))), "
                }
            }
        }
        r = "\(style.id) \(r)"
        return r.split(separator: " ").joined(separator: " ")
    }
} 


public extension DesignSpace {
    subscript (id: UUID) -> Axis? {
        return axes.first(where: {$0.id == id})
    }
    
    subscript (axis: Axis, id: UUID) -> AxisInstance? {
        return axis.instances.first(where: {$0.id == id })
    }
}
