//
//  MainAppView.swift
//  Time Tell
//
//  Created by Pieter Yoshua Natanael on 04/12/24.
//

import SwiftUI

struct MainAppView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Sections", selection: $selectedTab) {
                    Text("Read Loop").tag(0)
                    Text("Library").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()

                // Content based on selection
                Group {
                    if selectedTab == 0 {
                        ContentView()
                    } else {
                        ListView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(minWidth: 600, minHeight: 400) // Ensures a good macOS window size
            .toolbar {
                ToolbarItem(placement: .automatic) { // Fix: No navigation-specific placement
                    Picker("Sections", selection: $selectedTab) {
                        Text("Read Loop").tag(0)
                        Text("Library").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                }
            }
        }
    }
}


// Preview
struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
