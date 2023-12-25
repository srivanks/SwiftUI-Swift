//
//  QuoteView.swift
//  BB Quotes
//
//  Created by iM on 23/12/2023.
//

import SwiftUI

struct QuoteView: View {
    @StateObject private var viewModel = ViewModel(controller: FetchController())
    @State private var showCharacterInfo = false
    let show: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show == "Breaking Bad" ? "breakingbad" : "bettercallsaul")
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)
                
                VStack {
                    Spacer()
                    
                    switch viewModel.status {
                    case .fetching:
                        ProgressView()
                    case .success(let data):
                        Text("\"\(data.quote.quote)\"")
                            .minimumScaleFactor(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .padding()
                            .background(.black.opacity(0.5))
                            .cornerRadius(25)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        ZStack(alignment: .bottom) {
                            AsyncImage(url: data.character.images[0]) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                ProgressView("Loading")
                            }
                            .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                            
                            Text(data.quote.character)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.ultraThinMaterial)
                                .cornerRadius(50)
                        }
                        .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                        .onTapGesture {
                            showCharacterInfo.toggle()
                        }
                        .sheet(isPresented: $showCharacterInfo) {
                            CharacterVIew(show: show, character: data.character)
                        }
                        
                    default:
                        EmptyView()
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await viewModel.getData(for: show)
                        }
                    } label: {
                        Text("Get Random Quote")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(show == "Better Call Saul" ? "bcsblue" : "bbgreen"))
                            .cornerRadius(7)
                            .shadow(color: .yellow, radius: 2)
                    }
                    
                    Spacer()
                }.frame(width: geo.size.width)
                
            }.frame(width: geo.size.width, height: geo.size.height)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    QuoteView(show: "Breaking Bad")
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
}

