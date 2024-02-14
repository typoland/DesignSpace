//
//  ContentView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import SwiftUI

typealias Selection = [StyleCoordinate]

public struct DesignSpaceView<Axis>: View 
where Axis: StyledAxisProtocol
{
    //@Environment(Space<Axis>.self) var designSpace
    
    @State var selectedStyle: StyleInstance<Axis>? = nil
    @State var spaceStyleIndex: Int = 0
    @State var styles:  [StyleInstance<Axis>] = []
    @State var snapToStyle: Bool = false
    var designSpace: Space<Axis>
    func updateStyles() {
        styles = designSpace.styles
    }
    
    //Init must be here because it's in package
    public init(designSpace: Space<Axis>) {
        self.designSpace = designSpace
    }
    
    //Delivers axes coordinates as string for Picker menu
    var currrentAxesPositionString : String {
        var t = designSpace.axes.reduce (into: "", {s, axis in
            s += "\(axis.name): \(axis.position.formatted(.number.rounded(increment: 1))) "
        }) 
        if !t.isEmpty { t.removeLast() }
        return String(t)
    }
        
    public var body: some View {
        VStack  {
            HStack {
                
                Picker("Styles", selection: $selectedStyle.by(\.id, from: styles)) {
                    if selectedStyle == nil || selectedStyle?.id == 0 {
                        let _ = print ("id 0 - \(selectedStyle)")
                        Text("\(currrentAxesPositionString)")
                            .truncationMode(.middle)
                            .tag(0 as Int?)
                    } 
                    
                    ForEach($styles) { $style in 
                        //let _ = print ("existing \(style) \(style.id)")
                        Text("\(designSpace.name(of: style)) - \(style.coordinatesRounded.description)")
                            .tag(style.id as Int?)
                    }
                }
          
                Toggle("snap", isOn: $snapToStyle)
                
                Button("Add Axis") { 
                    //let axis = designSpace.addAxis(name: "new", shortName: "new")
                    selectedStyle?.addAxis()
                    styles = designSpace.styles
                }
            }
            
            ScrollView (.vertical, showsIndicators: true) {
                ForEach(designSpace.axes.indices, id:\.self) { axisNr in
                    StyledAxisView(axis: designSpace.axes[axisNr], 
                                   styleSelection: $selectedStyle,
                                   styles: $styles)
                    .environment(designSpace)
                }
            }
            
            .onChange(of: designSpace.positions) {old, new in
                if snapToStyle {
                    snapCoordsToStyle()
                } else {
                    for (index, position) in new.enumerated() {
                        designSpace.axes[index].position = position
                    }
                }
                
                selectedStyle = styles.first(where: { style in
                    var ok = true
                    for (index, pos) in style.styleCoordinates.enumerated() {
                        ok = ok && Int(pos.position) == Int(designSpace.positions[index])
                    }
                    return ok
                })
                updateStyles()
            }
            #if DEBUG
            Text("SELECTED STYLE:\n\(selectedStyle.debugDescription)")
            #endif
        }
        .onAppear {
            updateStyles()
            selectedStyle = styles.isEmpty ? nil : styles[0]
        }
        .padding()
        
        Spacer() // Push everything up / space at bottom
    }
    
    func snapCoordsToStyle() {
        for (index, axis) in designSpace.axes.enumerated() {
            let current = axis.position
            let closest = styles.map {Double($0.coordinatesRounded[index])}
                .closest(to: current)
            axis.position = closest
        }
    }
    
    
}

#Preview {
    let DEMO_SPACE = makeDemoAxes() as Space<DemoAxis>
    return DesignSpaceView(designSpace: DEMO_SPACE)
}
