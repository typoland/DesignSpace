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
    @Binding var selection: StyleInstance<Axis>?
    //@Binding var styles : [StyleInstance]
    
    @State var instanceSelection : AxisInstance? = nil
    
    @Environment(Space<Axis>.self) private var space
    
    
    
    var instanceIndex: Int? {
        axis.instances.firstIndex(where: {$0.id == instanceSelection?.id})
    }
    
    var body: some View {
        HStack (alignment: .top) {
            //  HStack {
            
            //MARK: Style Picker
            Picker("", selection: $instanceSelection) {
                if instanceSelection == nil {
                    Text ("\(axis.name) at \(axis.position.formatted(.number.rounded(increment: 1)))")
                        .tag(nil as AxisInstance?)
                }
                ForEach(axis.instances) { instance in
                    Text("\(instance.name)")
                        .tag(instance as AxisInstance?)
                }
            }.frame(width: instanceSelection == nil ? 250 : 28)
            VStack {
                //MARK: Edit Instance Name
                if let instanceIndex {
                    HStack {
                        
                        TextField("", text: $axis.instances[instanceIndex].name)
                        
                        //MARK: Delete Instance
                        Button(action: {
                            if let instanceIndex = axis.instances
                                .firstIndex(where: {$0 == instanceSelection}) {
                                
                                axis.instances.remove(at: instanceIndex)
                                
                                
                                if let firstInstance = axis.instances.first,
                                   let selectedStyleIndex = selection?.symbolicCoordinates.firstIndex(where: {$0.axisId == axis.id}){
                                    selection?.symbolicCoordinates[selectedStyleIndex].instanceId = firstInstance.id
                                    //instanceSelection = firstInstance
                                    
                                }
                            }
                        }, label: {Image(systemName: "trash")}
                        )
                    }
                    EdgeValuesView(axis: axis,
                                   instance: $axis.instances[instanceIndex]) 
                    //selection: $selection)
                }
                Spacer()
                
            }.onAppear {
                selectInstanceSelection()
                //                if let instanceID = selection?.axisInstanceId(of: axis) {
                //                    instanceSelection = axis.instances.first(where: {$0.id == instanceID})
                //                }
                
            }.onChange(of: instanceSelection) {old, new in
                print ("OLD \(old)\nNEW \(new)")
                if let instance = new {
                    selection?.addToSelection(axis: axis, 
                                              instance: instance, 
                                              styles: space.styles)
                }
                print ("------------")
                
            }.onChange(of: selection) {
                print ("style selection chnged \(selection?.symbolicCoordinates.count ?? -1)")
                selectInstanceSelection()
            }
            .onChange(of: axis.instances) {
                print ("axis.axisInstances chnged")
                //selectInstanceSelection()
            }
            Spacer()
        }
        
    }
    
    func selectInstanceSelection() {
        instanceSelection = selection?.selectedInstanceID(for: axis)
    }
}

#Preview {
    let axes = makeDemoAxes() as Space<DemoAxis>
    @State var axis = axes.axes[0]
    @State var styleSelection : StyleInstance? = StyleInstance(position: [StyleCoordinate(axisId: axis.id, instanceId: axis.instances[0].id, position: 10)], space: axes)
    @State var styles = axes.styles
    return AxisStyleInstacesView(axis: axis, 
                                 selection: $styleSelection)
    //    
    .environment(axes)
}
