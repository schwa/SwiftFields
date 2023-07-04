import SwiftFormats
import SwiftUI

// https://mastodon.social/@ikenndac/110316785167632103

public struct AngleEditor: View {
    fileprivate struct Geometry {
        var canvasDiameter: CGFloat
        var borderWidth: CGFloat
        var edgeWidth: CGFloat
    }

    @Binding
    private var angle: Angle

    @Environment(\.controlSize)
    private var controlSize

    private let limit: ClosedRange<Angle>

    public init(angle: Binding<Angle>, limit: ClosedRange<Angle> = .degrees(0) ... .degrees(360)) {
        self._angle = angle
        self.limit = limit
    }

    public var body: some View {
        let geometry = Geometry(controlSize: controlSize)
        let shadowRadius = 1.0
        let color = Color.red

        return VStack {
            TextField("Angle", value: $angle, format: .angle)
            HStack {
                Canvas { context, size in
                    context.drawLayer { context in
                        let center = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
                        let radius = min(size.width, size.height) / 2 - geometry.borderWidth - shadowRadius

                        let startLimitAngle = Angle(degrees: limit.lowerBound.degrees - 180)
                        let endLimitAngle = Angle(degrees: limit.upperBound.degrees - 180)

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
                            context.stroke(arcEdges, with: .color(color), style: .init(lineWidth: geometry.edgeWidth, dash: [geometry.edgeWidth * 2, geometry.edgeWidth * 2], dashPhase: geometry.edgeWidth * 2))
                        }
                        context.stroke(limitArc, with: .color(.white), style: .init(lineWidth: geometry.borderWidth))
                    }
                    context.addFilter(.shadow(radius: shadowRadius))
                }
                .frame(width: geometry.canvasDiameter)
                .aspectRatio(1.0, contentMode: .fit)
                YASlider(value: $angle.degrees, in: limit.lowerBound.degrees ... limit.upperBound.degrees, axis: .vertical)
            }
            .frame(height: geometry.canvasDiameter)
        }
        .shadow(radius: shadowRadius)
        .accessibilityRepresentation {
            Slider(value: $angle.degrees, in: 0 ... 360)
        }
    }
}

// MARK: -

extension AngleEditor.Geometry {
    init(controlSize: ControlSize) {
        switch controlSize {
        case .mini:
            canvasDiameter = 32
            borderWidth = 1
            edgeWidth = 1
        case .small:
            canvasDiameter = 40
            borderWidth = 2
            edgeWidth = 2
        case .regular:
            canvasDiameter = 64
            borderWidth = 2
            edgeWidth = 2
        case .large:
            canvasDiameter = 80
            borderWidth = 4
            edgeWidth = 3
        case .extraLarge:
            canvasDiameter = 80
            borderWidth = 4
            edgeWidth = 3
        @unknown default:
            canvasDiameter = 64
            borderWidth = 4
            edgeWidth = 2
        }
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

