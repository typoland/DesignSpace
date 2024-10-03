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
    enum ViewStyleMode: String, CaseIterable {
        case axes
        case styles
    }
    
    
    @State private var spaceStyleIndex: Int = -1
    @State private var mode: ViewStyleMode = .styles
    
    var designSpace: DesignSpace<Axis>

    //Init must be here because it's in package
    public init(designSpace: DesignSpace<Axis>) {
        self.designSpace = designSpace
        //self.selectedStyle = Style(in: designSpace)
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
                spaceStyleIndex = new.id
                designSpace.setPositions(by: self.currentStyle.wrappedValue)
            })
    }
    
    public var body: some View {
        VStack  {
            HStack {
                Picker("", selection: $mode) {
                    ForEach(ViewStyleMode.allCases, id:\.self) {mode in
                        Text("\(mode.rawValue.capitalized)")
                            .tag(mode)
                    }
                }.frame(width: 140)
                
                Spacer()
                
                if mode == .styles {
                    Picker("\(styles.count) Styles", selection: $spaceStyleIndex) { 
                        
                        if spaceStyleIndex == -1 {
                            Text ("\(designSpace.name(of: currentStyle.wrappedValue))")
                                .tag(-1)
                        }
                        
                        
                        ForEach(styles) { style in 
                            Text("\(designSpace.name(of: style))")
                                .tag(style.id)
                        }
                    }
                } else {
                    Text ("\(designSpace.name(of: currentStyle.wrappedValue))")
                }
          
                Spacer(minLength: 100)
                
                Button("Add Axis") { 
                    designSpace.addAxis(name: "New", shortName: "nw")
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
        .onChange(of: mode) {
            switch mode {
            case .axes:
                designSpace.setPositions(by: currentStyle.wrappedValue)
                spaceStyleIndex = -1
            case .styles:
                currentStyle.wrappedValue = designSpace.closestStyle
            }
        }
        .onChange(of: spaceStyleIndex) {
            designSpace.setPositions(by: currentStyle.wrappedValue)
        }
        .onChange(of: currentStyle.wrappedValue.description) {
            designSpace.setPositions(by: currentStyle.wrappedValue)
        }
        Spacer() // Push everything up / space at bottom
    }
  
    
    
    
}

#Preview {
    let DEMO_SPACE = makeDemoAxes() as DesignSpace<DemoAxis>
    return DesignSpaceView(designSpace: DEMO_SPACE)
}
