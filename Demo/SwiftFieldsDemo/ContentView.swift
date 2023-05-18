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
                NavigationLink("VerticalSliderDemo") {
                    VerticalSliderDemo()
                }
            }
            .frame(minWidth: 200)
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

struct VerticalSliderDemo: View {
    @State
    var value: Double = 50

    var body: some View {
        VStack {
            TextField("Value", value: $value, format: .number)
            Slider(value: $value, in: 0 ... 100)
            VerticalSlider(value: $value, in: 0 ... 100).frame(height: 100)
        }
        .frame(width: 100)
    }
}
