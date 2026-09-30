import Foundation

struct WiFiSample: Identifiable, Hashable {
    let id = UUID()
    let timestamp: Date

    // Identity
    let ssid: String?
    let bssid: String?
    let channel: String?

    // Signal/quality
    let rssi: Int?
    let noise: Int?
    let txRate: Double?

    // Advanced
    let mcs: Int?
    let nss: Int?

    var snr: Int? {
        if let rssi, let noise { return rssi - noise }
        return nil
    }
}
