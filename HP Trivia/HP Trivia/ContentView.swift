//
//  ContentView.swift
//  HP Trivia
//
//  Created by iM on 25/12/2023.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var game: Game
    
    @State private var audioPlayer: AVAudioPlayer!
    @State private var scalePlayButton = false
    @State private var moveBackgoundImage = false
    @State private var animateViewsIn = false
    @State private var showSettings = false
    @State private var showInstructions = false
    @State private var playGame = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("hogwarts")
                    .resizable()
                    .frame(width: geo.size.width * 3, height: geo.size.height)
                    .padding(.top, 3)
                    .offset(x: moveBackgoundImage ? geo.size.width / 1.1 : -geo.size.width / 1.1)
                    .onAppear {
                        withAnimation(.linear(duration: 60).repeatForever()) {
                            moveBackgoundImage.toggle()
                        }
                    }
                
                VStack {
                    VStack {
                        if animateViewsIn {
                            VStack {
                                Image(systemName: "bolt.fill")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                Text("HP")
                                    .font(.custom(Constants.hpFont, size: 70))
                                    .padding(.bottom, -50)
                                
                                Text("Trivia")
                                    .font(.custom(Constants.hpFont, size: 60))
                            }.padding(.top, 100)
                                .transition(.move(edge: .top))
                        }
                    }.animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                    Spacer()
                    VStack {
                        if animateViewsIn {
                            VStack {
                                Text("Recent Score")
                                    .font(.title2)
                                
                                Text("11");
                                Text("33");
                                Text("22");
                            }
                            .font(.title3)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .background(.black.opacity(0.7))
                            .cornerRadius(15)
                            .transition(.opacity)
                        }
                    }.animation(.easeOut(duration: 1).delay(4), value: animateViewsIn)
                    Spacer()
                    HStack {
                        Spacer()
                        VStack {
                            if animateViewsIn {
                                Button {
                                    // show instruction screen
                                    showInstructions.toggle()
                                } label:  {
                                    Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 5)
                                }.transition(.offset(x: -geo.size.width / 4))
                                    .sheet(isPresented: $showInstructions){
                                        Instructions()
                                    }
                            }
                        }.animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        Spacer()
                        VStack {
                            if animateViewsIn {
                                Button("Play") {
                                    filterQuestions()
                                    game.startGame()
                                    playGame.toggle()
                                }.font(.largeTitle)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 7)
                                    .padding(.horizontal, 50)
                                    .cornerRadius(7)
                                    .shadow(radius: 5)
                                    .background(store.books.contains(.active) ? .brown : .gray)
                                    .scaleEffect(scalePlayButton ? 1.2 : 1)
                                    .onAppear {
                                        withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                            scalePlayButton.toggle()
                                        }
                                    }.transition(.offset(y: geo.size.height / 3))
                                    .fullScreenCover(isPresented: $playGame){
                                        GamePlay()
                                    }
                                    .disabled(store.books.contains(.active) ? false : true)
                            }
                        }.animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                        Spacer()
                        VStack {
                            if animateViewsIn {
                                Button {
                                    animateViewsIn.toggle()
                                } label:  {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(.white)
                                        .shadow(radius: 7)
                                }
                                .transition(.offset(x: geo.size.width / 4))
                                    .sheet(isPresented: $showSettings){
                                        Settings().environmentObject(store).environmentObject(game)
                                    }
                            }
                        }.animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        Spacer()
                    }.frame(width: geo.size.width)
                    
                    VStack {
                        if animateViewsIn {
                            if store.books.contains(.active) == false {
                                Text("No questions available. Go to Settings")
                                    .multilineTextAlignment(.center)
                                    .transition(.opacity)
                            }
                        }
                    }.animation(.easeInOut.delay(3), value: animateViewsIn)
                    Spacer()
                }
            }.frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            //            playAudio()
            animateViewsIn = true
        }
    }
    
    private func playAudio() {
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    private func filterQuestions() {
        var books: [Int] = []
        for (index, status) in store.books.enumerated() {
            if status == .active {
                books.append(index + 1)
            }
        }
        game.filterQuestions(to: books)
        game.newQuestions()
    }
}

#Preview {
    ContentView().environmentObject(Store()).environmentObject(Game())
}
