//
//  AngleEditorDemo.swift
//  SwiftFieldsDemo
//
//  Created by Jonathan Wight on 5/16/23.
//

import SwiftFields
import SwiftUI
import SwiftFormats

struct AngleEditorDemo: View {

    @State
    var limit = Angle(degrees: 0) ... Angle(degrees: 360)


    @State
    var value = Angle(degrees: 90)

    var body: some View {
        VStack {

            TextField("Limit", value: $limit, format: ClosedRangeFormatStyle(substyle: .angle))

            AngleEditor(angle: $value, limit: limit)
        }
    }
}
