//
//  StyledAxisView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import SwiftUI
import DesignSpace

struct StyledAxisView<Axis>: View 
where Axis: StyledAxisProtocol

{
    @Bindable var axis: Axis
    @Binding var styleSelection: StyleInstance?
    @Binding var styles: [StyleInstance]
    

    var body: some View {
        VStack {
            GroupBox {
                AxisPropertiesView(axis: axis, 
                                   styleSelection: $styleSelection,
                                   styles: $styles)
                AxisStyleInstacesView(axis: axis, 
                                      selection: $styleSelection, 
                                      styles: $styles)
            }
        }
    }
}

//#Preview {
//    @State var axes = Axes<Axis>()
//    @Bindable var axis = axes.addAxis(name: "Wifth", shortName: "wdf")
//    return StyledAxisView(axis: axis, selectedInstance: .constant(Axis.AxisStyleInstance? = nil))
//        .environment(axes)
//}
