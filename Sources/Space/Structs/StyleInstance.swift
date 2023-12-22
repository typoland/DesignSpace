//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import Foundation
import SwiftUI

public struct StyleInstance<Axis>: Identifiable, Hashable
where Axis: StyledAxisProtocol
{
    public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id 
             && lhs.symbolicCoordinates == rhs.symbolicCoordinates        
    }
    
    init(position: [StyleCoordinate], space: Space<Axis>) {
        self.symbolicCoordinates = position
        self.space = space
    }
    var space: Space<Axis>
    public var symbolicCoordinates: [StyleCoordinate]
    public var id: Int { space.axes.count == symbolicCoordinates.count 
        ? hashValue
        : 0}
    
    public func hash(into hasher: inout Hasher) {
        symbolicCoordinates.forEach { pos in
            hasher.combine(pos.id)
        }
    }
}


extension StyleInstance {
    
     mutating func addAxis()
    {
        let axis = space.addAxis(name: "New", shortName: "nw")
        symbolicCoordinates.append(StyleCoordinate(axisId: axis.id, 
                                                     instanceId: axis.instances.first!.id, 
                                                     position: axis.position))
    }
    
     mutating func delete(axis: Axis)
    {
        space.delete(axis: axis)
        removeFromSelection(axis: axis)
    }
    
    mutating func addToSelection(axis: Axis, 
                                 instance: AxisInstance, 
                                 styles: [StyleInstance<Axis>]) {
        
        //find a styles, which contains current selected axis and instance
        let styleGroup = styles.filter({style in
            var ok = true
            for thisCoordinate in symbolicCoordinates {
                for styleCoordinate in style.symbolicCoordinates {
                    if styleCoordinate.axisId == thisCoordinate.axisId {
                        ok = ok && thisCoordinate.instanceId == styleCoordinate.instanceId
                        && thisCoordinate.position == styleCoordinate.position
                    }
                }
            }
            return ok  
        })
        
        //find one which does not contain axis
        if let t = styleGroup.first(where: {style in
            style.symbolicCoordinates.filter( {$0.axisId == axis.id}).first?.instanceId == instance.id
        }),
           let coordinate = t.symbolicCoordinates.first(where: {$0.axisId == axis.id}),
        
            !symbolicCoordinates.contains(coordinate) {
                print ("adding \(coordinate)")
                let axisIndex = space.axes.firstIndex(where: {$0.id == coordinate.axisId}) 
                if let axisIndex {
                let nextAxisIndex = axisIndex + 1
                if nextAxisIndex < space.axes.count {
                    let nextAxis = space.axes[nextAxisIndex]
                    if let nextCoordinateIndex = symbolicCoordinates.firstIndex(where: {$0.axisId == nextAxis.id}) {
                        symbolicCoordinates.insert(coordinate, at: nextCoordinateIndex)
                    }
                } else {
                    symbolicCoordinates.append(coordinate)
                }
            
        }
            print (self.symbolicCoordinates.count)
        }
        
       
    }
    
    func selectedInstanceID(for axis: Axis) -> AxisInstance? {
        if let coordinateIndex = symbolicCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
            return  axis.instances.first(where: {$0.id == symbolicCoordinates[coordinateIndex].instanceId})
        }
        return nil
    }
     mutating func removeFromSelection(axis: Axis)
    {
        if let axisIndex = symbolicCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
            symbolicCoordinates.remove(at: axisIndex)
        }
    }
    
    mutating func setInstanceId(axis: Axis, id: UUID) 
    {
        
        if let axisIndex = symbolicCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
            symbolicCoordinates[axisIndex].instanceId = id
        } 
    }
    
    func axisInstanceId(of axis: Axis) -> UUID? {
        if let axisIndex = symbolicCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
           return symbolicCoordinates[axisIndex].instanceId
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
        symbolicCoordinates.reduce(into: "", {$0 = $0+"\($1.instanceId) "})
    } 
    public var coordinates: [Int] {
        symbolicCoordinates.map{Int($0.position)}
    }
}

//extension Array 
//where Element == StyleCoordinate {
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//       //lhs.id == rhs.id 
//      // && lhs.symbolicCoordinates == rhs.symbolicCoordinates
//      // && 
//        lhs.coordinates == rhs.coordinates
//    }
//}

extension StyleInstance: CustomStringConvertible {
    public var description: String {
      
        return "\"\(name)\": \(coordinates)"
    }
}

extension StyleInstance {
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.name < rhs.name && //lhs.coordinates < rhs.coordinates
        zip(lhs.coordinates,rhs.coordinates).reduce(into: true) {r, z in
            r = r && z.0 < z.1
        }
    }
}
