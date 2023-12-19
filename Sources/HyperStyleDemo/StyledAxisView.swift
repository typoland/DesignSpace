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

#Preview {
    @State var space = Space<DemoAxis>()
    @State var styles = space.styles
    @State var  styleSelection: StyleInstance? = styles[0]
    var axis = space.addAxis(name: "Wifth", shortName: "wdf")
    return StyledAxisView(axis: axis, 
                          styleSelection: $styleSelection, 
                          styles: $styles)
        .environment(space)
}
