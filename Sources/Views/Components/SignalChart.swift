import SwiftUI
import Charts

struct SignalChart: View {
    let rssi: [WiFiMonitorViewModel.MetricPoint]
    let noise: [WiFiMonitorViewModel.MetricPoint]
    let snr: [WiFiMonitorViewModel.MetricPoint]

    var body: some View {
        Chart {
            ForEach(rssi) { p in
                LineMark(
                    x: .value("Time", p.time),
                    y: .value("dBm", p.value)
                )
                .foregroundStyle(.blue)
                .interpolationMethod(.monotone)
                .lineStyle(StrokeStyle(lineWidth: 2))
                .symbol(Circle().strokeBorder(.blue.opacity(0.4), lineWidth: 1))
            }
            ForEach(noise) { p in
                LineMark(
                    x: .value("Time", p.time),
                    y: .value("dBm", p.value)
                )
                .foregroundStyle(.gray)
                .interpolationMethod(.monotone)
                .lineStyle(StrokeStyle(lineWidth: 2, dash: [5,3]))
            }
            ForEach(snr) { p in
                LineMark(
                    x: .value("Time", p.time),
                    y: .value("dB", p.value)
                )
                .foregroundStyle(.indigo)
                .interpolationMethod(.monotone)
                .lineStyle(StrokeStyle(lineWidth: 2))
            }
        }
        .chartYAxisLabel("Signal (dBm / dB)")
        .chartXAxis {
            AxisMarks(position: .bottom, values: .automatic(desiredCount: 5)) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.hour().minute().second(), centered: true)
            }
        }
        .chartLegend(position: .top, alignment: .leading) {
            HStack(spacing: 16) {
                Label("RSSI", systemImage: "dot.circle").foregroundStyle(.blue)
                Label("Noise", systemImage: "dash").foregroundStyle(.gray)
                Label("SNR", systemImage: "dot.viewfinder").foregroundStyle(.indigo)
            }
            .labelStyle(.titleOnly)
            .font(.caption)
        }
    }
}

struct SignalChart_Previews: PreviewProvider {
    static var previews: some View {
        let now = Date()
        let gen: (Double) -> [WiFiMonitorViewModel.MetricPoint] = { base in
            (0..<60).map { i in
                .init(time: now.addingTimeInterval(Double(i) * -5), value: base + sin(Double(i)/6)*3)
            }.reversed()
        }
        return SignalChart(
            rssi: gen(-60), noise: gen(-90), snr: gen(30)
        )
        .frame(height: 220)
        .padding()
    }
}
