//
//  DropdownView.swift
//  InputsInSwiftUI
//
//  Created by Amit Gupta on 8/28/22.
//

import SwiftUI



struct DropdownView: View {
    @State private var selection = "Red"
    let di=["A":"a","B":"b","C":"c"]
    var body: some View {
        Text("Menu")
    }
    
    /*
    func showMenu(_ m: String, _ d:[String:String]) -> some View {
        var r=""
        VStack {
            Picker(m, selection: $selection) {
                ForEach(Array(d.keys), id: \.self) {
                    Text(di[$0]!)
                }
            }
            .pickerStyle(.menu)

            Text("Selected color: \(r)")
        }
     
    }*/
    
}



struct DropdownView2: View {
    @State private var selection = "Red"
    
    let colors = ["Red", "Green", "Blue", "Black", "Tartan"]

    var body: some View {
        VStack {
            Picker("Select a paint color", selection: $selection) {
                ForEach(colors, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(.menu)

            Text("Selected color: \(selection)")
        }
    }
}


struct DropdownView_Previews: PreviewProvider {
    static var previews: some View {
        DropdownView()
    }
}
