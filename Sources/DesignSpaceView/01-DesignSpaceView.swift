//
//  ContentView.swift
//  HyperStyleDemo
//
//  Created by Łukasz Dziedzic on 26/11/2023.
//

import SwiftUI
import HyperSpace

typealias Selection = [StyleCoordinate]

public struct DesignSpaceView<Axis>: View 
where Axis: StyledAxisProtocol,
      Axis: HasPositionProtocol
{
    //@Environment(Space<Axis>.self) var designSpace
    
    @State var selectedStyle: Style<Axis>//? = nil
    @State var spaceStyleIndex: Int = 0
    @State var snapToStyle: Bool = false
    
    var designSpace: DesignSpace<Axis>
//    func updateStyles() {
//        styles = designSpace.styles
//    }
    
    //Init must be here because it's in package
    public init(designSpace: DesignSpace<Axis>) {
        self.designSpace = designSpace
        self.selectedStyle = designSpace.styles.first ?? Style(in: designSpace)
    }
    
    //Delivers axes coordinates as string for Picker menu
    var currrentAxesPositionString : String {
        var t = designSpace.axes.reduce (into: "", {s, axis in
            s += "\(axis.name): \(axis.at.formatted(.number.rounded(increment: 1))) "
        }) 
        if !t.isEmpty { t.removeLast() }
        return String(t)
    }
        
    public var body: some View {
        VStack  {
            HStack {
                Picker("Styles", selection: $selectedStyle) { //}.by(\.id, from: styles)) {
                    if selectedStyle.id == 0 {
                        Text("\(selectedStyle.name)")
                            .truncationMode(.middle)
                            .tag(selectedStyle)
                    } 
                    let styles = designSpace.styles
                    ForEach(styles) { style in 
                        Text("\(designSpace.name(of: style)) - \(style.coordinatesRounded.description)")
                            .tag(style as Style)
                    }
                }
          
                Toggle("snap", isOn: $snapToStyle)
                
                Button("Add Axis") { 
                    let axis = designSpace.addAxis(name: "New", shortName: "nw")
                    selectedStyle.add(axis: axis)
                }
            }
            
            ScrollView (.vertical, showsIndicators: true) {
                ForEach(designSpace.axes.indices, id:\.self) { axisNr in
                    StyledAxisView(axis: designSpace.axes[axisNr], 
                                   styleSelection: $selectedStyle)
                                   //styles: $styles)
                    .environment(designSpace)
                }
            }
            
            .onChange(of: designSpace.positions) {old, new in
                if snapToStyle {
                    snapCoordsToStyle()
                } else {
                    for (index, position) in new.enumerated() {
                        designSpace.axes[index].at = position
                    }
                }
                
                selectedStyle = designSpace.styles.first(where: { style in
                    var ok = true
                    for (index, pos) in style.styleCoordinates.enumerated() {
                        ok = ok && Int(pos.at) == Int(designSpace.positions[index])
                    }
                    return ok
                }) ?? Style(in: designSpace)
                //updateStyles()
            }
            #if DEBUG
            Text("SELECTED STYLE:\n\(selectedStyle.description)")
            #endif
        }
        .padding()
        .onAppear {
            //updateStyles()
            selectedStyle = designSpace.styles.first ?? Style(in: designSpace)
        }
//        .onChange(of: selectedStyle) {
//            print (selectedStyle)
//            for styleCoordinate in selectedStyle.styleCoordinates ?? [] {
//                if let axisIndex = designSpace.axes.firstIndex(where: {$0.id == styleCoordinate.axisId}) {
//                    designSpace.axes[axisIndex].at = styleCoordinate.at
//                }
//            }
//        }
        
    
        
        Spacer() // Push everything up / space at bottom
    }
    func adaptAxesPositions() {
        
    }
    func snapCoordsToStyle() {
        for (index, axis) in designSpace.axes.enumerated() {
            let current = axis.at
            let closest = designSpace.styles.map {Double($0.coordinatesRounded[index])}
                .closest(to: current)
            designSpace.axes[index].position = PositionOnAxis(axis: designSpace.axes[index], at: closest)
        }
    }
    
    
}

#Preview {
    let DEMO_SPACE = makeDemoAxes() as DesignSpace<DemoAxis>
    return DesignSpaceView(designSpace: DEMO_SPACE)
}
