//
//  WTDonutChartView.swift
//  Wallet App
//
//  Created by Oleksandr Denysov on 11.12.2023.
//

import SwiftUI
import Charts

struct ChartData: Identifiable, Plottable {
    var id = UUID()
    let primitivePlottable: Int
    let color: Color

    init(primitivePlottable: Int) {
        self.primitivePlottable = primitivePlottable
        self.color = .blue
    }

    init(primitivePlottable: PrimitivePlottable, color: Color) {
        self.primitivePlottable = primitivePlottable
        self.color = color
    }
}

struct WTDonutChartView: View {

    public let donutData: [ChartData]

    init(donutData: [ChartData]) {
        self.donutData = donutData
    }

    var body: some View {
        VStack {
            Chart(donutData) { item in
                SectorMark(
                    angle: .value("Label", item), innerRadius: .ratio(0.69)
                )
                .foregroundStyle(item.color)
            }
            .frame(width: UIScreen.main.bounds.width, height: 400)
            .navigationTitle("Statistics")
            .padding(.all)
            .chartBackground { chartProxy in
                GeometryReader(content: { geometry in
                    let frame  = geometry[chartProxy.plotFrame!]
                    VStack {
                        Text("Total expenses")
                            .font(.title.weight(.regular))
                        Text(
                            "\(donutData.reduce(0, { $0 + $1.primitivePlottable }))"
                        )
                        .font(.title.weight(.bold))
                    }
                    .position(CGPoint(x: frame.midX, y: frame.midY))
                })
            }
        }
        .background(Color(.wtMainBackgroundColor))
        .frame(width: UIScreen.main.bounds.width, height: 400)
    }
}

//#Preview {
//    WTDonutChartView(donutData: donutData)
//}
