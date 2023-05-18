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
                NavigationLink("PathSliderDemo") {
                    PathSliderDemo()
                }
                NavigationLink("ClosedRangeSliderDemo") {
                    ClosedRangeSliderDemo()
                }
            }
        }
    }
}

// MARK: -

struct ClosedRangeSliderDemo: View {

    @State
    var value = 0.0 ... 1.0

    var body: some View {
        VStack {
            TextField("Value", value: $value, format: ClosedRangeFormatStyle(substyle: .number))
            Slider(value: $value.editableLowerBound, in: 0 ... value.upperBound, label: { Text("Lower bound")})
            Slider(value: $value.editableUpperBound, in: value.lowerBound ... 1, label: { Text("Upper bound")})
            ClosedRangeSlider(value: $value)
        }
        .frame(width: 150)
    }
}

extension ClosedRange {
    var editableLowerBound: Bound {
        get {
            lowerBound
        }
        set {
            self = newValue ... upperBound
        }
    }
    var editableUpperBound: Bound {
        get {
            upperBound
        }
        set {
            self = lowerBound ... newValue
        }
    }
}
