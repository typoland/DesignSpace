//
//  04-AxisDetailsView.swift
//  DesignSpace
//
//  Created by Łukasz Dziedzic on 22/09/2024.
//
import SwiftUI
import HyperSpace

struct AxisDetailsView<Axis> : View
where Axis: StyledAxisProtocol,
      Axis: HasPositionProtocol {
    
    @Bindable var axis: Axis
    @Binding var environmentStyle: Style<Axis>
    @Environment(DesignSpace<Axis>.self) private var designSpace
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Axis name:")
            TextField("name", text: $axis.name)
                .frame(width: 100)
            Text("short name:")
            TextField("short name", text: $axis.shortName)
                .frame(width: 40)
            Text("min:")
            TextField("min", value: $axis.lowerBound, format: .number)
                .frame(width: 45)
            Text("max:")
            TextField("max", value: $axis.upperBound, format: .number)
                .frame(width: 45)
            Spacer()
            Button(action: {
                let previousStyleID = environmentStyle.id
                if let axisIndex = designSpace.axisIndex(of: axis) {
                    designSpace.delete(axis: axis)
                    
                    
                    if previousStyleID != -1 {
                        environmentStyle 
                        = designSpace.environmentStyle(styleID: previousStyleID
                            .deleteBit(axisIndex)
                        )
                    }
                }
                if designSpace.styles.isEmpty {
//                    let coordinates =  designSpace.axes.map { axis in
//                        StyleCoordinate(axisId: axis.id, at: axis.at)
//                    }
                    environmentStyle = Style(in: designSpace)
                }
            }) {
                Image(systemName: "trash.fill")
            }.help("delete Axis")
                .onChange(of: axis.name) {
                    if let names = designSpace.defaultAxisNames.first(where: {$0.name == axis.name}) {
                        axis.shortName = names.shortName
                    } else {
                        axis.shortName = "??"
                    }
                    
                }
        }
    }
}
