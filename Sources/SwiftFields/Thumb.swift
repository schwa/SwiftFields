import SwiftUI

public protocol ThumbStyle {
    associatedtype Body: View
    typealias Configuration = ThumbStyleConfiguration
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

private extension ThumbStyle {
    func makeAnyBody(configuration: Configuration) -> AnyView {
        return AnyView(makeBody(configuration: configuration))
    }
}

public struct ThumbStyleConfiguration {
    public var value: Double
    public var range: ClosedRange<Double>
}

public struct ThumbStyleKey: EnvironmentKey {
    public static var defaultValue: any ThumbStyle = DefaultThumbStyle()
}

public extension EnvironmentValues {
    var thumbStyle: any ThumbStyle {
        get {
            self[ThumbStyleKey.self]
        }
        set {
            self[ThumbStyleKey.self] = newValue
        }
    }
}

public extension View {
    func thumbStyle <S>(_ value: S) -> some View where S: ThumbStyle {
        environment(\.thumbStyle, value)
    }
}

public struct Thumb: View {
    @Environment(\.thumbStyle)
    var thumbStyle

    let value: Double
    let range: ClosedRange<Double>

    public var body: some View {
        let configuration = ThumbStyleConfiguration(value: value, range: range)
        return thumbStyle.makeAnyBody(configuration: configuration)
    }
}

public struct DefaultThumbStyle: ThumbStyle {

    public init() {
    }

    public func makeBody(configuration: Configuration) -> some View {
        ShapedThumbStyle(shape: Circle()).makeBody(configuration: configuration)
    }
}

// MARK: -

public struct ShapedThumbStyle <S>: ThumbStyle where S: Shape {
    private let shape: S

    public init(shape: S) {
        self.shape = shape
    }

    public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            shape.fill(Color.white).shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.05), radius: 0.5, y: 2)
            shape.stroke(Color.sliderBackground)
        }
    }
}

// MARK: -

public struct AnyThumbStyle <Content>: ThumbStyle where Content: View {
    private let content: (Configuration) -> Content

    public init(content: @escaping (Configuration) -> Content) {
        self.content = content
    }

    public func makeBody(configuration: Configuration) -> some View {
        content(configuration)
    }
}
