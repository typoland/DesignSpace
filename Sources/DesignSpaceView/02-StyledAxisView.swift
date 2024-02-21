//
//  StyledAxisView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import SwiftUI
import HyperSpace

struct StyledAxisView<Axis>: View 
where Axis: StyledAxisProtocol,
      Axis: HasPositionProtocol

{
    @Bindable var axis: Axis
    @Binding var styleSelection: Style<Axis>
    //@Binding var styles: [StyleInstance<Axis>]
    
    var body: some View {
        VStack {
            GroupBox {
                AxisPropertiesView(axis: axis, 
                                   styleSelection: $styleSelection)
                                 //  styles: $styles)
                AxisStyleInstacesView(axis: axis, 
                                      styleSelection: $styleSelection)
                                     // styles: $styles) 
            }
        }
    }
}

#Preview {
    @State var space = makeDemoAxes() as DesignSpace<DemoAxis>
    @State var styles = space.styles
    @State var  styleSelection: Style = styles[0]
    let axis = space.axes[0]
    return StyledAxisView(axis: axis, 
                          styleSelection: $styleSelection)
                    //      styles: $styles)
        .environment(space)
}
