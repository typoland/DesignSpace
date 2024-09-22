//
//  Untitled.swift
//  DesignSpace
//
//  Created by Łukasz Dziedzic on 22/09/2024.
//
import SwiftUI
import HyperSpace

struct DetailsView<Axis>: View 
where Axis: StyledAxisProtocol> {
    @Bindable var axis:Axis
    @Binding var environmentStyle: Style<Axis>
    @Environment(DesignSpace<Axis>.self) private var designSpace
    
    var body: some View {
        if environmentStyle.id == -1 {
            AxisDetailsView()
        } else {
            AxisStyleInstacesView(axis: axis, instance)
        }
    }
}
