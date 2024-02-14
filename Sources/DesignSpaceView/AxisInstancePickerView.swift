//
//  File.swift
//  
//
//  Created by Łukasz Dziedzic on 05/01/2024.
//

import Foundation
import SwiftUI

struct AxisInstancePicker<Axis>: View
where Axis: StyledAxisProtocol {
    
    @Bindable var axis: Axis
    @Binding var instanceSelection: AxisInstance
    //@Binding var styleSelection: StyleInstance<Axis>?
    //var styles: [StyleInstance<Axis>]
    
    var body: some View {
        Picker("", selection: $instanceSelection) {
            ForEach($axis.instances.indices, id:\.self) { index in
                Text("\(axis.instances[index].name)")
                    .tag(axis.instances[index] as AxisInstance)
            }
        }
        .frame(width: instanceSelection == nil ? 250 : 28)
    }
}
