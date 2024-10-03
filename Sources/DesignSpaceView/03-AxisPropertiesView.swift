//
//  AxisPropertiesView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 14/12/2023.
//

import SwiftUI
import Observation
import HyperSpace

struct AxisPropertiesView<Axis>: View 
where Axis: StyledAxisProtocol, 
      Axis: HasPositionProtocol,
      Axis: Observable
{
    @Environment(DesignSpace<Axis>.self) private var designSpace
    @Bindable var axis: Axis
    @Binding var environmentStyle: Style<Axis>
    @Binding var openDetails: Bool
    

    var instanceSelection : Binding<AxisInstance>? {
        guard let instance = environmentStyle.selectedInstance(for: axis) else {return nil}
        return Binding<AxisInstance>(
            get: {
                instance
            }, 
            set: { newInstance in
              
                environmentStyle.changeInstance(in: axis,
                                                to: newInstance)
            })
    }
    
    
    var position: Binding<Double> {
        Binding<Double>(get: {environmentStyle.id == -1 ? axis.at : environmentStyle.styleCoordinates[axisIndex].at}, 
                        set: { newPosition in
            
            if instanceSelection?.wrappedValue.linked ?? false {
                
                let size = instanceSelection!.wrappedValue.axisEdgesValues.count 
                var instance = instanceSelection!.wrappedValue
                (0..<size).forEach{ instance.axisEdgesValues[$0] = newPosition}
                if let index = axis.instances.firstIndex(of: instanceSelection!.wrappedValue) {
                    axis.instances[index] = instance
                }
                designSpace.clearStylesCache()
            } 
            axis.position = PositionOnAxis(axis: axis, at: newPosition)
        })
    }
    
    var axisIndex: Int {
       designSpace.axes.firstIndex(of: axis) ?? 0
    }

    func removeInstance(from: Axis) {
        designSpace.clearStylesCache()
        environmentStyle.removeInstance(from: axis)
    }
    
    func addInstance(to: Axis) {
        do {
            if let newInstanceID = try designSpace.addInstance(to: axis),
               let index = environmentStyle.styleCoordinates.firstIndex(where: {$0.axisId == axis.id}) {
                environmentStyle.styleCoordinates[index].instanceId = newInstanceID
            }
        } catch {
            print (error)
        }
    }
    
    var body: some View {
        
        HStack (alignment: .firstTextBaseline) {
            HStack {
                Button(action: {openDetails.toggle()}, label: {
                    Image(systemName: "slider.horizontal.3")
                })//.disabled(!(environmentStyle.isSpaceStyle ?? false))
                
                Text("\(axis.name)")
                Spacer()
                //if let style = environmentStyle {
            }.frame(width: 90)
            
            HStack {
                // MARK: STYLES AVAILABLE
                Spacer()
                if instanceSelection != nil {
                    HStack(alignment: .top) {
                        AxisInstancePicker(axis: axis, 
                                           instanceSelection: instanceSelection!)
                    }
                    
                    // MARK: ENVIRONMENT   
                } else {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            Button(action: {
                                addInstance(to: axis)
                            },
                                   label: {
                                Image(systemName: "plus.square.fill.on.square.fill")
                                //Text("Add Style to \(axis.name)")
                            }).help("add Style Instance")
                        }
                    }
                    
                }
            }.frame(width:100)
            TextField("",
                      value: position, 
                      format: .number.precision(.fractionLength(0...0))
            ).frame(width: 40)
                .disabled(instanceSelection != nil)
            Slider(value: position, in: axis.bounds) 
                .disabled(instanceSelection != nil 
                          && !(instanceSelection?.wrappedValue.linked ?? false)
                )
        }
        .buttonStyle(.borderless)
        
    }
}

#Preview {
    let DEMO_SPACE = makeDemoAxes() as DesignSpace<DemoAxis>
    let axis = DEMO_SPACE.axes[0]
    @State var styles = DEMO_SPACE.styles
    @State var environmentStyle = styles[0]
    @State var openDetails = true
    AxisPropertiesView(axis: axis,
                       environmentStyle: $environmentStyle,
    openDetails: $openDetails)
        .environment(DEMO_SPACE)
}
