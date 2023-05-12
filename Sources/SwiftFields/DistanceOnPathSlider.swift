import SwiftUI

public struct PathSlider: View {

    @Binding
    private var value: Double

    private let range: ClosedRange<Double>

    private let path: Path

    public init(value: Binding<Double>, in range: ClosedRange<Double> = 0 ... 1, path: Path) {
        self._value = value
        self.range = range
        self.path = path
    }

    public var body: some View {
        ZStack {
            let binding = Binding {
                return (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            } set: { newValue in
                value = newValue * (range.upperBound - range.lowerBound) + range.lowerBound
            }
            path.trimmedPath(from: binding.wrappedValue, to: 1).stroke(Color.black.opacity(0.1), lineWidth: 4)
            path.trimmedPath(from: 0, to: binding.wrappedValue).stroke(Color.accentColor, lineWidth: 4)

            Canvas { context, size in
                let segments = PathSegments(path: path, segments: 100)
                for segment in segments.segments {
                    let radius: CGFloat = 1
                    context.fill(Path(ellipseIn: CGRect(x: segment.x - radius, y: segment.y - radius, width: radius * 2, height: radius * 2)), with: .color(.red))
                }

            }



            DistanceOnPathSlider(value: binding, path: path) {
                ZStack {
                    Circle().fill(Color.white)
                    Circle().stroke(Color.black.opacity(0.1))
                }
                .frame(width: 20, height: 20)
            }
        }
        .frame(width: max(path.boundingRect.width, 20), height: max(path.boundingRect.height, 20))
    }

}

// MARK: -

struct DistanceOnPathSlider <Thumb>: View where Thumb: View {

    private let path: Path
    private let thumb: Thumb

    @Binding
    private var value: Double

    private let segments: PathSegments

    init(value: Binding<Double>, path: Path, thumb: () -> Thumb) {
        self._value = value
        self.path = path
        self.thumb = thumb()
        self.segments = PathSegments(path: path, segments: 10)
    }

    var body: some View {
        thumb.position(segments.segment(for: value)).gesture(thumbDragGesture)
    }

    private var thumbDragGesture: some Gesture {
        DragGesture().onChanged { value in
            self.value = segments.value(for: value.location)
        }
    }
}


struct PathSegments {
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

extension CGPoint {
    func distanceSquared(to other: CGPoint) -> CGFloat {
        (x - other.x) * (x - other.x) + (y - other.y) * (y - other.y)
    }
}

extension Path {
    var startPoint: CGPoint? {
        let r = trimmedPath(from: 0, to: 0.00001).boundingRect
        print(r)
        return CGPoint(x: r.midX, y: r.midY)
    }
}
