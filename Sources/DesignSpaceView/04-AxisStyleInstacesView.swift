//
//  AxisStyleInstacesView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import SwiftUI
import HyperSpace




struct AxisStyleInstacesView<Axis>: View
where Axis: StyledAxisProtocol,
      Axis: HasPositionProtocol
{
    @Bindable var axis: Axis
    @Binding var styleSelection: Style<Axis>
    //var openDetails: Bool
    
    var instanceSelection : Binding<AxisInstance>? {
        guard let instance = styleSelection.selectedInstance(for: axis) else {return nil}
        return Binding<AxisInstance>(
            get: {
                instance
            }, 
            set: { newInstance in
                styleSelection.changeInstance(in: axis,
                                              to: newInstance)
            })
    }
    
    @Environment(DesignSpace<Axis>.self) private var space
    
    var instanceIndex: Int? {
        axis.instances.firstIndex(where: {$0.id == instanceSelection?.wrappedValue.id})
    }
    
    var body: some View {
        HStack (alignment: .top) {
            
            //MARK: Axis Instance Picker
            if instanceSelection != nil {
                AxisInstancePicker(axis: axis, 
                                   instanceSelection: instanceSelection!)
                                   //styleSelection: $styleSelection)
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
                                $0 == instanceSelection?.wrappedValue
                            }) {
                                axis.instances.remove(at: instanceIndex)
                                //instanceSelection = nil
                            }
                        }, label: {Image(systemName: "trash")}
                        )
                    }
                    EdgeValuesView(axis: axis,
                                   instance: $axis.instances[instanceIndex])
                                  // styles: $styles)
                    
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
            
//            .onAppear {
//                print ("🟢 appear")
//                selectInstanceSelection()
//            }
            Spacer()
        }
        
    }

    
//    func selectInstanceSelection() {
//        print (#function, Date.now)
//        instanceSelection = styleSelection?.selectedInstance(for: axis)
//    }
}

#Preview {
    let axes = makeDemoAxes() as DesignSpace<DemoAxis>
    @State var axis = axes.axes[0]
    @State var styleSelection : Style = Style(position: [StyleCoordinate(axisId: axis.id, 
                                                                                          instanceId: axis.instances[0].id, 
                                                                                          at: 10)], in: axes)
    @State var styles = axes.styles
    var openDetails = true
    return AxisStyleInstacesView(axis: axis, 
                                 styleSelection: $styleSelection)
   // openDetails: openDetails) 
                                // styles: $styles)
    //    
    .environment(axes)
}
