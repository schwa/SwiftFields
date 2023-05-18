import SwiftUI

public struct VerticalSlider: View {
    @Binding
    private var value: Double

    @Environment(\.controlSize)
    private var controlSize

    private let limit: ClosedRange<Double>

    public init(value: Binding<Double>, in limit: ClosedRange<Double>) {
        self._value = value
        self.limit = limit
    }

    public var body: some View {
        let geometry = controlSize.pathSliderGeometry
        GeometryReader { proxy in
            let halfThumbSize = CGSize(width: geometry.thumbSize.width * 0.5, height: geometry.thumbSize.height * 0.5)
            let trackPath = Path.line(
                from:CGPoint(x: halfThumbSize.width, y: proxy.size.height - 2),
                to: CGPoint(x: halfThumbSize.width, y: 2)
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

struct VerticalSlider_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            trio.controlSize(.mini)
            trio.controlSize(.small)
            trio.controlSize(.regular)
            trio.controlSize(.large)
        }
    }

    static var trio: some View {
        HStack {
            VerticalSlider(value: .constant(0), in: 0 ... 1)
            VerticalSlider(value: .constant(0.5), in: 0 ... 1)
            VerticalSlider(value: .constant(1), in: 0 ... 1)
        }
        .frame(height: 100)
    }
}
