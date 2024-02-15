// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Observation
import HyperSpace

public protocol StyledAxisProtocol: SpaceAxisProtocol, Codable
{
    
    typealias Instance = AxisInstance

    var instances: [Instance] {get set}
    var distribution: Double? {get set}
    var name: String {get set}
    var shortName: String {get set}
    var upperBound: Double {get set}
    var lowerBound: Double {get set}
    var position: Double {get set}
    
    var id: UUID {get}
    
    init(name:String, 
         shortName: String,
         bounds: ClosedRange<Double>)
}


extension StyledAxisProtocol {
    public var description: String {
        return "\(Self.self) \"\(name)\" (\(bounds))" + instances.reduce(into: "", {$0 = "\($0)\n\t\($1)"})
    }
}

