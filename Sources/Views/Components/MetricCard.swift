import SwiftUI

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.caption2.weight(.semibold))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .monospacedDigit()
            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
        )
    }
}

struct MetricCard_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            MetricCard(title: "RSSI", value: "-58 dBm", subtitle: "Signal", color: .blue)
            MetricCard(title: "SNR", value: "32 dB", subtitle: "RSSI − Noise", color: .indigo)
        }
        .padding()
        .frame(width: 480)
    }
}
