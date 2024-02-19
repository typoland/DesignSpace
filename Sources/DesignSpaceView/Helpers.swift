//
//  Helpers.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
import Observation
import HyperSpace


@Observable
final public class DemoAxis: StyledAxisProtocol, 
                                HasPositionProtocol, 
                                Codable 
{
    
    public init(name: String, bounds: ClosedRange<Double>) {
        fatalError("not implemented, use init(name, shortname, bounds")
    }
    
    public static func == (lhs: DemoAxis, rhs: DemoAxis) -> Bool {
        lhs.name == rhs.name
        && lhs.instances == rhs.instances
    }
    
    public static func < (lhs: DemoAxis, rhs: DemoAxis) -> Bool {
        lhs.name < rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var name: String
    public var shortName: String
    public var lowerBound: Double
    public var upperBound: Double
    public var instances: [AxisInstance]
    public var distribution: Double?
    public var position: PositionOnAxis = .min
    
    public var id = UUID()
    
    public init(name: String, 
         shortName: String, 
         bounds: ClosedRange<Double>) {
        self.instances = []
        self.name = name
        self.shortName = shortName
        self.lowerBound = bounds.lowerBound
        self.upperBound = bounds.upperBound
        self.distribution = nil
        self.position = .min
    }
    
    convenience init(name: String, 
                     shortName: String, 
                     bounds: ClosedRange<Double>, 
                     axisInstances: [AxisInstance], 
                     distribution: Double? = nil) {
        self.init(name: name, shortName: shortName, bounds: bounds)
        
        self.instances = axisInstances
        self.distribution = distribution
    }
} 


var names :[(axis: (long:String, short: String), instanceNames:[String])] =
//    [
//        (("weight", "wt"),["Light","Book", "Regular", "Medium", "Bold", "Black"]),
//        (("width", "wd"),["Condensed","Narrow", "Extended", "Regular", "Wide"]),
//        (("contrast", "co"),["Slab","Text", "Subtitle", "Title"])
//    ]
[
    (("weight", "wt"),["Light","Book", "Regular"]),
    (("width", "wd"),["Condensed","Narrow", "Regular"]),
    (("contrast", "co"),["Slab","Text", "Subtitle"]),
    (("xHeight", "xh"),["Low","", "High"]),
]


public func makeDemoAxes<A>() -> DesignSpace<A>
where A: StyledAxisProtocol {
    let space = DesignSpace<A>()
    for name in names {
        
        let axis = space.addAxis(name: name.axis.long, 
                                shortName:name.axis.short, 
                                styleName: name.instanceNames[0],
                                 at: 100.0)
        var rest = name.instanceNames
        rest.removeFirst()
        for (index, instanceName) in rest.enumerated() {   
            let at =  Double(index+1) * 800.0/Double(rest.count ) + 100.0
            try! space.addInstance(name: instanceName , 
                                   to: axis, 
                                   at: at)
        }
    }
    return space
}


