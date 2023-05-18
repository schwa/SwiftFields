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

//            Canvas { context, _ in
//                let segments = PathSegments(path: path, segments: 100)
//                for segment in segments.segments {
//                    let radius: CGFloat = 1
//                    context.fill(Path(ellipseIn: CGRect(x: segment.x - radius, y: segment.y - radius, width: radius * 2, height: radius * 2)), with: .color(.red))
//                }
//            }

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

internal struct DistanceOnPathSlider <Thumb>: View where Thumb: View {
    private let path: Path
    private let thumb: Thumb

    @Binding
    private var value: Double

    private let segments: PathSegments

    init(value: Binding<Double>, path: Path, segments: Int = 100, thumb: () -> Thumb) {
        self._value = value
        self.path = path
        self.thumb = thumb()
        self.segments = PathSegments(path: path, segments: segments)
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

