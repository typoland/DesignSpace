//
//  AxisStyleInstacesView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import SwiftUI

struct AxisStyleInstacesView<Axis>: View
where Axis: StyledAxisProtocol
{
    @Bindable var axis: Axis
    @Binding var selection: StyleInstance?
    @Binding var styles : [StyleInstance]
    
    @State var instanceSelection : AxisInstance? = nil

    @Environment(Space<Axis>.self) private var space
    
    
    var instanceIndex: Int? {
        axis.axisInstances.firstIndex(where: {$0.id == instanceSelection?.id})
    }
    
    var body: some View {
        HStack (alignment: .top) {
            
            //MARK: Style Picker
            Picker("", selection: $instanceSelection) {
                if instanceSelection == nil {
                    Text("?")
                        .tag(nil as AxisInstance?)
                }
                ForEach(axis.axisInstances) { instance in
                    Text("\(instance.name)")
                        .tag(instance as AxisInstance?)
                }
            }.frame(width: 28)
            
            //MARK: Edge Values
            if let instanceIndex {
                EdgeValuesView(axis: axis,
                               instance: $axis.axisInstances[instanceIndex], 
                               selection: $selection,
                styles: $styles)
            }
            Spacer()
            
        }.onAppear {
            if let z = selection?.positionsOnAxes.first(where: {$0.axisId == axis.id}) {
                instanceSelection = space[axis, z.instanceId]
            } 
        }.onChange(of: instanceSelection) {
            print ("instance selection chnged")
            if let index = selection?.positionsOnAxes.firstIndex(where: {$0.axisId == axis.id}),
            let id = instanceSelection?.id {
                selection?.positionsOnAxes[index].instanceId = id
            }
            styles = space.styles
        }.onChange(of: selection) {
            if let z = selection?.positionsOnAxes.first(where: {$0.axisId == axis.id}) {
                instanceSelection = space[axis, z.instanceId]
            } 
        }
        .onChange(of: axis.axisInstances) {
            print ("axis.axisInstances chnged")
        }
    }
}

#Preview {
    let axes = Space<DemoAxis>()
    @State var axis = axes.addAxis(name: "width", shortName: "wt")
    @State var styleSelection : StyleInstance? = StyleInstance(position: [AxisInstanceSelection(axisId: axis.id, instanceId: axis.axisInstances[0].id, position: 10)])
    @State var styles = axes.styles
    return AxisStyleInstacesView(axis: axis, 
                                 selection: $styleSelection, 
                                 styles: $styles)
    .environment(axes)
}
