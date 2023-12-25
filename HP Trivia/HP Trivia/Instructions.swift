//
//  Instructions.swift
//  HP Trivia
//
//  Created by iM on 25/12/2023.
//

import SwiftUI

struct Instructions: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        ZStack {
            InfoBackgroundImage()
            
            VStack {
                Image("appiconwithradius")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                
                ScrollView {
                    Text("How to play?")
                        .font(.largeTitle)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Guess the right answer or you loose")
                            .padding([.horizontal, .bottom], 2)
                        Text("Each question is worth 5 points")
                    }
                    
                }.foregroundColor(.black)
                
                Button("Done") {
                    dismiss()
                }
                .font(.largeTitle)
                .padding()
                .buttonStyle(.borderedProminent)
                .tint(.brown)
                .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    Instructions()
}
