import Foundation

/// A service that reads current Wi‑Fi stats using Apple's private `airport` CLI.
/// Path: /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
final class WiFiService {
    private let airportPath = "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

    func fetchCurrentSample(date: Date = Date()) -> WiFiSample? {
        guard FileManager.default.isExecutableFile(atPath: airportPath) else { return nil }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: airportPath)
        process.arguments = ["-I"]

        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()

        do {
            try process.run()
        } catch {
            return nil
        }

        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8), !output.isEmpty else { return nil }

        let dict = parseAirport(output: output)

        let ssid = dict["SSID"]
        let bssid = dict["BSSID"]
        let channel = dict["channel"]

        let rssi = dict["agrCtlRSSI"].flatMap { Int($0) }
        let noise = dict["agrCtlNoise"].flatMap { Int($0) }
        let txRate = dict["lastTxRate"].flatMap { Double($0) }

        // Advanced (may be missing)
        let mcs = (dict["MCS"] ?? dict["MCS index"])?.trimmingCharacters(in: .whitespaces).flatMap { Int($0) }
        let nss = dict["NSS"].flatMap { Int($0) }

        return WiFiSample(
            timestamp: date,
            ssid: ssid,
            bssid: bssid,
            channel: channel,
            rssi: rssi,
            noise: noise,
            txRate: txRate,
            mcs: mcs,
            nss: nss
        )
    }

    private func parseAirport(output: String) -> [String: String] {
        var result: [String: String] = [:]
        output.split(separator: "\n").forEach { lineSub in
            let line = String(lineSub)
            guard let range = line.range(of: ":") else { return }
            let key = String(line[..<range.lowerBound]).trimmingCharacters(in: .whitespaces)
            var value = String(line[range.upperBound...]).trimmingCharacters(in: .whitespaces)
            // Normalize channel like "157,1" to "157" for display
            if key == "channel", let comma = value.firstIndex(of: ",") {
                value = String(value[..<comma])
            }
            result[key] = value
        }
        return result
    }
}
