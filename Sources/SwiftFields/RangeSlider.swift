import SwiftUI

public struct ClosedRangeSlider: View {
    @Binding
    var value: ClosedRange<Double>

    public init(value: Binding<ClosedRange<Double>>) {
        self._value = value
    }

    public var body: some View {

        let lowerBound = Binding {
            return value.lowerBound
        } set: { newValue in
            value = min(newValue, value.upperBound) ... value.upperBound
        }
        let upperBound = Binding {
            return value.upperBound
        } set: { newValue in
            value = value.lowerBound ... max(newValue, value.lowerBound)
        }
        GeometryReader { proxy in
            let linePath = Path.line(from: CGPoint(x: 5, y: 10), to: CGPoint(x: proxy.size.width - 5, y: 10))
            let path = Path.line(from: CGPoint(x: 10, y: 10), to: CGPoint(x: proxy.size.width - 10, y: 10))
            ZStack {
                linePath.trimmedPath(from: 0, to: 1).stroke(Color(white: 0.87), style: .init(lineWidth: 4, lineCap: .round))
                linePath.trimmedPath(from: value.lowerBound, to: value.upperBound).stroke(Color.accentColor, style: .init(lineWidth: 4, lineCap: .round))

                DistanceOnPathSlider(value: lowerBound, path: path) {
                    ZStack {
                        let shape = ArcShape(angle: .degrees(180), width: .degrees(180))
                        shape.fill(Color.white)
                        shape.stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                    }
                    .frame(width: 20, height: 20)
                }
                DistanceOnPathSlider(value: upperBound, path: path) {
                    ZStack {
                        let shape = ArcShape(angle: .degrees(0), width: .degrees(180))
                        shape.fill(Color.white)
                        shape.stroke(Color.black.opacity(0.1), lineWidth: 0.5)
                    }
                    .frame(width: 20, height: 20)
                }
            }
        }
        .frame(height: 20)
    }

}
