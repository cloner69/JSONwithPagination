//
//  ContentView.swift
//  JSONwithPagination
//
//  Created by Adrian Suryo Abiyoga on 20/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("JSON Parsing")
        }

    }
}

#Preview {
    ContentView()
}
