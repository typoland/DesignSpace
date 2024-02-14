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
    @Binding var styleSelection: StyleInstance<Axis>?
    var styles : [StyleInstance<Axis>]
    
    @State var instanceSelection : AxisInstance? = nil
    
    @Environment(Space<Axis>.self) private var space
    
    var instanceIndex: Int? {
        axis.instances.firstIndex(where: {$0.id == instanceSelection?.id})
    }
    
    var body: some View {
        HStack (alignment: .top) {
            
            //MARK: Axis Instance Picker
            if instanceSelection != nil {
                AxisInstancePicker(axis: axis, 
                                   instanceSelection: $instanceSelection.forShure(),
                                   styleSelection: $styleSelection,
                                   styles: styles)
            }
            
            //MARK: Axis Instance
            VStack {
                if let instanceIndex {
                    HStack {
                        //MARK: Edit Instance Name
                        TextField("", text: $axis.instances[instanceIndex].name)
                        
                        //MARK: Delete Instance
                        Button(action: {
                            if let instanceIndex = axis.instances.firstIndex(where: {
                                $0 == instanceSelection
                            }) {
                                axis.instances.remove(at: instanceIndex)
                                instanceSelection = nil
                            }
                        }, label: {Image(systemName: "trash")}
                        )
                    }
                    EdgeValuesView(axis: axis,
                                   instance: $axis.instances[instanceIndex]) 
                }
                Spacer()
                
            }
//            .onChange(of: axis.instances) {
//                print ("🔴 axis instances")
//                //                selectInstanceSelection()
//            }
            
//            .onChange(of: styleSelection) {
//                print ("🟠 selection")
//                //                selectInstanceSelection()
//            }
            
            .onAppear {
                print ("🟢 appear")
                selectInstanceSelection()
            }
            Spacer()
        }
        
    }

    
    func selectInstanceSelection() {
        print (#function, Date.now)
        instanceSelection = styleSelection?.selectedInstance(for: axis)
    }
}

#Preview {
    let axes = makeDemoAxes() as Space<DemoAxis>
    @State var axis = axes.axes[0]
    @State var styleSelection : StyleInstance? = StyleInstance(position: [StyleCoordinate(axisId: axis.id, instanceId: axis.instances[0].id, position: 10)], space: axes)
    @State var styles = axes.styles
    return AxisStyleInstacesView(axis: axis, 
                                 styleSelection: $styleSelection, 
                                 styles: axes.styles)
    //    
    .environment(axes)
}
