//
//  Untitled.swift
//  DesignSpace
//
//  Created by Łukasz Dziedzic on 22/09/2024.
//
import SwiftUI
import HyperSpace
import DesignSpace

struct DetailsView<Axis>: View 
where Axis: StyledAxisProtocol,
      Axis: HasPositionProtocol {
    @Bindable var axis:Axis
    @Binding var environmentStyle: Style<Axis>
   
    
    var body: some View {
        if environmentStyle.id == -1 {
            AxisDetailsView(axis: axis, 
                            environmentStyle: $environmentStyle)
        } else {
            AxisStyleInstacesView(axis: axis, 
                                  environmentStyle: $environmentStyle)
        }
    }
}
