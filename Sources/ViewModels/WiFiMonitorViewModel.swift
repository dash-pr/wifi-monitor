import Foundation
import SwiftUI

enum PollInterval: Int, CaseIterable, Identifiable {
    case one = 1
    case two = 2
    case five = 5

    var id: Int { rawValue }
    var label: String { "\(rawValue)s" }
}

@MainActor
final class WiFiMonitorViewModel: ObservableObject {
    @Published var samples: [WiFiSample] = []
    @Published var interval: PollInterval = .one

    private let service = WiFiService()
    private var task: Task<Void, Never>?
    private let maxSamples = 900 // keep ~15 minutes at 1s

    var latest: WiFiSample? { samples.last }

    func start() {
        stop()
        task = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                await self.pollOnce()
                let nanos = UInt64(self.interval.rawValue) * 1_000_000_000
                try? await Task.sleep(nanoseconds: nanos)
            }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
    }

    func setInterval(_ newInterval: PollInterval) {
        interval = newInterval
        // No need to restart; the loop reads `interval` each cycle for sleep duration.
    }

    private func pollOnce() async {
        // Fetch off the main actor
        let sample = await withCheckedContinuation { (continuation: CheckedContinuation<WiFiSample?, Never>) in
            DispatchQueue.global(qos: .utility).async {
                let s = self.service.fetchCurrentSample()
                continuation.resume(returning: s)
            }
        }
        if let sample {
            samples.append(sample)
            if samples.count > maxSamples {
                samples.removeFirst(samples.count - maxSamples)
            }
        }
    }

    // MARK: - Chart series helpers
    struct MetricPoint: Identifiable {
        let id = UUID()
        let time: Date
        let value: Double
    }

    var rssiSeries: [MetricPoint] {
        samples.compactMap { s in s.rssi.map { MetricPoint(time: s.timestamp, value: Double($0)) } }
    }

    var noiseSeries: [MetricPoint] {
        samples.compactMap { s in s.noise.map { MetricPoint(time: s.timestamp, value: Double($0)) } }
    }

    var snrSeries: [MetricPoint] {
        samples.compactMap { s in s.snr.map { MetricPoint(time: s.timestamp, value: Double($0)) } }
    }

    var rateSeries: [MetricPoint] {
        samples.compactMap { s in s.txRate.map { MetricPoint(time: s.timestamp, value: $0) } }
    }
}
