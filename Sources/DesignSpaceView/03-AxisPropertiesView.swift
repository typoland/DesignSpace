//
//  AxisPropertiesView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 14/12/2023.
//

import SwiftUI
import Observation
import HyperSpace

struct AxisPropertiesView<Axis>: View 
where Axis: StyledAxisProtocol, 
      Axis: HasPositionProtocol,
      Axis: Observable
{
    
    @Bindable var axis: Axis
    @Binding var styleSelection: Style<Axis>
    
    @Environment(DesignSpace<Axis>.self) private var designSpace
    
    var position: Binding<Double> {
        Binding<Double>(get: {axis.at}, 
                        set: {axis.position = PositionOnAxis(axis: axis, at: $0)})
    }
    
    
    
    var body: some View {
        HStack {
           Text("Axis:")
                .frame(width: 60)
            TextField("", text: $axis.name)
                .frame(width: 100)
            
            TextField("", text: $axis.shortName)
                .frame(width: 40)
            
            TextField("",
                      value: $axis.lowerBound, 
                      format: .number)
            .frame(width: 45)
            Slider(value: position,
                   in: axis.bounds) 
            { isSliding in
                if !isSliding {
                    styleSelection.changeInstance(in: axis,
                                                  to: nil)
                    print (styleSelection)
                }
            }
            TextField("",
                      value: position, 
                      format: .number)
            .frame(width: 45)
            
            Button(action: {
                do {
                    if let newInstanceID = try designSpace.addInstance(to: axis),
                       let index = styleSelection.styleCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
                        styleSelection.styleCoordinates[index].instanceId = newInstanceID
                    }
                } catch {
                    print (error)
                }
            },
                   label: {
                Text("Add Style to \(axis.name)")
            })
            
            Button(action: {
                styleSelection.removeInstance(from: axis)
                designSpace.delete(axis: axis)
                if designSpace.styles.isEmpty {
                    let coordinates =  designSpace.axes.map { axis in
                        StyleCoordinate(axisId: axis.id, at: axis.at)
                    }
                    styleSelection = Style(in: designSpace)
                }
            }) {
                Image(systemName: "trash")
            }
        }
    }
}

#Preview {
    let DEMO_SPACE = makeDemoAxes() as DesignSpace<DemoAxis>
    let axis = DEMO_SPACE.axes[0]
    @State var styles = DEMO_SPACE.styles
    @State var styleSelection = styles[0]
    return AxisPropertiesView(axis: axis,
                              styleSelection: $styleSelection)
        .environment(DEMO_SPACE)
}
