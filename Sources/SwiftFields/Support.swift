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

    // swiftlint:disable:next function_parameter_count
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

    static func horizontalLine(from: CGFloat, to: CGFloat) -> Path {
        return Path { path in
            path.addLines([CGPoint(x: from, y: 0), CGPoint(x: to, y: 0)])
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
            fatalError("No segments.")
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

internal extension Color {
    static let sliderBackground = Color(white: 0.875)
}

internal struct Thumb <S>: View where S: Shape {
    let shape: S

    init(_ shape: () -> S) {
        self.shape = shape()
    }

    var body: some View {
        ZStack {
            shape.fill(Color.white).shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.05), radius: 0.5, y: 2)
            shape.stroke(Color.sliderBackground)
        }
    }
}

public struct PathSliderGeometry {
    public var thumbSize: CGSize
    public var trackWidth: CGFloat

    #if os(tvOS)
    static let tvOS = PathSliderGeometry(thumbSize: CGSize(width: 20, height: 20), trackWidth: 4)
    #else
    public init(_ controlSize: ControlSize) {
        switch controlSize {
        case .mini:
            thumbSize = CGSize(width: 14, height: 14)
            trackWidth = 3
        case .small:
            thumbSize = CGSize(width: 16, height: 16)
            trackWidth = 3
        case .regular:
            thumbSize = CGSize(width: 20, height: 20)
            trackWidth = 4
        case .large:
            thumbSize = CGSize(width: 20, height: 20)
            trackWidth = 4
        case .extraLarge:
            thumbSize = CGSize(width: 20, height: 20)
            trackWidth = 4
        @unknown default:
            thumbSize = CGSize(width: 20, height: 20)
            trackWidth = 4
        }
    }
    #endif
}

#if !os(tvOS)
internal extension ControlSize {
    var pathSliderGeometry: PathSliderGeometry {
        return PathSliderGeometry(self)
    }
}
#endif

internal struct LineSegment: Equatable {
    var from: CGPoint
    var to: CGPoint

    init(from: CGPoint, to: CGPoint) {
        self.from = from
        self.to = to
    }
}

internal extension LineSegment {

    init(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat) {
        self.init(from: CGPoint(x: x1, y: y1), to: CGPoint(x: x2, y: y2))
    }

    init(x: CGFloat, from y1: CGFloat, to y2: CGFloat) {
        self.init(from: CGPoint(x: x, y: y1), to: CGPoint(x: x, y: y2))
    }

    init(y: CGFloat, from x1: CGFloat, to x2: CGFloat) {
        self.init(from: CGPoint(x: x1, y: y), to: CGPoint(x: x2, y: y))
    }

    init(axis: Axis, from: CGFloat, to: CGFloat) {
        switch axis {
        case .horizontal:
            self.init(from: CGPoint(x: from, y: 0), to: CGPoint(x: to, y: 0))
        case .vertical:
            self.init(from: CGPoint(x: 0, y: from), to: CGPoint(x: 0, y: to))
        }
    }

    var boundingRect: CGRect {
        return CGRect(x: min(from.x, to.x), y: min(from.y, to.y), width: abs(from.x - to.x), height: abs(from.y - to.y))
    }

    func insetBy(dx: CGFloat = 0, dy: CGFloat = 0) -> LineSegment {
        var copy = self
        if from.x <= to.x {
            copy.from.x += dx
            copy.to.x -= dx
        }
        else {
            copy.from.x -= dx
            copy.to.x += dx
        }
        if from.y <= to.y {
            copy.from.y += dy
            copy.to.y -= dy
        }
        else {
            copy.from.y -= dy
            copy.to.y += dy
        }
        return copy
    }

    func insetBy(_ point: CGPoint) -> LineSegment {
        insetBy(dx: point.x, dy: point.y)
    }

    func offsetBy(dx: CGFloat = 0, dy: CGFloat = 0) -> LineSegment {
        var copy = self
        copy.from.x += dx
        copy.from.y += dy
        copy.to.x += dx
        copy.to.y += dy
        return copy
    }

    func offsetBy(_ point: CGPoint) -> LineSegment {
        offsetBy(dx: point.x, dy: point.y)
    }
}

internal extension Path {
    init(_ lineSegment: LineSegment) {
        self = Path { path in
            path.addLines([lineSegment.from, lineSegment.to])
        }
    }
}

internal extension CGPoint {
    init(axis: Axis, length: CGFloat) {
        switch axis {
        case .horizontal:
            self.init(x: length, y: 0)
        case .vertical:
            self.init(x: 0, y: length)
        }
    }
}

internal extension LineSegment {
    func flipped() -> LineSegment {
        return LineSegment(from: to, to: from)
    }
}

internal extension Axis {
    static prefix func !(value: Self) -> Axis {
        switch value {
        case .horizontal:
            return .vertical
        case .vertical:
            return .horizontal
        }
    }
}
