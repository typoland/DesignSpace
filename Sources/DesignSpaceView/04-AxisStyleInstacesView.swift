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
    @Binding var environmentStyle: Style<Axis>

    @Environment(DesignSpace<Axis>.self) private var designSpace
    
    
    var instanceSelection : Binding<AxisInstance>? {
        guard let instance = environmentStyle.selectedInstance(for: axis) else {return nil}
        return Binding<AxisInstance>(
            get: {
                instance
            }, 
            set: { newInstance in
                var style = environmentStyle
                style.changeInstance(in: axis,
                                              to: newInstance)
            })
    }
        
    var instanceIndex: Int? {
        axis.instances.firstIndex(where: {$0.id == instanceSelection?.wrappedValue.id})
    }
    
    var body: some View {
        HStack (alignment: .top) {
            //MARK: Axis Instance
            VStack {
                if let instanceIndex {
                    HStack {
                        //MARK: Edit Instance Name
                        Text ("Style name:")
                        TextField("", text: $axis.instances[instanceIndex].name)
                        Toggle(isOn: $axis.instances[instanceIndex].linked, label: {Image(systemName: "link")})
                            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            .controlSize(.mini)
                        Spacer(minLength: 40)
                        //MARK: Delete Instance
                        Button(action: {
                            if let instanceIndex = axis.instances.firstIndex(where: {
                                $0 == instanceSelection?.wrappedValue
                            }) {
                                axis.instances.remove(at: instanceIndex)
                            }
                        }, label: {Image(systemName: "trash")}
                        )
                    }
                    if !axis.instances[instanceIndex].linked {
                        EdgeValuesView(axis: axis,
                                       instance: $axis.instances[instanceIndex])  
                    }
                }
                Spacer()
                
            }
            Spacer()
        }
        
    }
}

#Preview {
    let axes = makeDemoAxes() as DesignSpace<DemoAxis>
    @State var axis = axes.axes[0]
    @State var environmentStyle : Style = Style(position: [StyleCoordinate(axisId: axis.id, 
                                                                           instanceId: axis.instances[0].id, 
                                                                           at: 10)], 
                                                in: axes, id: 0)
    @State var styles = axes.styles
    var openDetails = true
    AxisStyleInstacesView(axis: axis, 
                                 environmentStyle: $environmentStyle)
   // openDetails: openDetails) 
                                // styles: $styles)
    //    
    .environment(axes)
}
