//
//  04-AxisDetailsView.swift
//  DesignSpace
//
//  Created by Łukasz Dziedzic on 22/09/2024.
//
struct AxisDetailsView : View {
    var body: some View {
        HStack(alignment: .top) {
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
            
            Button(action: {
                let previousStyleID = environmentStyle.id
                designSpace.delete(axis: axis)
                
                
                if previousStyleID != -1 {
                    environmentStyle 
                    = designSpace.environmentStyle(styleID: previousStyleID
                        .deleteBit(axisIndex)
                    )
                }
                
                if designSpace.styles.isEmpty {
                    let coordinates =  designSpace.axes.map { axis in
                        StyleCoordinate(axisId: axis.id, at: axis.at)
                    }
                    environmentStyle = Style(in: designSpace)
                }
            }) {
                Image(systemName: "trash.fill")
            }.help("delete Axis")
        }
    }
}
