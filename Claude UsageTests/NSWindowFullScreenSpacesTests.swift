import XCTest
import AppKit
@testable import Claude_Usage

final class NSWindowFullScreenSpacesTests: XCTestCase {

    // MARK: - Space Membership

    func testEnableDisplayJoinsAllSpacesAndFullScreenSpaces() {
        let window = makeWindow()
        window.collectionBehavior = []

        window.enableDisplayOnFullScreenSpaces()

        XCTAssertTrue(window.collectionBehavior.contains(.canJoinAllSpaces))
        XCTAssertTrue(window.collectionBehavior.contains(.fullScreenAuxiliary))
    }

    func testEnableDisplayClearsMoveToActiveSpace() {
        let window = makeWindow()
        window.collectionBehavior = [.moveToActiveSpace]

        window.enableDisplayOnFullScreenSpaces()

        // .moveToActiveSpace conflicts with .canJoinAllSpaces, so it must not survive.
        XCTAssertFalse(window.collectionBehavior.contains(.moveToActiveSpace))
        XCTAssertTrue(window.collectionBehavior.contains(.canJoinAllSpaces))
    }

    func testEnableDisplayDoesNotRequestMoveToActiveSpace() {
        let window = makeWindow()
        window.collectionBehavior = []

        window.enableDisplayOnFullScreenSpaces()

        XCTAssertFalse(window.collectionBehavior.contains(.moveToActiveSpace))
    }

    func testEnableDisplayPreservesUnrelatedCollectionBehavior() {
        let window = makeWindow()
        window.collectionBehavior = [.ignoresCycle, .stationary]

        window.enableDisplayOnFullScreenSpaces()

        XCTAssertTrue(window.collectionBehavior.contains(.ignoresCycle))
        XCTAssertTrue(window.collectionBehavior.contains(.stationary))
    }

    // MARK: - Idempotence

    func testEnableDisplayIsIdempotent() {
        let window = makeWindow()
        window.collectionBehavior = [.ignoresCycle]

        window.enableDisplayOnFullScreenSpaces()
        let behaviorAfterFirstCall = window.collectionBehavior

        window.enableDisplayOnFullScreenSpaces()

        XCTAssertEqual(window.collectionBehavior, behaviorAfterFirstCall)
    }

    // MARK: - Helpers

    private func makeWindow() -> NSWindow {
        // defer: true keeps the window device from being created — these tests only
        // exercise the window's Spaces behavior.
        NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 100, height: 100),
            styleMask: [.borderless],
            backing: .buffered,
            defer: true
        )
    }
}
