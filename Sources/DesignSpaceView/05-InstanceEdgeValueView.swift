//
//  InstanceEdgeValueView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 27/11/2023.
//

import SwiftUI
import HyperSpace


struct EdgeValuesView<Axis>: View
where Axis: StyledAxisProtocol,
      Axis: HasPositionProtocol
{
    
    @Bindable var axis: Axis
    @Binding var instance: AxisInstance
    //@Binding var styles: [StyleInstance<Axis>]
    @Environment(DesignSpace<Axis>.self) private var space
    
    var body: some View {
        
        VStack {
            
            ForEach($instance.axisEdgesValues.indices, id:\.self) {index in
                HStack {
                    
                        let name = space.instanceEdgeValueName(of: axis, edge: index) // | wt ▲ | wd ▲ |
                        Text("\(name)")
                            .frame(width: 100)
                        Slider(value: $instance.axisEdgesValues[index], 
                               in: axis.bounds) 
                               .controlSize(.mini)
                        Text ("\(instance.axisEdgesValues[index], specifier:"%0.0f")")
                            .frame(width: 60)
                    }
                }.controlSize(.mini)
                .onChange(of: instance.axisEdgesValues) {
                   
                    space.clearStylesCache()
                }
           
        }
    }
}

#Preview {
    let space = DesignSpace<DemoAxis>()
    let axis = space.addAxis(name: "Test", 
                             shortName: "ts", 
                             styleName: "Normal", at: 500)
    @State var instance = axis.instances[0]
    let style =  Style(position: [
        StyleCoordinate(axisId: axis.id, 
                        instanceId: instance.id, 
                        at: 10)], in: space, id: 1)
    @State var styleSelection : Style<DemoAxis>? = style
    @State var styles = space.styles
    return EdgeValuesView(axis: axis,
                          instance: $instance)
  
    .environment(space)
                         
}
