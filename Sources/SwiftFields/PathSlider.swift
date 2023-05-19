import SwiftUI

public struct PathSlider: View {
    @Binding
    private var value: Double

    @Environment(\.controlSize)
    var controlSize

#if os(macOS)
    @Environment(\.controlActiveState)
    var controlActiveState
#endif

    @Environment(\.scenePhase)
    var scenePhase

    private let range: ClosedRange<Double>
    private let trackPath: Path
    private let thumbPath: Path

    public init(value: Binding<Double>, in range: ClosedRange<Double> = 0 ... 1, trackPath: Path, thumbPath: Path) {
        self._value = value
        self.range = range
        self.trackPath = trackPath
        self.thumbPath = thumbPath
    }

    private var geometry: PathSliderGeometry {
        return controlSize.pathSliderGeometry
    }

    private var binding: Binding<Double> {
        Binding {
            return (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        } set: { newValue in
            value = newValue * (range.upperBound - range.lowerBound) + range.lowerBound
        }
    }

    public var body: some View {
        ZStack {
            trackPath.stroke(Color.sliderBackground, style: .init(lineWidth: geometry.trackWidth, lineCap: .round))
            //trackPath.stroke(.shadow(.inner(color: .pink.opacity(0.0), radius: 1)), style: .init(lineWidth: geometry.trackWidth, lineCap: .round))
            trackPath.trimmedPath(from: 0, to: binding.wrappedValue).stroke(activeTrackColor, style: .init(lineWidth: geometry.trackWidth, lineCap: .round))
            PathSliderHelper(value: binding, path: thumbPath) {
                Thumb {
                    Circle()
                }
                .frame(width: geometry.thumbSize.width, height: geometry.thumbSize.height)
#if os(macOS)
                .accessibilityElement()
                .accessibilityValue("\(value, format: .number)")
#endif
            }
        }
#if os(iOS)
        .accessibilityRepresentation(representation: {
            Slider(value: $value, in: range)
        })
#elseif os(macOS)
        .accessibilityElement(children: .contain)
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                value += (range.upperBound / range.lowerBound) / 10
            case .decrement:
                value -= (range.upperBound / range.lowerBound) / 10
            @unknown default:
                break
            }
        }
        .accessibilityCustomContent(AccessibilityCustomContentKey(Text("FOO"), id: "FOO"), Text("FOO"))
#endif
    }

    var activeTrackColor: Color {
#if os(macOS)
        switch controlActiveState {
        case .active, .key:
            return .accentColor
        case .inactive:
            return .sliderBackground
        @unknown default:
            return .accentColor
        }
#else
        return .accentColor
#endif
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

struct PathSlider_Preview: PreviewProvider {
    static var previews: some View {
        PathSlider(value: .constant(0), trackPath: Path.horizontalLine(from: 0, to: 100).offsetBy(dx: 0, dy: 10), thumbPath: Path.horizontalLine(from: 10, to: 90).offsetBy(dx: 0, dy: 10))
            .frame(width: 100, height: 20)
    }
}
