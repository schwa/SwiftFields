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
            path.trimmedPath(from: binding.wrappedValue, to: 1).stroke(Color.sliderBackground, lineWidth: 4)
            path.trimmedPath(from: 0, to: binding.wrappedValue).stroke(Color.accentColor, lineWidth: 4)

            PathSliderHelper(value: binding, path: path) {
                Thumb {
                    Circle()
                }
                .frame(width: 20, height: 20)
            }
        }
        .frame(width: max(path.boundingRect.width, 20), height: max(path.boundingRect.height, 20))
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

