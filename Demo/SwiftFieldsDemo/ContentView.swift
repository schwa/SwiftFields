import SwiftUI
import SwiftFields
import SwiftFormats

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("AngleEditorDemo") {
                    AngleEditorDemo()
                }
                NavigationLink("ClosedRangeSliderDemo") {
                    ClosedRangeSliderDemo()
                }
                NavigationLink("PathSliderDemo") {
                    PathSliderDemo()
                }
                NavigationLink("YASliderDemo") {
                    YASliderDemo()
                }
            }
            .frame(minWidth: 200)
        }
    }
}

// MARK: -

struct AngleEditorDemo: View {

    @State
    var limit = Angle(degrees: 0) ... Angle(degrees: 360)


    @State
    var value = Angle(degrees: 90)

    var body: some View {
        VStack {
            VStack {
                TextField("Limit", value: $limit, format: ClosedRangeFormatStyle(substyle: .angle))
            }
            .padding()
            Spacer()
            AngleEditor(angle: $value, limit: limit)
            Spacer()
        }
        .frame(maxWidth: 160)
    }
}

// MARK: -

struct ClosedRangeSliderDemo: View {

    @State
    var value = 0.0 ... 1.0

    var body: some View {
        VStack {
            VStack {
                TextField("Value", value: $value, format: ClosedRangeFormatStyle(substyle: .number))
                Slider(value: $value.editableLowerBound, in: 0 ... value.upperBound, label: { Text("Lower bound")})
                Slider(value: $value.editableUpperBound, in: value.lowerBound ... 1, label: { Text("Upper bound")})
            }
            .padding()
            Spacer()
            ClosedRangeSlider(value: $value)
            Spacer()
        }
        .frame(width: 150)
    }
}

// MARK: -

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
    var shape = Shape.logo

    var path: Path {
        return shape.path
    }

    var body: some View {
        let frame = path.boundingRect.insetBy(dx: -10, dy: -10)
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
            .frame(maxWidth: 160)
            .padding()
            Spacer()
            PathSlider(value: $value, in: 0 ... 100, path: path.offsetBy(dx: 10, dy: 10))
                .frame(width: frame.width, height: frame.height)
                .border(Color.pink.opacity(0.1))
            Spacer()
        }
    }
}

extension PathSliderDemo.Shape {
    var path: Path {
        switch self {
        case .line:
            return Path { path in
                path.addLines([CGPoint(x: 0, y: 0), CGPoint(x: 100, y: 0)])
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

// MARK: -

struct YASliderDemo: View {
    @State
    var value: Double = 50

    var body: some View {
        VStack {
            VStack {
                TextField("Value", value: $value, format: .number)
                Slider(value: $value, in: 0 ... 80)
            }
            .frame(width: 120)
            .padding()
            Spacer()
            HStack {
                YASlider(value: $value, in: 0 ... 80, axis: .horizontal).frame(width: 120)
                YASlider(value: $value, in: 0 ... 80, axis: .vertical).frame(height: 120)
                YASlider(value: $value, in: 0 ... 100, axis: .horizontal).frame(width: 120)
                .thumbStyle(AnyThumbStyle(content: { configuration -> Text in
                    switch configuration.value {
                    case 0 ..< 20:
                        return Text("😭").font(.title)
                    case 20 ..< 40:
                        return Text("😟").font(.title)
                    case 40 ..< 60:
                        return Text("😒").font(.title)
                    case 60 ..< 80:
                        return Text("🤣").font(.title)
                    case 80 ... 100:
                        return Text("😭").font(.title)
                    default:
                        fatalError()
                    }
                }))
            }
            Spacer()
        }
    }
}
