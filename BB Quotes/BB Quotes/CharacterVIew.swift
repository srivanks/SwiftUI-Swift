//
//  CharacterVIew.swift
//  BB Quotes
//
//  Created by iM on 23/12/2023.
//

import SwiftUI

struct CharacterVIew: View {
    let show: String
    let character : Character
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Image(show.lowerNoSpaces)
                    .resizable()
                    .scaledToFit()
                
                ScrollView {
                    VStack {
                        AsyncImage(url: character.images.randomElement()) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }

                    }
                    .frame(width: geo.size.width / 1.2, height: geo.size.height / 1.7)
                    .cornerRadius(25)
                    .padding(.top, 60)
                    
                    VStack(alignment: .leading) {
                        Group {
                            Text(character.name)
                                .font((.largeTitle))
                            Text("Portrayed by: \(character.portrayedBy)")
                                .font((.subheadline))
                            Divider()
                            Text("\(character.name) charater info")
                                .font(.title2)
                            Text("Born: \(character.birthday)")
                            Divider()
                        }
                        Group{
                            Text("Occupations:")
                            
                            ForEach(character.occupations, id: \.self){ occupation in
                                Text("\(occupation)")
                                    .font(.subheadline)
                            }
                            Divider()
                            Text("Nick names:")
                            if(character.aliases.count > 0){
                                ForEach(character.aliases, id: \.self){ alias in
                                    Text("\(alias)")
                                        .font(.subheadline)
                                }
                            }else {
                                Text("None")
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding(.leading, 40)
                    
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CharacterVIew(show: "Breaking Bad", character: Constants.previewCharacter)
}
