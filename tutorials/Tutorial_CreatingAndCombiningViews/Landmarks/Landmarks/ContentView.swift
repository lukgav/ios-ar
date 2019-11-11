//
//  ContentView.swift
//  Landmarks
//
//  Created by Luke Gavin on 10.11.19.
//  Copyright © 2019 Luke Gavin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MapView()
                .edgesIgnoringSafeArea(.top)
                .frame(height: 300)
            CircleImage()
                .offset(y: -130)
                .padding(.bottom, -130)

            VStack(alignment: .leading) {
                    Text("Turtle Rock")
                        .font(.title)
                    HStack {
                        Text("Phoenix Park")
                            .font(.subheadline)
                        Spacer()
                        Text("Ireland")
                            .font(.subheadline)
                    }
                }
            .padding()
            Spacer()


        }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
