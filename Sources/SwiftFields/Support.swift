import SwiftUI

internal struct ArcShape: SwiftUI.Shape {
    let angle: SwiftUI.Angle
    let width: SwiftUI.Angle

    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2
            let startAngle = Angle.radians(angle.radians - width.radians / 2)
            let endAngle = Angle.radians(angle.radians + width.radians / 2)
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            path.closeSubpath()
        }
    }
}

internal extension CGPoint {
    func rotated(by angle: SwiftUI.Angle) -> CGPoint {
        applying(CGAffineTransform(rotationAngle: angle.radians))
    }

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

internal extension Path {
    static func circle(center: CGPoint, radius: CGFloat) -> Path {
        return Path(ellipseIn: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
    }

    static func arc(center: CGPoint, radius: CGFloat, startAngle: Angle, endAngle: Angle, clockwise: Bool, closed: Bool) -> Path {
        if endAngle.degrees - startAngle.degrees >= 360 {
            return .circle(center: center, radius: radius)
        }

        return Path { path in
            if closed {
                path.move(to: center)
            }
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
            if closed {
                path.closeSubpath()
            }
        }
    }

    static func line(from: CGPoint, to: CGPoint) -> Path {
        return Path { path in
            path.addLines([from, to])
        }
    }
}

internal extension CGPoint {
    func distanceSquared(to other: CGPoint) -> CGFloat {
        (x - other.x) * (x - other.x) + (y - other.y) * (y - other.y)
    }
}

internal extension Path {
    var startPoint: CGPoint? {
        let r = trimmedPath(from: 0, to: 0.00001).boundingRect
        return CGPoint(x: r.midX, y: r.midY)
    }
}

internal struct PathSegments {
    let segments: [CGPoint]

    init(path: Path, segments: Int) {
        assert(segments > 0)
        self.segments =
        [path.startPoint!]
        + (0 ..< segments).reduce(into: []) { partialResult, segment in
            let from = Double(segment) / Double(segments)
            let to = Double(segment + 1) / Double(segments)

            let rect = path.trimmedPath(from: from, to: to).boundingRect
            partialResult.append(CGPoint(x: rect.midX, y: rect.midY))
        }
        + [ path.currentPoint! ]
    }

    func value(for point: CGPoint) -> Double {
        guard let firstSegment = segments.first else {
            fatalError()
        }
        var lowestDistance = firstSegment.distanceSquared(to: point)
        var closestSegmentIndex = 0
        segments.enumerated().dropFirst().forEach { index, segment in
            let distance = segment.distanceSquared(to: point)
            if distance < lowestDistance {
                lowestDistance = distance
                closestSegmentIndex = index
            }
        }
        return Double(closestSegmentIndex) / Double(segments.count - 1)
    }

    func segment(for value: Double) -> CGPoint {
        return segments[min(Int(value * Double(segments.count)), segments.count - 1)]
    }
}
