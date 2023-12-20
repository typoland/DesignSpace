//
//  InstanceEdgeValueView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 27/11/2023.
//

import SwiftUI


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
                    if let instanceIndex = axis.instances
                        .firstIndex(where: {$0 == instance}) {
                        
                        axis.instances.remove(at: instanceIndex)
                        
                        
                        if let firstInstance = axis.instances.first,
                           let index = selection?.symbolicCoordinates.firstIndex(where: {$0.axisId == axis.id}){
                            selection?.symbolicCoordinates[index].instanceId = firstInstance.id
                            instance = firstInstance
                            
                        }
                    }
                }, label: {Image(systemName: "trash")}
                )
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
    let space = Space<DemoAxis>()
    let axis = space.addAxis(name: "Test", 
                             shortName: "ts", 
                             styleName: "Normal", at: 500)
    @State var instance = axis.instances[0]
    let style = StyleInstance(position: [
        StyleCoordinate(axisId: axis.id, 
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
