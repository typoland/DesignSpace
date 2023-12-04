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
//: Sequence, 
//                            IteratorProtocol, 
//                            RandomAccessCollection
where Axis: StyledAxisProtocol
{
//    public typealias Element = Axis
    public internal (set) var axes: [Axis] = []
    
//    private var counter: Int = 0
//    
//    public func next() -> Axis? {
//        if counter == 0 {
//            return nil
//        } else {
//            defer { counter -= 1 }
//            return axes[counter]
//        }
//    }
//    
    public init() {}
    
//    public init(_ axes: [Axis]) {
//        for axis in axes {
//            print ("do the job with \(axis)")
//            self.axes.addAxis()
//        }
//    }
    
    public var count: Int {
        axes.count
    }
}

//extension DesignSpace: MutableCollection {
//    public typealias Index = Int
//    public subscript(index: Index) -> Axis {
//        get {_axes[index]}
//        set (axis) {_axes[index] = axis}
//    }
//    public var startIndex: Int { _axes.startIndex }
//    public var endIndex: Int { _axes.endIndex }
//    public func index(after i: Index) -> Index {
//        _axes.index(after: i)
//    }
//}

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
                           at index: Int) -> Axis {
        axes.insertAxis(at: index)
    }
    public func deleteAxis(at index: Int) {
        axes.deleteAxis(at: index)
    }
    @discardableResult
    public  func addInstance(name: String = "Normal", 
                             to axisIndex: Array<Axis>.Index,
                             at position: Double? = nil) -> Axis.AxisStyleInstance {
        axes.addInstance(name: name, to: axisIndex, at: position)
    }
    @discardableResult
    public func addInstance(name: String = "Normal", 
                             to axis: Axis,
                             at position: Double? = nil) -> Axis.AxisStyleInstance? {
        if let index = axes.firstIndex(of: axis) {
            return axes.addInstance(name: name, to: index, at: position)
        } 
        return nil
    }
}

extension Space { 
    
    struct CornerCoordinate {
        var axis: Axis
        var onUpperBound: Bool
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
                let val = mask & index != 0 ? true : false
                result.append(CornerCoordinate(axis:axis, onUpperBound: val))
            }
            return result
        }
        
        if let axisIndex = axes.firstIndex(where: {$0.name == axis.name}) {
            
            let edge = _axes.edges[axisIndex][index] 
            let a = coordinatesOfCorner(of: edge.from).filter({$0.axis.name != axis.name})
            return "\(a.reduce(into: "", {$0 = $0 + " | \($1.axis.shortName) \($1.onUpperBound ? "▲" : "▽")"})) |"
        }
        ///take vertices coordinates
        return  ""
    }
}
    
public extension Space {
    var styles: [StyleInstance<Axis>] {
        let t = Date.now
        let r = axes.genertateInstances()
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
    
    func setPositions(by styleInstance: StyleInstance<Axis>) {
        styleInstance.coordinates.enumerated()
            .forEach({axes[$0].position = Double($1)})
    }
}
