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
    //@Binding var styles : [StyleInstance]
    
    @State var instanceSelection : AxisInstance = AxisInstance()

    @Environment(Space<Axis>.self) private var space
    
    
    
    var instanceIndex: Int? {
        axis.instances.firstIndex(where: {$0.id == instanceSelection.id})
    }
    
    var body: some View {
        VStack {
        HStack (alignment: .top) {
            
            //MARK: Style Picker
            Picker("", selection: $instanceSelection) {
                ForEach(axis.instances) { instance in
                    Text("\(instance.name)")
                        .tag(instance as AxisInstance)
                }
            }.frame(width: 28)
            
            //MARK: Edit Instance Name
            TextField("", text: $instanceSelection.name)
            
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
            //MARK: Edge Values
            if let instanceIndex {
                EdgeValuesView(axis: axis,
                               instance: $axis.instances[instanceIndex]) 
                               //selection: $selection)
            }
            Spacer()
            
        }.onAppear {
           selectInstanceSelection()
        }.onChange(of: instanceSelection) {old, new in
            print ("OLD \(old)\nNEW \(new)")
            //print ("instance selection chnged \(selection == nil ? "no style selection" : "\(selection!.symbolicCoordinates)" )")
            if let index = selection?.symbolicCoordinates.firstIndex(where: {$0.axisId == axis.id}) { 
           // let id = instanceSelection?.id {
                selection?.symbolicCoordinates[index].instanceId = instanceSelection.id
            }
            //styles = space.styles
        }.onChange(of: selection) {
            print ("style selection chnged")
           selectInstanceSelection()
        }
        .onChange(of: axis.instances) {
            print ("axis.axisInstances chnged")
            selectInstanceSelection()
        }
    }
    
    func selectInstanceSelection() {
        if let z = selection?.symbolicCoordinates.first(where: {$0.axisId == axis.id}),
           let instance =  space[axis, z.instanceId] {
            instanceSelection = instance
            print ("new instance set \(instance)")
        } 
    }
}

#Preview {
    let axes = makeDemoAxes() as Space<DemoAxis>
    @State var axis = axes.axes[0]
    @State var styleSelection : StyleInstance? = StyleInstance(position: [StyleCoordinate(axisId: axis.id, instanceId: axis.instances[0].id, position: 10)])
    @State var styles = axes.styles
    return AxisStyleInstacesView(axis: axis, 
                                 selection: $styleSelection)
//    
    .environment(axes)
}
