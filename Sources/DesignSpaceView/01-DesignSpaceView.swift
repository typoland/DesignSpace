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
    //@Environment(DesignSpace<Axis>.self) var designSpace
    
    
    
    @State private var spaceStyleIndex: Int = -1
    @State private var snapToStyle: Bool = false
    //@State private var selectedStyle: Style<Axis>
    
    
    
    var designSpace: DesignSpace<Axis>
//    func updateStyles() {
//        styles = designSpace.styles
//    }
    
    //Init must be here because it's in package
    public init(designSpace: DesignSpace<Axis>) {
        self.designSpace = designSpace
        //self.selectedStyle = Style(in: designSpace)
    }
    
    //Delivers axes coordinates as string for Picker menu
    private var currrentAxesPositionString : String {
        var t = designSpace.axes.reduce (into: "", {s, axis in
            s += "\(axis.name): \(axis.at.formatted(.number.rounded(increment: 1))) "
        }) 
        if !t.isEmpty { t.removeLast() }
        return String(t)
    }
    private var styles: [Style<Axis>] {
        designSpace.styles
    }    
    
    var currentStyle: Binding<Style<Axis>> {
        Binding(
            get: {
                designSpace.environmentStyle(styleID: spaceStyleIndex)
            },
            set: {new in
                print (new.id)
                spaceStyleIndex = new.id
            })
    }
    
    public var body: some View {
        VStack  {
            HStack {
                Picker("Styles", selection: $spaceStyleIndex) { 
                    
                    if spaceStyleIndex == -1 {
                        Text ("environment \(designSpace.name(of: currentStyle.wrappedValue))")
                            .tag(-1)
                    }
                    
                    
                    ForEach(styles) { style in 
                        Text("\(designSpace.name(of: style)) - \(style.coordinatesRounded.description)")
                            .tag(style.id)
                    }
                }
          
                Toggle("snap", isOn: $snapToStyle)
                
                Button("Add Axis") { 
                    let axis = designSpace.addAxis(name: "New", shortName: "nw")
                }
            }
        
            ScrollView (.vertical, showsIndicators: true) {
                ForEach(designSpace.axes.indices, id:\.self) { axisNr in
                    StyledAxisView(axis: designSpace.axes[axisNr], 
                                   environmentStyle: currentStyle)
                    .environment(designSpace)
                }
            }
            
#if DEBUG
            Text("Environment STYLE:\n\(currentStyle.wrappedValue.description)")
#endif
        }
        
        .padding()
        .onAppear {
            spaceStyleIndex = styles.isEmpty ? -1 : 0
        }
        
        
        Spacer() // Push everything up / space at bottom
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
