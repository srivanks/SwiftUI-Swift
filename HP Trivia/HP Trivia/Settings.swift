//
//  Settings.swift
//  HP Trivia
//
//  Created by iM on 25/12/2023.
//

import SwiftUI

struct Settings: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var store: Store
    
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            VStack{
                Text("Which books you like to see the questions from?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        
                        ForEach(0..<7) {i in
                            if store.books[i] == .active  || (
                                store.books[i] == .locked && store.purchasedIds.contains("hp\(i+1)")
                            ){
                                ZStack(alignment: .bottomTrailing) {
                                    Image("hp\(i+1)")
                                        .resizable()
                                        .scaledToFit().shadow(radius: 7)
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.green)
                                        .shadow(radius: 1)
                                        .padding()
                                }
                                .onTapGesture {
                                    store.books[i] = .inactive
                                    store.saveStatus()
                                }
                                .task {
                                    store.books[i] = .active
                                    store.saveStatus()
                                }
                            } else if( store.books[i] == .inactive){
                                ZStack(alignment: .bottomTrailing){
                                    Image("hp2")
                                        .resizable()
                                        .scaledToFit().shadow(radius: 7)
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.green)
                                        .shadow(radius: 7)
                                        .padding()
                                        .overlay(Rectangle().opacity(0.33))
                                    
                                    Image(systemName: "circle")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .foregroundColor(.green)
                                        .opacity(0.5)
                                        .shadow(radius: 1)
                                        .padding(3)
                                    
                                }.onTapGesture {
                                    store.books[i] = .active
                                    store.saveStatus()
                                }
                                
                            } else {
                                
                                ZStack {
                                    Image("hp3")
                                        .resizable()
                                        .scaledToFit().shadow(radius: 7)
                                        .overlay(Rectangle().opacity(0.75))
                                    
                                    Image(systemName: "lock.fill")
                                        .font(.largeTitle)
                                        .imageScale(.large)
                                        .shadow(color: .white.opacity(0.75), radius: 3)
                                    
                                }
                            }
                            
                        }
                    }
                }
                .padding()
                
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
    Settings().environmentObject(Store())
}
