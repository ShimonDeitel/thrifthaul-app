import Foundation

struct Haul: Identifiable, Codable, Equatable {
    let id: UUID
    var item: String
    var store: String
    var price: Double
    var retailEstimate: Double
    var date: Date
    var createdAt: Date

    init(id: UUID = UUID(), item: String = "", store: String = "", price: Double = 0, retailEstimate: Double = 0, date: Date = Date(), createdAt: Date = Date()) {
        self.id = id
        self.item = item
        self.store = store
        self.price = price
        self.retailEstimate = retailEstimate
        self.date = date
        self.createdAt = createdAt
    }
}
