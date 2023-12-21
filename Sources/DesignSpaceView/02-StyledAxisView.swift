//
//  StyledAxisView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import SwiftUI

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
                                      selection: $styleSelection) 
            }
        }
    }
}

#Preview {
    @State var space = makeDemoAxes() as Space<DemoAxis>
    @State var styles = space.styles
    @State var  styleSelection: StyleInstance? = styles[0]
    let axis = space.axes[0]
    return StyledAxisView(axis: axis, 
                          styleSelection: $styleSelection, 
                          styles: $styles)
        .environment(space)
}
