import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink("PathSlider") {
                    PathSliderDemo()
                }
            }
        }
    }
}
