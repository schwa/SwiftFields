import SwiftUI

public struct YASlider: View {
    @Binding
    private var value: Double

    @Environment(\.controlSize)
    private var controlSize

    private let limit: ClosedRange<Double>
    private let axis: Axis

    public init(value: Binding<Double>, in limit: ClosedRange<Double> = 0 ... 1, axis: Axis) {
        self._value = value
        self.limit = limit
        self.axis = axis
    }

    public var body: some View {
        let geometry = controlSize.pathSliderGeometry
        switch axis {
        case .horizontal:
            GeometryReader { proxy in
                let (trackPath, thumbPath) = paths(for: proxy.size)
                PathSlider(value: _value, in: limit, trackPath: trackPath, thumbPath: thumbPath)
            }
            .frame(height: geometry.thumbSize.height)
            .frame(minWidth: geometry.thumbSize.width)
        case .vertical:
            GeometryReader { proxy in
                let (trackPath, thumbPath) = paths(for: proxy.size)
                PathSlider(value: _value, in: limit, trackPath: trackPath, thumbPath: thumbPath)
            }
            .frame(width: geometry.thumbSize.width)
            .frame(minHeight: geometry.thumbSize.height)
        }
    }

    private func paths(for size: CGSize) -> (trackPath: Path, thumbPath: Path) {
        let geometry = controlSize.pathSliderGeometry
        let halfThumbSize = CGSize(width: geometry.thumbSize.width * 0.5, height: geometry.thumbSize.height * 0.5)
        switch axis {
        case .horizontal:
            let length = size.width
            let trackPath = LineSegment(y: 0, from: 0, to: length)
                .insetBy(dx: geometry.trackWidth / 2)
                .offsetBy(dy: halfThumbSize.height)
            let thumbPath = LineSegment(y: 0, from: 0, to: length)
                .insetBy(dx: halfThumbSize.width)
                .offsetBy(dy: halfThumbSize.height)
            return (trackPath: Path(trackPath), thumbPath: Path(thumbPath))

        case .vertical:
            let length = size.height
            let trackPath = LineSegment(x: 0, from: length, to: 0)
                .insetBy(dy: geometry.trackWidth / 2)
                .offsetBy(dx: halfThumbSize.height)
            let thumbPath = LineSegment(x: 0, from: length, to: 0)
                .insetBy(dy: halfThumbSize.width)
                .offsetBy(dx: halfThumbSize.height)
            return (trackPath: Path(trackPath), thumbPath: Path(thumbPath))
        }
    }
}

// MARK: -

struct YASlider_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            YASlider(value: .constant(0.5), axis: .horizontal)
            YASlider(value: .constant(0.5), axis: .vertical).frame(height: 50)
        }
    }
}
