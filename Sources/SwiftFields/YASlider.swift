#if !os(tvOS)
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
        GeometryReader { proxy in
            let (trackPath, thumbPath) = paths(for: proxy.size)
            PathSlider(value: _value, in: limit, trackPath: trackPath, thumbPath: thumbPath)
        }
        .frame(width: axis == .vertical ? geometry.thumbSize.height : nil, height: axis == .horizontal ? geometry.thumbSize.height : nil)
        .frame(minWidth: axis == .horizontal ? geometry.thumbSize.width : nil, minHeight: axis == .vertical ? geometry.thumbSize.height : nil)
    }

    private func paths(for size: CGSize) -> (trackPath: Path, thumbPath: Path) {
        let geometry = controlSize.pathSliderGeometry
        let halfThumbSize = CGSize(width: geometry.thumbSize.width * 0.5, height: geometry.thumbSize.height * 0.5)
        let length = axis == .horizontal ? size.width : size.height
        var line = LineSegment(axis: axis, from: 0, to: length)
        if axis == .vertical {
            line = line.flipped()
        }
        let trackPath = line
            .insetBy(CGPoint(axis: axis, length: geometry.trackWidth / 2))
            .offsetBy(CGPoint(axis: !axis, length: halfThumbSize.height))
        let thumbPath = line
            .insetBy(CGPoint(axis: axis, length: halfThumbSize.width))
            .offsetBy(CGPoint(axis: !axis, length: halfThumbSize.height))
        return (trackPath: Path(trackPath), thumbPath: Path(thumbPath))
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
#endif
