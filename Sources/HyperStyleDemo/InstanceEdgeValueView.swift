//
//  InstanceEdgeValueView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 27/11/2023.
//

import SwiftUI
import DesignSpace

struct EdgeValuesView<Axis>: View
where Axis: StyledAxisProtocol
{
    
    @Bindable var axis: Axis
    @Binding var instance: AxisInstance
    @Binding var selection: StyleInstance?
    @Binding var styles: [StyleInstance]
    @Environment(Space<Axis>.self) private var space
    
    var body: some View {
        
        VStack {
            HStack {
                TextField("", text: $instance.name)
                Button(action: {
                    if let instanceIndex = axis.axisInstances.firstIndex(where: {$0 == instance}) {
                        
                        axis.axisInstances.remove(at: instanceIndex)
                        
                        
                        if let firstInstance = axis.axisInstances.first,
                           let index = selection?.positionsOnAxes.firstIndex(where: {$0.axisId == axis.id}){
                            selection?.positionsOnAxes[index].instanceId = firstInstance.id
                            instance = firstInstance
                            
                        }
                    }
                }
                    , label: {Image(systemName: "trash")})
            }
            
            ForEach($instance.axisEdgesValues.indices, id:\.self) {index in
                HStack {
                    
                        let name = space.instanceEdgeValueName(of: axis, edge: index) // | wt ▲ | wd ▲ |
                        Text("\(name)")
                            .frame(width: 100)
                        Slider(value: $instance.axisEdgesValues[index], 
                               in: axis.bounds) {_ in
                        }
                               .controlSize(.mini)
                        Text ("\(instance.axisEdgesValues[index], specifier:"%0.0f")")
                            .frame(width: 60)
                    }
                }.controlSize(.mini)
                
           
        }
    }
}

#Preview {
    var space = Space<DemoAxis>()
    var axis = space.addAxis(name: "Test", 
                             shortName: "ts", 
                             styleName: "Normal", at: 500)
    @State var instance = axis.axisInstances[0]
    var style = StyleInstance(position: [
        AxisInstanceSelection(axisId: axis.id, 
                              instanceId: instance.id, 
                              position: 10)])
    @State var styleSelection : StyleInstance? = style
    @State var styles = space.styles
    return EdgeValuesView(axis: axis,
                          instance: $instance,
                          selection: $styleSelection,
                          styles: $styles)
    .environment(space)
                         
}
