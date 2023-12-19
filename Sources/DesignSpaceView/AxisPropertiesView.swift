//
//  AxisPropertiesView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 14/12/2023.
//

import SwiftUI
import Observation

struct AxisPropertiesView<Axis>: View 
where Axis: StyledAxisProtocol, 
        Axis: Observable
{
    
    @Bindable var axis: Axis
    @Binding var styleSelection: StyleInstance?
    @Binding var styles: [StyleInstance]
    @Environment(Space<Axis>.self) private var space
    
    
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
            Slider(value: $axis.position,
                   in: axis.bounds)
            TextField("",
                      value: $axis.upperBound, 
                      format: .number)
            .frame(width: 45)
            
            Button(action: {
                do {
                    if let newInstanceID = try space.addInstance(to: axis),
                       let index = styleSelection?.positionsOnAxes.firstIndex(where: {$0.axisId == axis.id}) {
                        print ("add instance" , newInstanceID, index)
                        styleSelection?.positionsOnAxes[index].instanceId = newInstanceID
                        styles = space.styles
                    }
                } catch {
                    print (error)
                }
            },
                   label: {
                Text("Add Style to \(axis.name)")
            })
            
            Button(action: {
                space.delete(axis: axis)
                styles = space.styles
                styleSelection = styles.isEmpty ? nil : styles[0]
              
            }) {
                Image(systemName: "trash")
            }
        }
    }
}

#Preview {
    let axis = GLOBAL_SPACE.axes[0]
    @State var styles = GLOBAL_SPACE.styles
    @State var styleSelection = styles[0] as Optional
    return AxisPropertiesView(axis: axis,
                              styleSelection: $styleSelection,
                              styles: $styles)
        .environment(GLOBAL_SPACE)
}
