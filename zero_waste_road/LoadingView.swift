//
//  LoadingView.swift
//  zero_waste_road
//
//  Created by Alexey Meleshin on 12/5/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var loading: CGFloat = 0
    
    var body: some View {
        ZStack {
            Image("loading_background_vertical")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()

                Image("loading_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260)

                Spacer()

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(red: 127/255, green: 127/255, blue: 127/255))
                        .frame(width: 200, height: 10)

                    Capsule()
                        .fill(Color(red: 247/255, green: 205/255, blue: 118/255))
                        .frame(width: 200 * loading, height: 10)
                }
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 3)) {
                loading = 1
            }
        }
    }
}

#Preview {
    LoadingView()
    
}
