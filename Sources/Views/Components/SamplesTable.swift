import SwiftUI

struct SamplesTable: View {
    let samples: [WiFiSample]

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .none
        df.timeStyle = .medium
        return df
    }()

    var body: some View {
        Table(samples) {
            TableColumn("Time") { s in
                Text(dateFormatter.string(from: s.timestamp))
                    .monospacedDigit()
            }
            TableColumn("SSID") { s in
                Text(s.ssid ?? "—")
            }
            TableColumn("Channel") { s in
                Text(s.channel ?? "—")
            }
            TableColumn("RSSI") { s in
                Text(formatInt(s.rssi, unit: "dBm"))
                    .monospacedDigit()
            }
            TableColumn("Noise") { s in
                Text(formatInt(s.noise, unit: "dBm"))
                    .monospacedDigit()
            }
            TableColumn("SNR") { s in
                Text(formatInt(s.snr, unit: "dB"))
                    .monospacedDigit()
            }
            TableColumn("TX Rate") { s in
                Text(formatRate(s.txRate))
                    .monospacedDigit()
            }
            TableColumn("MCS") { s in
                Text(s.mcs.map(String.init) ?? "—")
            }
            TableColumn("NSS") { s in
                Text(s.nss.map(String.init) ?? "—")
            }
            TableColumn("BSSID") { s in
                Text(s.bssid ?? "—")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func formatInt(_ value: Int?, unit: String) -> String {
        guard let v = value else { return "—" }
        return "\(v) \(unit)"
    }

    private func formatRate(_ value: Double?) -> String {
        guard let v = value else { return "—" }
        return String(format: "%.0f Mbps", v)
    }
}

struct SamplesTable_Previews: PreviewProvider {
    static var previews: some View {
        let now = Date()
        let samples = [
            WiFiSample(timestamp: now, ssid: "MyWiFi", bssid: "00:11:22:33:44:55", channel: "36", rssi: -58, noise: -90, txRate: 866, mcs: 9, nss: 2),
            WiFiSample(timestamp: now.addingTimeInterval(-1), ssid: "MyWiFi", bssid: "00:11:22:33:44:55", channel: "36", rssi: -62, noise: -90, txRate: 780, mcs: 7, nss: 2)
        ]
        return SamplesTable(samples: samples)
            .frame(height: 300)
            .padding()
    }
}
