import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Haul] = []
    @Published var isPro: Bool = false

    // Free-tier limit is intentionally well above the seed data count (3)
    // so a fresh install never hits the paywall immediately.
    static let freeLimit = 40

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("thrifthaul_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Haul) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Haul) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Haul) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Haul].self, from: data) {
            items = decoded
        } else {
            items = Self.seedData()
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static func seedData() -> [Haul] {
        [
            Haul(item: "Sample A", store: "Sample A", price: 12.5, retailEstimate: 12.5, date: Date().addingTimeInterval(-259200)),
            Haul(item: "Sample B", store: "Sample B", price: 8.0, retailEstimate: 8.0, date: Date().addingTimeInterval(-518400)),
            Haul(item: "Sample C", store: "Sample C", price: 21.75, retailEstimate: 21.75, date: Date().addingTimeInterval(-777600))
        ]
    }
}
