//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation


public struct Axes<Axis>: Sequence, 
                            IteratorProtocol, 
                            RandomAccessCollection
where Axis: StyledAxisProtocol     {
    
    public typealias Element = Axis
    private var _axes: [Axis] = []
    
    private var counter: Int = 0
    
    public mutating func next() -> Axis? {
        if counter == 0 {
            return nil
        } else {
            defer { counter -= 1 }
            return _axes[counter]
        }
    }
    
    public init() {}
    
    public init(_ axes: [Axis]) {
        for axis in axes {
            print ("do the job with \(axis)")
            _axes.addAxis()
        }
    }
    
    public var count: Int {
        _axes.count
    }
}

extension Axes: MutableCollection {
    public typealias Index = Int
    public subscript(index: Index) -> Axis {
        get {_axes[index]}
        set (axis) {_axes[index] = axis}
    }
    public var startIndex: Int { _axes.startIndex }
    public var endIndex: Int { _axes.endIndex }
    public func index(after i: Index) -> Index {
        _axes.index(after: i)
    }
}

extension Axes {
    @discardableResult
    public mutating func addAxis() -> Axis {
        _axes.addAxis()
    }
    @discardableResult
    public mutating func insertAxis(at index: Int) {
        _axes.insertAxis(at: index)
    }
    
    public mutating func deleteAxis(at index: Int) {
        _axes.deleteAxis(at: index)
    }
    @discardableResult
    public mutating func addInstance(to axisIndex: Int) -> Axis.AxisStyleInstance {
        _axes.addInstance(to: axisIndex)
    }
}

public extension Axes { 
    
    struct Coordinate {
        var axis: Axis
        var minMax: Bool
    }
    func instanceEdgeValueName(of axis: Element, edge index: Int, long: Bool = true) -> String {
        ///axes.edges zwracają wszystkie krawędzie przestrzeni pogrupowane po wymiarze.
        ///Ponieważ wartości axisInstance.values przypisane są do krawędzi
        ///Interesują nas tylko te wierzchołki z których wychodzą krawędzie
        ///I tylko pozostałe osie
        
        func coordinatesOfCorner(of index: Int) -> [Coordinate] 
        {
            var result: [Coordinate] = []
            for (axisIndex, axis) in self.enumerated() {
                let mask = 1<<axisIndex
                let val = mask & index != 0 ? true : false
                result.append(Coordinate(axis:axis, minMax: val))
            }
            return result
        }
        
        if let axisIndex = firstIndex(where: {$0.name == axis.name}) {
            
            let edge = _axes.edges[axisIndex][index] 
            let a = coordinatesOfCorner(of: edge.from).filter({$0.axis.name != axis.name})
            return "\(a.reduce(into: "", {$0 = $0 + " | \($1.axis.shortName) \($1.minMax ? "▲" : "▽")"})) |"
        }
        ///take vertices coordinates
        return  "Not yet"
//        (self.coordinatesOfCorner(index: edge.from) as [Coord])
//        ///remeve axis paralle to remained
//            .filter({$0.axis != self[axisIndex]})
//        /// convert to string
//            .map ({"\(long ? $0.axis.name : $0.axis.shortName) \($0.position)"})
//        /// join separated by "  |  "
//            .joined(separator:"  |  ")
//        
//        return "no axis \(long ? "\"\(axis.name)\"" : "\"\(axis.shortName)\"")"
        
    }
}
    

public extension Axes {
    func shortNameForEdge(_ egdeIndex: Int,
                         of styleInstanceIndex: Int, 
                         on axisIndex: Int ) -> String {
       return ("no") 
    }
}

public extension Axes {
    var styles: [StyleInstance] {
        _axes.genertateInstances()
    }
} 

public extension Axes {
    var positions: [Double] {
        get {_axes.map{$0.position}}
        set {
            for index in 0..<newValue.count {
                _axes[index].position = newValue[index]
            }
        }
    }
}
