//
//  ContentView.swift
//  InputsInSwiftUI
//
//  Created by Amit Gupta on 8/21/22.
//

import SwiftUI

struct ContentView: View {
    @State var fieldAValue = 1000.0
    @State var fieldBValue = 5.0
    @State var fieldCValue = 3
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "minus")
                Slider(value: $fieldAValue, in: 300...4000).onChange(of: fieldAValue, perform: { value in
                    callOnChange()
                }).accentColor(Color.green)
                Image(systemName: "plus")
            }.foregroundColor(Color.green)
            Text("FieldA: \(fieldAValue, specifier: "%.2f")")
            Spacer()
            HStack {
                Image(systemName: "minus")
                Slider(value: $fieldBValue, in: 16...100).onChange(of: fieldBValue, perform: { value in
                    callOnChange()
                }).accentColor(Color.green)
                Image(systemName: "plus")
            }.foregroundColor(Color.green)
            Text("FieldB: \(fieldBValue, specifier: "%.2f")")
            Spacer()
            Stepper(value: $fieldCValue,
                                        in: 0...10,
                                        label: {
                                    Text("Field C Value: \(self.fieldCValue)")
                                        }).onChange(of: fieldCValue, perform: { value in
                                            callOnChange()
                                        })
            Spacer()
        }
        
    }
    
    func callOnChange() {
        print("Call on change invoked, fieldAValue=\(fieldAValue)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
