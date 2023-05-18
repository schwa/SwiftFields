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
