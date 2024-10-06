//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
import Observation
import HyperSpace
import HyperValue





@Observable 



public final class DesignSpace<Axis>: SpaceProtocol, Codable
where Axis: StyledAxisProtocol,
      Axis: HasPositionProtocol
{
    
    public var axes: [Axis]
//    private var instancesValuesChanged: Bool = true
    private var stylesCache : [Style<Axis>]? = nil
    
    // MARK: - Codable
    private enum CodingKeys: String, CodingKey {
        case axes = "axes"
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        axes = try container.decode([Axis].self, forKey: .axes)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(axes, forKey: .axes)
    }
    // MARK: - init
    required public init(_ axes: [Axis] = []) {
        self.axes = axes
    }
}

extension DesignSpace {
    public func clearStylesCache() {
        stylesCache = nil
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
        
        stylesCache = nil
        
        return axes.addAxis(name:name, 
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
    
    public func axisIndex(of axis: Axis) -> Int? {
        axes.firstIndex(of: axis)
    } 
    
    public func deleteAxis(at index: Int) {
        stylesCache = nil
        if (0..<axes.count).contains(index) {
            axes.deleteAxis(at: index)
        }
            
       
    }
    
    public func delete(axis: Axis) {
        stylesCache = nil
        if let index = axes.firstIndex(of: axis) {
            axes.deleteAxis(at: index)
        }
    }
    
    @discardableResult
    public func addInstance(name: String = "Normal", 
                             to axisIndex: Array<Axis>.Index,
                             at position: Double? = nil) -> Axis.Instance 
    {
        stylesCache = nil
        return axes.addInstance(name: name, 
                         to: axisIndex, 
                         at: position)
    }
    
    @discardableResult
    public func addInstance(name: String = "Normal", 
                             to axis: Axis,
                             at position: Double? = nil) throws -> Axis.Instance.ID? 
    {
        if let index = axes.firstIndex(of: axis) {
            stylesCache = nil
            return axes.addInstance(name: name, 
                                    to: index, 
                                    at: position).id
        } 
        throw SpaceErrors.axisDoesNotExistInSpace(axisName: axis.name)
    }
    
    public func removeInstance(_ instance: Axis.Instance, from axis: Axis) {
        if let axisIndex = axes.firstIndex(of: axis), 
            let instanceIndex = axes[axisIndex].instances.firstIndex(of: instance) {
            axes[axisIndex].instances.remove(at: instanceIndex)
        }
    }
    public var coordinates: [Double] {
        get {axes.map({$0.at})}
        set {(0..<newValue.count).forEach({axes[$0].at=newValue[$0]})}
    }
    
    public var namedCoordinatesString : String {
        var t = axes.reduce (into: "", {s, axis in
            s += "\(axis.name): \(axis.at.formatted(.number.rounded(increment: 1))) "
        }) 
        if !t.isEmpty { t.removeLast() }
        return String(t)
    }
    
    func environmentStyle(styleID: Int) -> Style<Axis> {
        ( 0..<styles.count).contains(styleID) 
        ? styles[styleID] 
        : Style(in: self)
    }
    
    var closestStyle: Style<Axis> {
        var smallestDiff: [(diff: Double, indexes: Set<Int>)] = Array(repeating: (Double.infinity, []) , 
                                                  count: axes.count)
        for axisIndex in 0..<axes.count {
            let axisAt = axes[axisIndex].at
            for (styleIndex, style) in styles.enumerated() {
                let diff = abs(style.coordinates[axisIndex] - axisAt)
                if smallestDiff[axisIndex].diff > diff {
                    smallestDiff[axisIndex] = (diff: diff, indexes: [styleIndex])
                } else if smallestDiff[axisIndex].diff == diff {
                    smallestDiff[axisIndex].indexes.insert(styleIndex)
                }
            }
        }
        if smallestDiff.isEmpty {
            return Style(in: self)
        }
        var set = smallestDiff[0].indexes
        
        for i in 1..<smallestDiff.count {
            set = set.intersection(smallestDiff[i].indexes)
        }
        return environmentStyle(styleID: set.first ?? -1)
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
       
        if stylesCache == nil {
            stylesCache = axes.genertateStyles(from: self)
        }
        return stylesCache ?? []
    }
} 

public extension DesignSpace {
    func setPositions(by style: Style<Axis>) {
        style.coordinatesRounded.enumerated()
            .forEach({axes[$0].at = Double($1)})
        stylesCache = nil
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
                    r += "\(axis.shortName): \(axis.at.formatted(.number.precision(.fractionLength(0...0)))), "
                }
            }
        }
        //r = "\(style.id) \(r)"
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

import Collections

extension DesignSpace {
    struct AxisName: Codable {
        let shortName: String
        let instances: [String]
    }
    
    func designSpaceURL(forResource: String, withExtension: String)-> URL? {
        if let bundleURL = Bundle.main.url(forResource: "DesignSpace_DesignSpace", withExtension: ".bundle"),
           let designSpaceBundle = Bundle(url: bundleURL),
           let dataURL = designSpaceBundle.url(forResource: forResource, withExtension: withExtension) {
            return dataURL
        }
        return nil
    }
    
    var names: OrderedDictionary<String, AxisName> {
        guard let dataURL = designSpaceURL(forResource: "AxisNames", withExtension: ".json")
        else {
            print ("💔 no data URL")
            return [:]
        }
        do {
            let data = try Data(contentsOf: dataURL)
            let names = try JSONDecoder().decode(OrderedDictionary<String, AxisName>.self, from: data)
            return names
        } catch {
            print ("🤍", error)
        }
        return [:]
    }
    
    public var defaultAxisNames: [(name:String, shortName:String)] {
        return names.map {(name:$0.key, shortName: $0.value.shortName)}
    }
    
    public func defultInstancesNamesFor(axisName: String) -> [String] {
        return names[axisName]?.instances ?? []
        
    }
}
