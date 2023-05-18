import SwiftUI

public struct PathSlider: View {
    @Binding
    private var value: Double

    @Environment(\.controlSize)
    var controlSize

    private let range: ClosedRange<Double>
    private let trackPath: Path
    private let thumbPath: Path

    public init(value: Binding<Double>, in range: ClosedRange<Double> = 0 ... 1, trackPath: Path, thumbPath: Path) {
        self._value = value
        self.range = range
        self.trackPath = trackPath
        self.thumbPath = thumbPath
    }

    public var body: some View {
        return ZStack {
            let geometry = controlSize.pathSliderGeometry
            let binding = Binding {
                return (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            } set: { newValue in
                value = newValue * (range.upperBound - range.lowerBound) + range.lowerBound
            }
            trackPath.stroke(Color.sliderBackground, style: .init(lineWidth: geometry.trackWidth, lineCap: .round))
            trackPath.trimmedPath(from: 0, to: binding.wrappedValue).stroke(Color.accentColor, style: .init(lineWidth: geometry.trackWidth, lineCap: .round))

            PathSliderHelper(value: binding, path: thumbPath) {
                Thumb {
                    Circle()
                }
                .frame(width: geometry.thumbSize.width, height: geometry.thumbSize.height)
            }
        }
    }
}

public extension PathSlider {
    init(value: Binding<Double>, in range: ClosedRange<Double> = 0 ... 1, path: Path) {
        self.init(value: value, in: range, trackPath: path, thumbPath: path)
    }
}

// MARK: -

internal struct PathSliderHelper <Thumb>: View where Thumb: View {
    @Binding
    private var value: Double

    private let path: Path
    private let segments: PathSegments
    private let thumb: Thumb

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
