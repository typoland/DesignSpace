//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
import SwiftUI
import HyperSpace

public struct StyleInstance<Axis>: Identifiable, Hashable
where Axis: StyledAxisProtocol, Axis: HasPositionProtocol
{
    public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id 
             && lhs.styleCoordinates == rhs.styleCoordinates        
    }
    
    init(position: [StyleCoordinate], space: DesignSpace<Axis>) {
        self.styleCoordinates = position
        self.space = space
    }
    var space: DesignSpace<Axis>
    public var styleCoordinates: [StyleCoordinate]
    
    public var id: Int { space.axes.count == styleCoordinates.count 
        ? hashValue
        : 0}
    
    public func hash(into hasher: inout Hasher) {
        styleCoordinates.forEach { pos in
            hasher.combine(pos.id)
        }
    }
}


extension StyleInstance {
    func indexOf(axis: Axis) -> Int? {
        styleCoordinates.firstIndex(where: {$0.axisId == axis.id})
    }
    mutating func add(axis: Axis)
    {
        if indexOf(axis: axis) == nil,
           let firstInstanceID = axis.instances.first?.id {
            styleCoordinates.append(StyleCoordinate(axisId: axis.id, 
                                                    instanceId: firstInstanceID, 
                                                    position: axis.at))
        }
    }
    
     mutating func delete(axis: Axis)
    {
        if let index = indexOf(axis: axis) {
            styleCoordinates.remove(at: index)
        }
    }
    
    /// Changes Style Instance, mainly for selection.
    /// In interface not all axes could be selected, so there is a need to remove axis from selection.
    /// And becuse Selection knows only ids of Axis and AxisInstance 
    /// - Parameters:
    ///   - axis: axis to change
    ///   - instance: change Axis Instance selection, remove from selection if `nil`
    ///   - styles: array of generated styles to search in. 
    mutating func change(axis: Axis, 
                         instance: AxisInstance?) { 
                       //  styles: [StyleInstance<Axis>]) {
        //print ("CHANGE", axis.name, instance?.name, space.styles.count)
        
        guard let instance else {
            removeFromSelection(axis: axis)
            //print ("instance is nil"); 
            return
        }
        
        guard self.styleCoordinates.count == space.axes.count else {
            //print ("differntt axes count"); 
            return
        }
        
        //find all styles, which contains current selected axis and instance
        // Znajdź style, których koordynaty i instancje pozostałych axisów są identyczne z aktualnymi koordynatami
       
        let axisStylesGroup = space.styles.filter { style in
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
            //print ("no new style"); 
            return }
        
        self = newStyle
        
       
    }
    
    func selectedInstance(for axis: Axis) -> AxisInstance? {
        if let coordinateIndex = styleCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
            return  axis.instances.first(where: {$0.id == styleCoordinates[coordinateIndex].instanceId})
        }
        return nil
    }
    
     mutating func removeFromSelection(axis: Axis)
    {
        if let axisIndex = styleCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
            styleCoordinates.remove(at: axisIndex)
        }
    }
    
    mutating func setInstanceId(axis: Axis, id: UUID) 
    {
        if let axisIndex = styleCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
            styleCoordinates[axisIndex].instanceId = id
        } 
    }
    
    func axisInstanceId(of axis: Axis) -> UUID? {
        if let axisIndex = styleCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
           return styleCoordinates[axisIndex].instanceId
        }
        return nil
    }
    
     mutating func addInstance(to axis: Axis) {
        if let axisIndex = space.axes.firstIndex(of: axis) {
            space.addInstance(to: axisIndex)
        }
    }
}


extension StyleInstance  {
    public var name : String {
        styleCoordinates.reduce(into: "", {$0 = $0+"\($1.instanceId) "})
    } 
    public var coordinatesRounded: [Int] {
        styleCoordinates.map{Int($0.position)}
    }
}


extension StyleInstance: CustomStringConvertible {
    public var description: String {
        return "\"\(name)\": \(coordinatesRounded)"
    }
}

extension StyleInstance {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.name < rhs.name && //lhs.coordinates < rhs.coordinates
        zip(lhs.coordinatesRounded,rhs.coordinatesRounded).reduce(into: true) {r, z in
            r = r && z.0 < z.1
        }
    }
}
