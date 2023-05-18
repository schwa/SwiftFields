import SwiftFields
import SwiftUI

struct PathSliderDemo: View {

    @State
    var value: Double = 0

    enum Shape: CaseIterable {
        case line
        case wigglyLine
        case circle
        case roundedRect
        case star
        case logo
    }

    @State
    var shape = Shape.line

    var path: Path {
        return shape.path
    }

    var body: some View {
        VStack {
            VStack {
                Picker("Shape", selection: $shape) {
                    ForEach(Shape.allCases, id: \.self) { shape in
                        Text("\(String(describing: shape))").tag(shape)
                    }
                }
                .labelsHidden()
                TextField("Value", value: $value, format: .number)
                Slider(value: $value, in: 0 ... 100)
            }
            .frame(maxWidth: 120)
            Color.clear.frame(height: 80)
            PathSlider(value: $value, in: 0 ... 100, path: path)
        }
    }
}

extension PathSliderDemo.Shape {
    var path: Path {
        switch self {
        case .line:
            return Path { path in
                path.addLines([CGPoint(x: 0, y: 10), CGPoint(x: 100, y: 10)])
            }
        case .wigglyLine:
            return Path { path in
                path.move(to: CGPoint.zero)
                path.addQuadCurve(to: CGPoint(x: 100, y: 50), control: CGPoint(x: 50, y: 100))
                path.addQuadCurve(to: CGPoint(x: 200, y: 50), control: CGPoint(x: 150, y: 0))
            }
        case .circle:
            return Path(ellipseIn: CGRect(x: 0, y: 0, width: 50, height: 50))
        case .roundedRect:
            return Path(roundedRect: CGRect(x: 0, y: 0, width: 50, height: 50), cornerRadius: 8)
        case .star:
            return Path { path in
                path.addLines(
                    [CGPoint(x: 0.5, y: 0), CGPoint(x: 0.618, y: 0.338), CGPoint(x: 0.976, y: 0.345), CGPoint(x: 0.69, y: 0.562), CGPoint(x: 0.794, y: 0.905), CGPoint(x: 0.5, y: 0.7), CGPoint(x: 0.206, y: 0.905), CGPoint(x: 0.31, y: 0.562), CGPoint(x: 0.024, y: 0.345), CGPoint(x: 0.382, y: 0.338)].map { CGPoint(x: $0.x * 100, y: $0.y * 100)}
                )
                path.closeSubpath()
            }
        case .logo:
            return Path { path in
                // Apple
                path.move(to: CGPoint(x: 110.89, y: 99.2))
                path.addCurve(to: CGPoint(x: 105.97, y: 108.09), control1: CGPoint(x: 109.5, y: 102.41), control2: CGPoint(x: 107.87, y: 105.37))
                path.addCurve(to: CGPoint(x: 99.64, y: 115.79), control1: CGPoint(x: 103.39, y: 111.8), control2: CGPoint(x: 101.27, y: 114.37))
                path.addCurve(to: CGPoint(x: 91.5, y: 119.4), control1: CGPoint(x: 97.11, y: 118.13), control2: CGPoint(x: 94.4, y: 119.33))
                path.addCurve(to: CGPoint(x: 83.99, y: 117.59), control1: CGPoint(x: 89.42, y: 119.4), control2: CGPoint(x: 86.91, y: 118.8))
                path.addCurve(to: CGPoint(x: 75.9, y: 115.79), control1: CGPoint(x: 81.06, y: 116.39), control2: CGPoint(x: 78.36, y: 115.79))
                path.addCurve(to: CGPoint(x: 67.58, y: 117.59), control1: CGPoint(x: 73.31, y: 115.79), control2: CGPoint(x: 70.54, y: 116.39))
                path.addCurve(to: CGPoint(x: 60.39, y: 119.49), control1: CGPoint(x: 64.61, y: 118.8), control2: CGPoint(x: 62.21, y: 119.43))
                path.addCurve(to: CGPoint(x: 52.07, y: 115.79), control1: CGPoint(x: 57.6, y: 119.61), control2: CGPoint(x: 54.83, y: 118.38))
                path.addCurve(to: CGPoint(x: 45.44, y: 107.82), control1: CGPoint(x: 50.3, y: 114.24), control2: CGPoint(x: 48.09, y: 111.58))
                path.addCurve(to: CGPoint(x: 38.44, y: 93.82), control1: CGPoint(x: 42.6, y: 103.8), control2: CGPoint(x: 40.27, y: 99.14))
                path.addCurve(to: CGPoint(x: 35.5, y: 77.15), control1: CGPoint(x: 36.48, y: 88.09), control2: CGPoint(x: 35.5, y: 82.53))
                path.addCurve(to: CGPoint(x: 39.48, y: 61.21), control1: CGPoint(x: 35.5, y: 70.98), control2: CGPoint(x: 36.82, y: 65.67))
                path.addCurve(to: CGPoint(x: 47.8, y: 52.74), control1: CGPoint(x: 41.56, y: 57.63), control2: CGPoint(x: 44.33, y: 54.81))
                path.addCurve(to: CGPoint(x: 59.06, y: 49.54), control1: CGPoint(x: 51.27, y: 50.67), control2: CGPoint(x: 55.02, y: 49.61))
                path.addCurve(to: CGPoint(x: 67.76, y: 51.58), control1: CGPoint(x: 61.27, y: 49.54), control2: CGPoint(x: 64.16, y: 50.23))
                path.addCurve(to: CGPoint(x: 74.67, y: 53.62), control1: CGPoint(x: 71.35, y: 52.94), control2: CGPoint(x: 73.66, y: 53.62))
                path.addCurve(to: CGPoint(x: 82.33, y: 51.22), control1: CGPoint(x: 75.42, y: 53.62), control2: CGPoint(x: 77.98, y: 52.82))
                path.addCurve(to: CGPoint(x: 92.73, y: 49.36), control1: CGPoint(x: 86.43, y: 49.73), control2: CGPoint(x: 89.9, y: 49.12))
                path.addCurve(to: CGPoint(x: 110.05, y: 58.53), control1: CGPoint(x: 100.43, y: 49.98), control2: CGPoint(x: 106.2, y: 53.03))
                path.addCurve(to: CGPoint(x: 99.83, y: 76.13), control1: CGPoint(x: 103.17, y: 62.72), control2: CGPoint(x: 99.77, y: 68.59))
                path.addCurve(to: CGPoint(x: 106.17, y: 90.76), control1: CGPoint(x: 99.89, y: 82), control2: CGPoint(x: 102.01, y: 86.88))
                path.addCurve(to: CGPoint(x: 112.5, y: 94.94), control1: CGPoint(x: 108.05, y: 92.56), control2: CGPoint(x: 110.16, y: 93.95))
                path.addCurve(to: CGPoint(x: 110.89, y: 99.2), control1: CGPoint(x: 111.99, y: 96.42), control2: CGPoint(x: 111.46, y: 97.84))

                // Leaf
                path.move(to: CGPoint(x: 93.25, y: 29.36))
                path.addCurve(to: CGPoint(x: 88.25, y: 42.23), control1: CGPoint(x: 93.25, y: 33.96), control2: CGPoint(x: 91.58, y: 38.26))
                path.addCurve(to: CGPoint(x: 74.1, y: 49.26), control1: CGPoint(x: 84.23, y: 46.96), control2: CGPoint(x: 79.37, y: 49.69))
                path.addCurve(to: CGPoint(x: 74, y: 47.52), control1: CGPoint(x: 74.03, y: 48.71), control2: CGPoint(x: 74, y: 48.13))
                path.addCurve(to: CGPoint(x: 79.3, y: 34.51), control1: CGPoint(x: 74, y: 43.1), control2: CGPoint(x: 75.91, y: 38.38))
                path.addCurve(to: CGPoint(x: 85.76, y: 29.63), control1: CGPoint(x: 80.99, y: 32.55), control2: CGPoint(x: 83.15, y: 30.93))
                path.addCurve(to: CGPoint(x: 93.15, y: 27.52), control1: CGPoint(x: 88.37, y: 28.35), control2: CGPoint(x: 90.83, y: 27.65))
                path.addCurve(to: CGPoint(x: 93.25, y: 29.36), control1: CGPoint(x: 93.22, y: 28.14), control2: CGPoint(x: 93.25, y: 28.75))
                path.addLine(to: CGPoint(x: 93.25, y: 29.36))

                path.closeSubpath()
            }
            .applying(.init(translationX: -35.5, y: -29.36))

        }

    }
}
