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
    @Binding var environmentStyle: Style<Axis>
    @State var detailsViewOpen: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            GroupBox {
                AxisPropertiesView(axis: axis, 
                                   environmentStyle: $environmentStyle,
                                   openDetails: $detailsViewOpen)
                
                if detailsViewOpen {
                    DetailsView(axis: axis)
                    AxisStyleInstacesView(axis: axis, 
                                          environmentStyle: $environmentStyle)
                }
            }
        }
    }
}

#Preview {
    @State var space = makeDemoAxes() as DesignSpace<DemoAxis>
    @State var styles = space.styles
    @State var  styleSelection: Style = styles[0]
    let axis = space.axes[0]
    StyledAxisView(axis: axis, 
                   environmentStyle: $styleSelection)
        .environment(space)
}
