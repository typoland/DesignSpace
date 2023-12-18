//
//  ContentView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import SwiftUI
import DesignSpace

typealias Selection = [AxisInstanceSelection]

public struct StyledAxesView<Axis>: View 
where Axis: StyledAxisProtocol
{
    //@Environment(Space<Axis>.self) var designSpace
    
    @State var selectedStyle: StyleInstance? = nil
    @State var spaceStyleIndex: Int = 0
    @State var styles:  [StyleInstance] = []
    @State var snapToStyle: Bool = false
    var designSpace: Space<Axis>
    func updateStyles() {
        styles = designSpace.styles
    }
    
    public init(designSpace: Space<Axis>) {
        self.designSpace = designSpace
    }
    
    var currrentAxesPositionString : String {
        var t = designSpace.axes.reduce (into: "", {s, axis in
            s += "\(axis.name): \(axis.position.formatted(.number.rounded(increment: 1))) "
        }) 
        if !t.isEmpty { t.removeLast() }
        return String(t)
    }
    
    //    var bindingByID: Binding<Int?> {
    //        Binding(get: {selectedStyle?.id}, 
    //                set: {newID in selectedStyle = styles.first(where: {$0.id == newID})})
    //    }
    
    public var body: some View {
        VStack  {
            HStack {
                Picker("Styles", selection: $selectedStyle.by(\.id, from: styles)) {
                    if selectedStyle == nil {
                        Text("\(currrentAxesPositionString)")
                            .tag(nil as Int?)
                    }
                    
                    ForEach(styles) { style in 
                        Text("\(designSpace.name(of: style)) - \(style.coordinates.description)")
                            .tag(style.id as Int?)
                    }
                }
                Toggle("snap", isOn: $snapToStyle)
                
                Button("Add Axis") { 
                    let axis = designSpace.addAxis(name: "new", shortName: "new")
                    selectedStyle?.positionsOnAxes.addAxis(axis)
                    styles = designSpace.styles
                }
            }
            
            ScrollView (.vertical, showsIndicators: true) {
                
                ForEach(designSpace.axes) { axis in
                    StyledAxisView(axis: axis, 
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
                    for (index, pos) in style.positionsOnAxes.enumerated() {
                        ok = ok && Int(pos.position) == Int(designSpace.positions[index])
                    }
                    return ok
                })
                updateStyles()
            }
        }
        .onAppear {
            updateStyles()
            selectedStyle = styles[0]
        }
        .padding()
        
        Spacer() // Push everything up / space at bottom
        
        
    }
    
    func snapCoordsToStyle() {
        for (index, axis) in designSpace.axes.enumerated() {
            let current = axis.position
            let closest = styles.map {Double($0.coordinates[index])}
                .closest(to: current)
            axis.position = closest
        }
    }
    
    
}

#Preview {
    StyledAxesView(designSpace: GLOBAL_SPACE)
}
