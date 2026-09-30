import SwiftUI
import Charts

struct ContentView: View {
    @EnvironmentObject var vm: WiFiMonitorViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    header
                    summaryGrid
                    chartsSection
                    tableSection
                }
                .padding(20)
            }
            .navigationTitle("Wi‑Fi Monitor")
            .toolbar { toolbarContent }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "wifi")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.blue)
            VStack(alignment: .leading) {
                Text(vm.latest?.ssid ?? "Not Connected")
                    .font(.title2.bold())
                Text(vm.latest?.bssid ?? "—")
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(role: .none) { vm.samples.removeAll() } label: {
                Label("Clear", systemImage: "trash")
            }
            .help("Clear history")
        }
    }

    private var summaryGrid: some View {
        let rssi = vm.latest?.rssi.map { "\($0) dBm" } ?? "—"
        let noise = vm.latest?.noise.map { "\($0) dBm" } ?? "—"
        let snr = vm.latest?.snr.map { "\($0) dB" } ?? "—"
        let rate = vm.latest?.txRate.map { String(format: "%.0f Mbps", $0) } ?? "—"
        let channel = vm.latest?.channel ?? "—"
        let mcs = vm.latest?.mcs.map { "MCS \($0)" }
        let nss = vm.latest?.nss.map { "NSS \($0)" }
        let mcsNss = [mcs, nss].compactMap { $0 }.joined(separator: " · ")

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
            MetricCard(title: "RSSI", value: rssi, subtitle: "Signal", color: .blue)
            MetricCard(title: "Noise", value: noise, subtitle: "Background", color: .gray)
            MetricCard(title: "SNR", value: snr, subtitle: "RSSI − Noise", color: .indigo)
            MetricCard(title: "TX Rate", value: rate, subtitle: "Link speed", color: .green)
            MetricCard(title: "Channel", value: channel, subtitle: "Primary", color: .orange)
            MetricCard(title: "MCS/NSS", value: mcsNss.isEmpty ? "—" : mcsNss, subtitle: "Modulation/Streams", color: .purple)
        }
    }

    private var chartsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Charts")
                .font(.title3.bold())
            SignalChart(rssi: vm.rssiSeries, noise: vm.noiseSeries, snr: vm.snrSeries)
                .frame(height: 220)
                .background(.background.quaternary, in: .rect(cornerRadius: 12))
            RateChart(rate: vm.rateSeries)
                .frame(height: 220)
                .background(.background.quaternary, in: .rect(cornerRadius: 12))
        }
    }

    private var tableSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("History")
                .font(.title3.bold())
            SamplesTable(samples: vm.samples)
                .frame(minHeight: 240)
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Picker("Interval", selection: $vm.interval) {
                ForEach(PollInterval.allCases) { p in
                    Text(p.label).tag(p)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 200)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WiFiMonitorViewModel())
    }
}
