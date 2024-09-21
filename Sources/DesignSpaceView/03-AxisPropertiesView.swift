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
                        set: {
            axis.position = PositionOnAxis(axis: axis, at: $0)
            
        })
    }
    
    var axisIndex: Int {
       designSpace.axes.firstIndex(of: axis)!
    }

    func removeInstance(from: Axis) {
        // TODO: CALL DESIGNSPACE STYLES CACHE
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
        
        HStack {
           Text("Axis:")
                .frame(width: 60)
            TextField("", text: $axis.name)
                .frame(width: 100)
            
            TextField("", text: $axis.shortName)
                .frame(width: 40)
            
            TextField("", value: $axis.lowerBound, format: .number)
                .frame(width: 45)
            
            TextField("", value: $axis.upperBound, format: .number)
                .frame(width: 45)
            
            //if let style = environmentStyle {
            Slider(value: position, in: axis.bounds) 
//            {on in
//                if on {environmentStyle = Style(in: designSpace)}
//            }
            .disabled(environmentStyle.id != -1)
           
            if instanceSelection != nil {
                HStack {
                    
                    AxisInstancePicker(axis: axis, 
                                       instanceSelection: instanceSelection!)

                    Button(action: {openDetails.toggle()}, label: {
                        Image(systemName: "slider.horizontal.3")
                    }).disabled(!(environmentStyle.isSpaceStyle ?? false))
                    
                    Button(action: {
                        removeInstance(from: axis)
                        designSpace.delete(axis: axis)
                        if designSpace.styles.isEmpty {
                            let coordinates =  designSpace.axes.map { axis in
                                StyleCoordinate(axisId: axis.id, at: axis.at)
                            }
                            environmentStyle = Style(in: designSpace)
                        }
                    }) {
                        Image(systemName: "trash")
                    }
                }                    
                .frame(width: 80)

            } else {
                HStack {
                    TextField("",
                              value: position, 
                              format: .number.precision(.fractionLength(0...0))
                    )
                }.frame(width: 80)
            }
            
            
            Button(action: {
                addInstance(to: axis)
            },
                   label: {
                Image(systemName: "plus.square")
                //Text("Add Style to \(axis.name)")
            })
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
