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
        let halfThumbSize = CGSize(width: geometry.thumbSize.width * 0.5, height: geometry.thumbSize.height * 0.5)
        switch axis {
        case .horizontal:
            GeometryReader { proxy in
                let trackPath = Path.line(
                    from:CGPoint(x: geometry.trackWidth / 2, y: halfThumbSize.height),
                    to: CGPoint(x: proxy.size.width - geometry.trackWidth / 2, y: halfThumbSize.height)
                )
                let thumbPath = Path.line(
                    from:CGPoint(x: halfThumbSize.width, y: halfThumbSize.height),
                    to: CGPoint(x: proxy.size.width - halfThumbSize.width, y: halfThumbSize.height)
                )
                PathSlider(value: _value, in: limit, trackPath: trackPath, thumbPath: thumbPath)
            }
            .frame(height: geometry.thumbSize.height)
            .frame(minWidth: geometry.thumbSize.width)
        case .vertical:
            GeometryReader { proxy in
                let trackPath = Path.line(
                    from:CGPoint(x: halfThumbSize.width, y: proxy.size.height - geometry.trackWidth / 2),
                    to: CGPoint(x: halfThumbSize.width, y: geometry.trackWidth / 2)
                )
                let thumbPath = Path.line(
                    from: CGPoint(x: halfThumbSize.width, y: proxy.size.height - halfThumbSize.height),
                    to: CGPoint(x: halfThumbSize.width, y: halfThumbSize.height)
                )
                PathSlider(value: _value, in: limit, trackPath: trackPath, thumbPath: thumbPath)
            }
            .frame(width: geometry.thumbSize.width)
            .frame(minHeight: geometry.thumbSize.height)
        }
    }
}

struct YASlider_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            trio.controlSize(.mini)
            trio.controlSize(.small)
            trio.controlSize(.regular)
            trio.controlSize(.large)
        }
    }

    static var trio: some View {
        VStack {
            HStack {
                YASlider(value: .constant(0), in: 0 ... 1, axis: .horizontal)
                YASlider(value: .constant(0.5), in: 0 ... 1, axis: .horizontal)
                YASlider(value: .constant(1), in: 0 ... 1, axis: .horizontal)
            }
            HStack {
                Slider(value: .constant(0), in: 0 ... 1)
                Slider(value: .constant(0.5), in: 0 ... 1)
                Slider(value: .constant(1), in: 0 ... 1)
            }
        }
        .frame(height: 100)
    }
}
