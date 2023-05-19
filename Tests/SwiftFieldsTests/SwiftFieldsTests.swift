import XCTest
@testable import SwiftFields

final class LineSegmentTest: XCTestCase {
    func test1() throws {
        let l1 = LineSegment(x1: 0, y1: 0, x2: 10, y2: 0).insetBy(dx: 2.5, dy: 0)
        XCTAssertEqual(l1, LineSegment(x1: 2.5, y1: 0, x2: 7.5, y2: 0))
        let l2 = LineSegment(x1: 0, y1: 0, x2: 10, y2: 0).insetBy(dx: -1, dy: 0)
        XCTAssertEqual(l2, LineSegment(x1: -1, y1: 0, x2: 11, y2: 0))

        let r1 = LineSegment(x1: 0, y1: 0, x2: 10, y2: 10).boundingRect
        XCTAssertEqual(r1, CGRect(x: 0, y: 0, width: 10, height: 10))
        let r2 = LineSegment(x1: 5, y1: -5, x2: 10, y2: 10).boundingRect
        XCTAssertEqual(r2, CGRect(x: 5, y: -5, width: 5, height: 15))

    }
}
