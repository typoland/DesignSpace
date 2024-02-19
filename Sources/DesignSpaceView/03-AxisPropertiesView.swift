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
    @Binding var styleSelection: StyleInstance<Axis>?
    
    @Environment(DesignSpace<Axis>.self) private var designSpace
    
    @State var test: Double = 0
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
            Slider(value: $test,
                   in: axis.bounds) 
            { what in
                print (what)
                styleSelection?.removeFromSelection(axis: axis)
            }
            TextField("",
                      value: $axis.upperBound, 
                      format: .number)
            .frame(width: 45)
            
            Button(action: {
                do {
                    if let newInstanceID = try designSpace.addInstance(to: axis),
                       let index = styleSelection?.styleCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
                        styleSelection?.styleCoordinates[index].instanceId = newInstanceID
                    }
                } catch {
                    print (error)
                }
            },
                   label: {
                Text("Add Style to \(axis.name)")
            })
            
            Button(action: {
                styleSelection?.delete(axis: axis)
                designSpace.delete(axis: axis)
                if designSpace.styles.isEmpty {
                    styleSelection =  nil 
                }
            }) {
                Image(systemName: "trash")
            }
            .onAppear(perform: {
                test = axis.at
            })
            
        }
    }
}

#Preview {
    let DEMO_SPACE = makeDemoAxes() as DesignSpace<DemoAxis>
    let axis = DEMO_SPACE.axes[0]
    @State var styles = DEMO_SPACE.styles
    @State var styleSelection = styles[0] as Optional
    return AxisPropertiesView(axis: axis,
                              styleSelection: $styleSelection)
        .environment(DEMO_SPACE)
}
