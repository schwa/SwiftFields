import SwiftFormats
import SwiftUI

// https://mastodon.social/@ikenndac/110316785167632103

public struct AngleEditor: View {
    @Binding
    var angle: Angle

    @Environment(\.controlSize)
    var controlSize

    let limit: ClosedRange<Angle>

    public init(angle: Binding<Angle>, limit: ClosedRange<Angle> = .degrees(0) ... .degrees(360)) {
        self._angle = angle
        self.limit = limit
    }

    public var body: some View {
        let width: CGFloat
        let borderWidth: CGFloat
        let edgeWidth: CGFloat
        switch controlSize {
        case .mini:
            width = 32
            borderWidth = 1
            edgeWidth = 1
        case .small:
            width = 40
            borderWidth = 2
            edgeWidth = 2
        case .regular:
            width = 64
            borderWidth = 2
            edgeWidth = 2
        case .large:
            width = 80
            borderWidth = 4
            edgeWidth = 3
        @unknown default:
            width = 64
            borderWidth = 4
            edgeWidth = 2
        }
        let shadowRadius = 1.0
        let color = Color.red

        return VStack {
            TextField("Angle", value: $angle.degrees, format: .number)
            Slider(value: $angle.degrees, in: limit.lowerBound.degrees ... limit.upperBound.degrees)
            Canvas { context, size in
                context.drawLayer { context in
                    let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
                    let radius = min(size.width, size.height) / 2 - borderWidth - shadowRadius

                    let startLimitAngle = Angle(degrees: limit.lowerBound.degrees - 90)
                    let endLimitAngle = Angle(degrees: limit.upperBound.degrees - 90)

                    let limitArc = Path.arc(center: center, radius: radius, startAngle: startLimitAngle, endAngle: endLimitAngle, clockwise: false, closed: true)
                    context.fill(limitArc, with: .color(.black.opacity(0.1)))
                    //context.fill(limitArc, with: .color(color))

                    let startAngle = Angle(degrees: 0 - angle.degrees / 2 - 90)
                    let endAngle = Angle(degrees: 0 + angle.degrees / 2 - 90)
                    let angleArc = Path.arc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false, closed: true)
                    context.fill(angleArc, with: .color(color.opacity(0.5)))
                    if angle.degrees != 360 {
                        let arcEdges = Path { path in
                            path.move(to: center)
                            path.addLine(to: center + CGPoint(x: radius, y: 0).rotated(by: startAngle))
                            if angle.degrees != 0 {
                                path.move(to: center)
                                path.addLine(to: center + CGPoint(x: radius, y: 0).rotated(by: endAngle))
                            }
                        }
                        context.stroke(arcEdges, with: .color(color), style: .init(lineWidth: edgeWidth, dash: [edgeWidth * 2, edgeWidth * 2], dashPhase: edgeWidth * 2))
                    }

                    context.stroke(limitArc, with: .color(.white), style: .init(lineWidth: borderWidth))
                }
                context.addFilter(.shadow(radius: shadowRadius))
            }
            .aspectRatio(1.0, contentMode: .fit)
        }
        .frame(width: width)
        .shadow(radius: shadowRadius)
    }
}

struct AngleEditorPreview: PreviewProvider {
    static var previews: some View {
        let angle = Binding.constant(Angle(degrees: 160))
        let limit: ClosedRange<Angle> = .degrees(0) ... .degrees(180)

        HStack {
            AngleEditor(angle: angle, limit: limit)
                .controlSize(.mini)
                .border(.black.opacity(0.25))
            AngleEditor(angle: angle, limit: limit)
                .controlSize(.small)
                .border(.black.opacity(0.25))
            AngleEditor(angle: angle, limit: limit)
                .controlSize(.regular)
                .border(.black.opacity(0.25))
            AngleEditor(angle: angle, limit: limit)
                .controlSize(.large)
                .border(.black.opacity(0.25))
        }
    }
}
