//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Isaac Dyess on 6/19/23.
//

import SwiftUI

struct ContentView: View {
    @State private var rotationAmount0 = 0.0
    @State private var rotationAmount1 = 0.0
    @State private var rotationAmount2 = 0.0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var userRound = 1
    @State private var gameOver = false
    @State private var chosenFlag = -1
    @State private var rotationAmount:Double = 0.0
    @State private var opacityAmount:Double = 1.0
    @State private var scaleAmount:Double = 1.0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .titleStyle()
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.secondary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            chosenFlag = number
                            rotationAmount = 0.0
                            opacityAmount = 1.0
                            withAnimation {
                                rotationAmount = 360
                                opacityAmount = 0.25
                                scaleAmount = 0.5
                            }
                        } label: {
                            FlagImage(country: countries[number],
                                      rotationAmount: (chosenFlag == number ? rotationAmount : 0),
                                      opacityAmount: (chosenFlag == number ? 1.0 : opacityAmount),
                                      scaleAmount: (chosenFlag == number ? 1.0 : scaleAmount))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Text("Round \(userRound)")
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .alert(scoreTitle, isPresented: $showingScore) {
                if !gameOver {
                    Button("Continue", action: askQuestion)
                } else {
                    Button("Restart", action: newGame)
                }
            } message: {
                if !gameOver {
                    Text("Your score is \(userScore)")
                } else {
                    Text("Your final score is \(userScore)")
                }
            }
        }
    }
    
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            if userRound < 8 {
                scoreTitle = "Correct!"
                userScore += 1
                userRound += 1
            } else {
                scoreTitle = "Correct! Game Over."
                gameOver = true
            }
        } else {
            if userRound < 8 {
                scoreTitle = "Wrong, that flag is for \(countries[number])."
                userRound += 1
            } else {
                scoreTitle = "Wrong. Game Over."
                gameOver = true
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        chosenFlag = -1
        rotationAmount = 0.0
        opacityAmount = 1.0
        scaleAmount = 1.0
    }
    
    func newGame() {
        userScore = 0
        userRound = 1
        gameOver = false
        askQuestion()
    }
}

struct FlagImage: View {
    var country: String
    var rotationAmount: Double
    var opacityAmount: Double
    var scaleAmount: Double

    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .scaleEffect(scaleAmount)
            .rotationEffect(.degrees(rotationAmount))
            .opacity(opacityAmount)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
