import SwiftUI
import Charts

struct RateChart: View {
    let rate: [WiFiMonitorViewModel.MetricPoint]

    var body: some View {
        Chart {
            ForEach(rate) { p in
                AreaMark(
                    x: .value("Time", p.time),
                    y: .value("Mbps", p.value)
                )
                .foregroundStyle(Gradient(colors: [.green.opacity(0.4), .green.opacity(0.05)]))
                LineMark(
                    x: .value("Time", p.time),
                    y: .value("Mbps", p.value)
                )
                .foregroundStyle(.green)
                .interpolationMethod(.monotone)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
        }
        .chartYAxisLabel("TX Rate (Mbps)")
        .chartXAxis {
            AxisMarks(position: .bottom, values: .automatic(desiredCount: 5)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.hour().minute().second(), centered: true)
            }
        }
        .chartLegend(.hidden)
    }
}

struct RateChart_Previews: PreviewProvider {
    static var previews: some View {
        let now = Date()
        let points: [WiFiMonitorViewModel.MetricPoint] = (0..<60).map { i in
            .init(time: now.addingTimeInterval(Double(i) * -3), value: 500 + sin(Double(i)/4)*50)
        }.reversed()
        return RateChart(rate: points)
            .frame(height: 220)
            .padding()
    }
}
