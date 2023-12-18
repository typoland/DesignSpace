//
//  Helpers.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
import DesignSpace
import Observation

@Observable
final public class DemoAxis: StyledAxisProtocol {
    public static func == (lhs: DemoAxis, rhs: DemoAxis) -> Bool {
        lhs.name == rhs.name
        && lhs.axisInstances == rhs.axisInstances
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public var name: String
    public var shortName: String
    public var lowerBound: Double
    public var upperBound: Double
    public var axisInstances: [DesignSpace.AxisInstance] = []
    public var distribution: Double? = nil
    public var position: Double = 0
    
    public var id = UUID()
    
    public init(name: String, 
         shortName: String, 
         bounds: ClosedRange<Double>) {
        self.name = name
        self.shortName = shortName
        self.lowerBound = bounds.lowerBound
        self.upperBound = bounds.upperBound
    }
    
    convenience init(name: String, 
                     shortName: String, 
                     bounds: ClosedRange<Double>, 
                     axisInstances: [DesignSpace.AxisInstance], 
                     distribution: Double? = nil) {
        self.init(name: name, shortName: shortName, bounds: bounds)
        self.axisInstances = axisInstances
        self.distribution = distribution
    }
} 


var names :[(axis: (long:String, short: String), instanceNames:[String])] =
    [
        (("weight", "wt"),["Light","Book", "Regular", "Medium", "Bold", "Black"]),
        (("width", "wd"),["Condensed","Narrow", "Extended", "Regular", "Wide"]),
        (("contrast", "co"),["Slab","Text", "Subtitle", "Title"])
    ]
//[
//    (("weight", "wt"),["Light","Book", "Regular"]),
//    (("width", "wd"),["Condensed","Narrow", "Regular"]),
//    (("contrast", "co"),["Slab","Text", "Subtitle"])
//]


func makeGlobalAxes<A>() -> Space<A>
where A: StyledAxisProtocol {
    let space = Space<A>()
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
public var GLOBAL_SPACE = makeGlobalAxes() as Space<DemoAxis>
//var GLOBAL_AXES = Axes<Axis>()

