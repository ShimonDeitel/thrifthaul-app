import XCTest
@testable import Thrifthaul

@MainActor
final class ThrifthaulTests: XCTestCase {
    func testSeedDataLoadsBelowFreeLimit() {
        let store = Store()
        XCTAssertLessThan(store.items.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.items.count
        store.add(Haul())
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let store = Store()
        let item = Haul()
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(where: { $0.id == item.id }))
    }

    func testUpdateModifiesItem() {
        let store = Store()
        var item = Haul()
        store.add(item)
        item.createdAt = Date.distantPast
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.createdAt, Date.distantPast)
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = Store()
        store.isPro = false
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWhenFree() {
        let store = Store()
        store.isPro = false
        store.items = (0..<Store.freeLimit).map { _ in Haul() }
        XCTAssertFalse(store.canAddMore)
    }

    func testProUsersAlwaysCanAddMore() {
        let store = Store()
        store.isPro = true
        store.items = (0..<(Store.freeLimit + 10)).map { _ in Haul() }
        XCTAssertTrue(store.canAddMore)
    }

    func testDeleteAtOffsets() {
        let store = Store()
        store.items = []
        store.add(Haul())
        store.add(Haul())
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }
}
