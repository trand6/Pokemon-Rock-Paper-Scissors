//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by David on 9/8/22.
//

import SwiftUI

// Display Pokémon icons
struct TypeImage: View {
    var type: String
    
    var body: some View {
        Image(type)
            .resizable()
            .renderingMode(.original)
            .shadow(radius: 5).frame(width: 135.0, height: 135.0)
    }
}

struct ContentView: View {
    @State private var playerMoves = ["Grass", "Fire", "Water"]
    @State private var opponentType = ["Grass", "Fire", "Water"].shuffled()
    @State private var isStrong = true
    @State private var effective = "strong"
    @State private var userScore = 0
    @State private var scoreTitle = ""
    @State private var gamesPlayed = 0
    @State private var gameLimit = false
    @State private var showingScore = false
    
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 248/255, green: 124/255, blue: 118/255), location: 0.3),
                .init(color: Color(red: 228/255, green: 228/255, blue: 228/255), location: 0.3)
            ], center: .top, startRadius: 300, endRadius: 750)
                .ignoresSafeArea()
        
            VStack {
                Spacer()
                
                Text("Pokémon")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Group {
                            Text("Who is") +
                            Text(" \(effective) ").foregroundColor(isStrong ? .red : .blue) +
                            Text("against \(opponentType[0])?")
                        }
                        .foregroundStyle(.primary)
                        .font(.subheadline.weight(.heavy))
                        .opacity(0.8)
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            typeTapped(number)
                        } label: {
                            TypeImage(type: playerMoves[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundColor(.black)
                    .font(.title.bold())
                    .opacity(0.8)
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore).")
        }
        .alert(scoreTitle, isPresented: $gameLimit) {
            Button("Reset", action: resetScore)
        } message: {
            Text("Your final score is \(userScore).")
        }
    }
    
    func typeTapped(_ number: Int) {
        if playerMoves[number] == "Fire" && opponentType[0] == "Grass" && isStrong == true {
            scoreTitle = "Correct!"
            userScore += 1
        }
        else if playerMoves[number] == "Water" && opponentType[0] == "Fire" && isStrong == true {
            scoreTitle = "Correct!"
            userScore += 1
        }
        else if playerMoves[number] == "Grass" && opponentType[0] == "Water" && isStrong == true {
            scoreTitle = "Correct!"
            userScore += 1
        }
        else if playerMoves[number] == "Fire" && opponentType[0] == "Water" && isStrong == false {
            scoreTitle = "Correct!"
            userScore += 1
        }
        else if playerMoves[number] == "Water" && opponentType[0] == "Grass" && isStrong == false {
            scoreTitle = "Correct!"
            userScore += 1
        }
        else if playerMoves[number] == "Grass" && opponentType[0] == "Fire" && isStrong == false {
            scoreTitle = "Correct!"
            userScore += 1
        }
        else {
            scoreTitle = "Wrong! \(playerMoves[number]) is not \(effective) against \(opponentType[0])."
            userScore -= 1
        }
        showingScore = true
        gamesPlayed += 1
        
        if gamesPlayed == 10 {
            gameLimit = true
        }
    }
    
    func askQuestion() {
        opponentType.shuffle()
        isStrong.toggle()
        
        if isStrong {
            effective = "strong"
        }
        else {
            effective = "weak"
        }
    }
    
    func resetScore() {
        userScore = 0
        gamesPlayed = 0
        scoreTitle = ""
        gameLimit = false
        showingScore = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
