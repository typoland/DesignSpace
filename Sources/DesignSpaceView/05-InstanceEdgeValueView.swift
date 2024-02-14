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
    //@Binding var styles: [StyleInstance<Axis>]
    @Environment(Space<Axis>.self) private var space
    
    var body: some View {
        
        VStack {

            ForEach($instance.axisEdgesValues.indices, id:\.self) {index in
                HStack {
                    
                        let name = space.instanceEdgeValueName(of: axis, edge: index) // | wt ▲ | wd ▲ |
                        Text("\(name)")
                            .frame(width: 100)
                        Slider(value: $instance.axisEdgesValues[index], 
                               in: axis.bounds) {_ in
                            print ("instance \(instance.name) changed")
                            space.styles
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
    let style =  StyleInstance(position: [
        StyleCoordinate(axisId: axis.id, 
                        instanceId: instance.id, 
                        position: 10)], space: space)
    @State var styleSelection : StyleInstance<DemoAxis>? = style
    @State var styles = space.styles
    return EdgeValuesView(axis: axis,
                          instance: $instance)
  
    .environment(space)
                         
}
