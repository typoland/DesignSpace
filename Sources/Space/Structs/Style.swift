//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
import SwiftUI
import HyperSpace

public struct Style<Axis>: Identifiable, Hashable
where Axis: StyledAxisProtocol, Axis: HasPositionProtocol
{
    public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id 
             && lhs.styleCoordinates == rhs.styleCoordinates        
    }
    
    
    
    init(position: [StyleCoordinate], in designSpace: DesignSpace<Axis>, id: Int) {
        self.styleCoordinates = position
        self.designSpace = designSpace
        self.id = id
    }
    
    init (in designSpace: DesignSpace<Axis>) {
        let coordinates =  designSpace.axes.map { axis in
            StyleCoordinate(axisId: axis.id, at: axis.at)
        }
        self.styleCoordinates = coordinates
        self.designSpace = designSpace
        self.id = -1
    }
    
    var designSpace: DesignSpace<Axis>
    
    public var styleCoordinates: [StyleCoordinate]
    
    public var id: Int 
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


extension Style {
    
    func indexOf(axis: Axis) -> Int? {
        styleCoordinates.firstIndex(where: {$0.axisId == axis.id})
    }
    
    mutating func add(axis: Axis)
    {
        if indexOf(axis: axis) == nil,
           let firstInstanceID = axis.instances.first?.id {
            styleCoordinates.append(StyleCoordinate(axisId: axis.id, 
                                                    instanceId: firstInstanceID, 
                                                    at: axis.at))
        }
    }
    
    
    /// Changes Style Instance, mainly for selection.
    /// In interface not all axes could be selected, so there is a need to remove axis from selection.
    /// And becuse Selection knows only ids of Axis and AxisInstance 
    /// - Parameters:
    ///   - in: axis to change
    ///   - to: change Axis Instance selection, remove from selection if `nil`
    ///   - styles: array of generated styles to search in. 
    mutating func changeInstance(in axis: Axis,
                                 to instance: AxisInstance?) 
    { 
        guard let instance else {
            removeInstance(from: axis)
            id = -1
            return
        }
        
        guard self.styleCoordinates.count == designSpace.axes.count else {
            return
        }
        
        //find all styles, which contains current selected axis and instance
        // Znajdź style, których koordynaty i instancje pozostałych axisów są identyczne z aktualnymi koordynatami
       
        let axisStylesGroup = designSpace.styles.filter { style in
            var ok = true
            let compareCoordinates = zip(style.styleCoordinates, styleCoordinates)
            compareCoordinates.forEach { (styleCoordinate, thisCoordinate) in
                if styleCoordinate.axisId != axis.id {
                    ok = ok && styleCoordinate.axisId == thisCoordinate.axisId
                    && styleCoordinate.instanceId == thisCoordinate.instanceId
                }
            }
            return ok  
        }
        
        guard let newStyle = axisStylesGroup.first(where: {style in
            style.styleCoordinates.first(where: {coordinate in
                coordinate.axisId == axis.id && coordinate.instanceId == instance.id
            }) != nil
        }) else { 
            return }
        
        self = newStyle
    }
    
    func selectedInstance(for axis: Axis) -> AxisInstance? {
        if let axisIndex = styleCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
            return  axis.instances.first(where: {$0.id == styleCoordinates[axisIndex].instanceId})
        }
        return nil
    }
    
     mutating func removeInstance(from axis: Axis)
    {
        if let axisIndex = indexOf(axis: axis) {
            styleCoordinates[axisIndex].instanceId = nil
        }
    }
    
//    mutating func setInstanceId(axis: Axis, id: UUID) 
//    {
//        if let axisIndex = indexOf(axis: axis) {
//            styleCoordinates[axisIndex].instanceId = id
//        } 
//    }
    
    func axisInstanceId(of axis: Axis) -> UUID? {
        if let axisIndex = indexOf(axis: axis) {
           return styleCoordinates[axisIndex].instanceId
        }
        return nil
    }
    
     mutating func addInstance(to axis: Axis) {
        if let axisIndex = designSpace.axes.firstIndex(of: axis) {
            designSpace.addInstance(to: axisIndex)
        }
    }
    
    var isSpaceStyle: Bool {
        styleCoordinates.filter({$0.instanceId != nil}).count == designSpace.axes.count
    }
}


extension Style  {
    public var name : String {
        designSpace.name(of: self)
    } 
    
    public var coordinatesRounded: [Int] {
        styleCoordinates.map{Int($0.at)}
    }
    
    public var coordinates: [Double] {
        get {styleCoordinates.map{$0.at}}
        set {
            (0..<newValue.count).forEach({styleCoordinates[$0].at = newValue[$0]})
        }
    }
}


extension Style: CustomStringConvertible {
    public var description: String {
        return "\"\(name)\": \(coordinatesRounded)"
    }
}

extension Style {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.name < rhs.name //&& //lhs.coordinates < rhs.coordinates
//        zip(lhs.coordinatesRounded, rhs.coordinatesRounded).reduce(into: true) {r, z in
//            r = r && z.0 < z.1
//        }
    }
}
