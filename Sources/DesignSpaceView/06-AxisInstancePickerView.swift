//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 05/01/2024.
//

import Foundation
import SwiftUI
import HyperSpace

struct AxisInstancePicker<Axis>: View
where Axis: StyledAxisProtocol,
      Axis: HasPositionProtocol 
{
    
    @Bindable var axis: Axis
    @Binding var instanceSelection: AxisInstance
    //@Binding var styleSelection: StyleInstance<Axis>
    //var styles: [StyleInstance<Axis>]
    
//    var instance: Binding<AxisInstance?> {
//        Binding<AxisInstance?>(get: {styleSelection.selectedInstance(for: axis)},
//                               set: {instance in 
//            styleSelection.change(axis: axis, instance: instance)
//        }
//       )
//    }
    
    var body: some View {
        Picker("", selection: $instanceSelection) {
            ForEach($axis.instances.indices, id:\.self) { index in
                let name = axis.instances[index].name
                Text("\(name.isEmpty ? "(omit name)" : name)")
                    .fontDesign(.monospaced)
                    .tag(axis.instances[index] as AxisInstance)
            }
        }
    }
}

#Preview {
    let space = DesignSpace<DemoAxis>()
    let axis = space.addAxis(name: "Test", 
                             shortName: "ts", 
                             styleName: "Normal", at: 500)
    @State var instance = axis.instances[0]
    AxisInstancePicker(axis: axis, 
                              instanceSelection: $instance)
    .environment(space)
}
