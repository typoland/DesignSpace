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
    
    var axis: Axis?
    @Binding var instance: AxisInstance
    @Binding var selection: StyleInstance?
    @Binding var styles: [StyleInstance]
    @Environment(Space<Axis>.self) private var space
    
    
    
    
    var body: some View {
        
        VStack {
            HStack {
                TextField("", text: $instance.name)
                Button(action: {
                    if let instanceIndex = axis?.axisInstances.firstIndex(where: {$0 == instance}),
                       let axis {
                        axis.axisInstances.remove(at: instanceIndex)
                        styles = space.styles
                        if let id = axis.axisInstances.first?.id,
                           let index = selection?.positionsOnAxes.firstIndex(where: {$0.axisId == axis.id}){
                            styles = space.styles
                            selection?.positionsOnAxes[index].instanceId = id
                        }
                        
                    }
                }, label: {Image(systemName: "trash")})
            }
            
            ForEach($instance.axisEdgesValues.indices, id:\.self) {index in
                HStack {
                    if let axis { 
                        let name = space.instanceEdgeValueName(of: axis, edge: index) // | wt ▲ | wd ▲ |
                        Text("\(name)")
                            .frame(width: 100)
                        Slider(value: $instance.axisEdgesValues[index], 
                               in: axis.bounds) {_ in
                            styles = space.styles
                        }
                               .controlSize(.mini)
                        Text ("\(instance.axisEdgesValues[index], specifier:"%0.0f")")
                            .frame(width: 60)
                    }
                }.controlSize(.mini)
                
            }
        }
    }
}

//#Preview {
//    let axis = Axis(name: "SS", shortName: "ss", bounds: 0...1000)
//    @State var egdeValue = 12.0
//    return EdgeValueView(edgeName: "what", axisEdgeValue: $egdeValue, axis: axis)
//}
