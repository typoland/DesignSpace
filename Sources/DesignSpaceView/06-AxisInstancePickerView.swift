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
                Text("\(axis.instances[index].name)")
                    .tag(axis.instances[index] as AxisInstance)
            }
        }
    }
}
