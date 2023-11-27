// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public protocol StyledAxisProtocol: AnyObject
                                   // SpaceAxisProtocol,
                                   // HasCoordinateProtocol 
{
    
    typealias AxisStyleInstance = AxisInstance
    var axisInstances: [AxisInstance] {get set}
    var distribution: Double? {get set}
    var name: String {get set}
    var shortName: String {get set}
    var upperBound: Double {get set}
    var lowerBound: Double {get set}
    var position: Double {get set}
    init(name:String, 
         shortName: String,
         bounds: ClosedRange<Double>)
    
    
}

public extension StyledAxisProtocol {
    var bounds: ClosedRange<Double> {
        get {lowerBound...upperBound}
        set {lowerBound = newValue.lowerBound
            upperBound = newValue.upperBound}
    }
}

extension StyledAxisProtocol {
    public var description: String {
        return "\(Self.self) \"\(name)\" (\(bounds))" + axisInstances.reduce(into: "", {$0 = "\($0)\n\t\($1)"})
    }
}

