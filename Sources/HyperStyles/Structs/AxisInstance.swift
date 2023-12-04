//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation


///AxisInstanceProtocol objects are nedded to create list of Instances.
///
///HyperValue framework except interpolating objects could generate list of coordinates for vertices, which could be used as a coordnates of styles for font family.
///Normally in most fontsoftware you can define values for  **light**=100 and **bold**=800 on **weight** axis and values for **condensed**=50 and **extedned**=900 on **width** axis. Coordinates of those axes will be:
///- LightCondensed on `[100, 50]`
///- LightExtended on `[100, 900]`
///- BoldCondensed on `[800, 50]`
///- BoldExtended on `[800, 900]`
///It's simple. But there is a problem when you want to make **LightExtended** bolder. First method is to redesign corner of designspace (lightest and most extended). Second way is to define separate instance values for **condensed** and **extended** edges on **weight** axis. AxisInstanceProtocol gives this possibilty.
///
///If you define **light** ``AxisInstanceProtocol`` object with values `100` for **condensed** edge and `150` for **extended** egde, InstanceGenertor will give you:
///- LightCondensed on `[~105, 50]`
///- LightExtended on `[~145, 900]`
///- BoldCondensed on `[800, 50]`
///- BoldExtended on `[800, 900]`
///
///For two dimensional designspace this is simple. But in more dimensional designspace lines dosn't like to cross each other, so finding a right coordinates is a tricky job.



public struct AxisInstance: Identifiable, Hashable {
    public init(name: String = "Normal") {
        self.name = name
    }
    public var name: String 
    public var linked: Bool = false
    public var isActive: Bool = true
    public var axisEdgesValues: [ Double ] = []
    
    public var id = UUID()
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension AxisInstance: CustomStringConvertible
{
    public var description: String {
        return "{\"\(name)\": \(axisEdgesValues)}"
    }
}


//public protocol AxisInstanceProtocol : Hashable {
//    ///Partial name of an instance. *"<regular>"* will be ignored on output
//    associatedtype CU : CoordUnitProtocol
//    var name: String {get set}
//    ///Array of as many values as egdes parallel to one axis. Each value describe position on axis for instance on one edge. Two dimensional space has two edges parallel to one axis, three dimensional designspace has four edges, four dimensional has eight edges... etc.. *2^n* where *n* is number of axes (dimensions)
//    var axisEdgesValues: [CU] {get set}
//    ///Treat values as one. If true all values are the same
//    var linked: Bool {get set}
//    var isOn: Bool {get set}
//    //static var defaultName: String {get set}
//    init ()
//}
