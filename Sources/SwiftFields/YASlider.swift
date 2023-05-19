import SwiftUI

public struct YASlider <Label, ValueLabel> : View where Label : View, ValueLabel : View {
    @Binding
    private var value: Double

    private let limit: ClosedRange<Double>
    private let step: Double?
    private let label: Label?
    private let minimumValueLabel: ValueLabel?
    private let maximumValueLabel: ValueLabel?
    private let onValueChanged: ((Bool) -> Void)
    private let axis: Axis

    @Environment(\.controlSize)
    private var controlSize

    init(value: Binding<Double>, limit: ClosedRange<Double>, step: Double? = nil, label: Label?, minimumValueLabel: ValueLabel? = nil, maximumValueLabel: ValueLabel? = nil, onValueChanged: ((Bool) -> Void)? = nil, axis: Axis) {
        self._value = value
        self.limit = limit
        self.step = step
        self.label = label
        self.minimumValueLabel = minimumValueLabel
        self.maximumValueLabel = maximumValueLabel
        self.onValueChanged = onValueChanged ?? { _ in }
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

extension YASlider where ValueLabel == EmptyView {
    public init(value: Binding<Double>, in limit: ClosedRange<Double> = 0 ... 1, step: Double? = nil, label: () -> Label, onValueChanged: ((Bool) -> Void)? = nil, axis: Axis) {
        self.init(value: value, limit: limit, step: step, label: label(), minimumValueLabel: nil, maximumValueLabel: nil, onValueChanged: onValueChanged, axis: axis)
    }
}

extension YASlider where Label == EmptyView, ValueLabel == EmptyView {
    public init(value: Binding<Double>, in limit: ClosedRange<Double> = 0 ... 1, step: Double? = nil, onValueChanged: ((Bool) -> Void)? = nil, axis: Axis) {
        self.init(value: value, limit: limit, step: step, label: nil, minimumValueLabel: nil, maximumValueLabel: nil, onValueChanged: onValueChanged, axis: axis)
    }
}

// MARK: -

struct YASlider_Preview: PreviewProvider {
    static var previews: some View {
        Form {
            YASlider(value: .constant(0.5), in: 0 ... 1, label: { Text("Label") }, axis: .horizontal)
            Slider(value: .constant(0.5), in: 0 ... 1, label: { Text("Label") })
            LabeledContent("Variants") {
                Slider(value: .constant(0.5), in: 0 ... 1, step: 0.1) {
                    Text("Label")
                } minimumValueLabel: {
                    Text("Min")
                } maximumValueLabel: {
                    Text("Max")
                } onEditingChanged: { _ in
                }
            }
            YASlider(value: .constant(0.5), in: 0 ... 1, label: { Text("Label") }, axis: .vertical).frame(height: 50)
        }
    }
}
