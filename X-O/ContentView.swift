//
//  ContentView.swift
//  X-O
//
//  Created by Retaj Al-Otaibi on 6/27/20.
//  Copyright © 2020 Retaj Al-Otaibi. All rights reserved.
//

import SwiftUI

enum choice{
    case X, O, none
    
    var title: String{
    switch self{
    case .X: return "X"
    case .O: return "O"
    case .none: return ""
    }
    }
    
    mutating func toggle(){
        switch self {
        case .X: self = .O
        case .O: self = .X
        case .none: self = .none
        }
    }
    
  
}
struct player{
    var enabled: Bool
    var title: choice
    
}

class Env: ObservableObject{
    @Published var currentPlayer: choice = .X
    @Published var fields: [[player]] = Array<Array<player>>(repeating: Array<player>(repeating: player(enabled: true, title: .none), count: 3), count: 3)
    @Published var winner: choice = .none
    @Published var thereIsWinner: Bool = false
    @Published var Xcounter: Int = 0
    @Published var Ocounter: Int = 0
    
    
        func checkWinner(Choice: choice) -> choice{
        let r1 = fields[0][0].title == Choice && fields[0][1].title == Choice && fields[0][2].title == Choice
        let r2 = fields[1][0].title == Choice && fields[1][1].title == Choice && fields[1][2].title == Choice
        let r3 = fields[2][0].title == Choice && fields[2][1].title == Choice && fields[2][2].title == Choice
        let c1 = fields[0][0].title == Choice && fields[1][0].title == Choice && fields[2][0].title == Choice
        let c2 = fields[0][1].title == Choice && fields[1][1].title == Choice && fields[2][1].title == Choice
        let c3 = fields[0][2].title == Choice && fields[1][2].title == Choice && fields[2][2].title == Choice
        let d1 = fields[0][2].title == Choice && fields[1][1].title == Choice && fields[2][0].title == Choice
        let d2 = fields[0][0].title == Choice && fields[1][1].title == Choice && fields[2][2].title == Choice
        
        if  r1 || r2 || r3 || c1 || c2 || c3 || d1 || d2 {
            winner = Choice
            if Choice == .X{
                 Xcounter += 1
            }else if Choice == .O{
                 Ocounter += 1
            }
             thereIsWinner = true
            return winner
        }else {
            return .none
        }
    }
    
    func ckeckWinner2(){
        
        winner = checkWinner(Choice: currentPlayer)
        
        if winner != .none  {
            thereIsWinner = true
        }
        if winner == .X{
            Xcounter += 1
        }else if winner == .O{
            Ocounter += 1
        }
    
    }
    
    func computer(){
      //   print("😱")
        var array: [Int] = []
        var computerFields: [player] = []
        let number = Int.random(in: 0 ... 2)
        for i in fields.enumerated(){
           // array.append(contentsOf: i)
            array.append(i.offset)
            
        }
       
       // print(fields[array.randomElement()!])
         // print(fields[array.randomElement()!][array.randomElement()!])
        let rand = array.randomElement()!
        print("this is the rand ",rand)
        print("is this my number",number)
         // print(rand)
        if fields[rand][array.randomElement()!].title == .none && fields[rand][array.randomElement()!].enabled == true  {
            fields[rand][array.randomElement()!].title = .O
            fields[rand][array.randomElement()!].enabled == false
            
          //  print("this is the rand ",rand)
          //  print("is this my number",number)
          //print("😄",fields[rand][array.randomElement()!].title)//
            //[array.randomElement()!])
        }else {
             print("no sach field has been found")
        }
        print("🏵\(fields)")
        //  computerFields = array.filter{$0.title != choice.X || $0.title != choice.O}
        //  print("😅\(computerFields[number])")
        //fields[number].title = .O
        //  fields[number].enabled = false
    }
    
    
    
    
}


struct ContentView: View {
    @EnvironmentObject var env: Env
    var body: some View {
        ZStack {
           // background(Color.purple)
            LinearGradient(gradient: Gradient(colors: [Color.init(red: 0.4, green: 0.4, blue: 0.8),  .purple]), startPoint: .topLeading, endPoint: .topTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("\(env.currentPlayer.title) Turn")
                    .font(.custom("Avenir Next", size: 40))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(30)
           //     Spacer()
                HStack{
                    ScoreText(turnLabel: "X", turnCount: $env.Xcounter)
                    ScoreText(turnLabel: "O", turnCount: $env.Ocounter)
                }
                Spacer()
                XOGrid(animition: 0.2)
                Spacer()
                NewGameButton()
            }.alert(isPresented: $env.thereIsWinner) { () -> Alert in
                Alert(title: Text("\(self.env.winner.title) Won!!!"), message: Text("tap restart if you want to play again"), dismissButton: .default(Text("Restart"), action: {
                    self.env.fields = Array<Array<player>>(repeating: Array<player>(repeating: player(enabled: true, title: .none), count: 3), count: 3)
                    self.env.winner = .none
                    self.env.thereIsWinner = false
                    self.env.currentPlayer = .X
                }))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Env())
    }
}

struct XOButton: View {
    @EnvironmentObject var env: Env
    @State var c: Int
    @State var r: Int
    @State var animition: CGFloat
    @State var count = 0
    var body: some View {
        Text(env.fields[r][c].title.title)
            .bold()
            .font(.largeTitle)
            .frame(width: 90, height: 90)
            .background(env.fields[self.r][self.c].enabled ?    Color.init(red: 0.8, green: 0.7, blue: 0.9) : Color.init(red: 0.4, green: 0.4, blue: 0.6))
            .foregroundColor(.white)
            .cornerRadius(20)
            .animation(.default)
            .onTapGesture {
                self.count += 1
                
                if  self.env.fields[self.r][self.c].enabled
                    {
                        self.env.fields[self.r][self.c].title = .X
                        self.env.checkWinner(Choice: .X)
                        self.env.checkWinner(Choice: .O)
                    self.env.computer()
                    self.env.fields[self.r][self.c].enabled = false
                }
                
        }
    }
}


struct XOGrid: View {
    @State var animition: CGFloat
    @EnvironmentObject var env: Env
    var body: some View {
        VStack(spacing: 10){
            ForEach(0..<3, id: \.self){ r in
                HStack {
                    ForEach(0..<3, id: \.self){ c in
                        XOButton(c: c, r: r, animition: 0.2)
                    }
                }
                
            }
        }
    }
}

/* env.fields[self.r][self.c].enabled ?    Color.init(red: 0.18, green: 1.8, blue: 0.5) : Color.init(red: 0.4, green: 0.4, blue: 0.6
 */
 /* LinearGradient(gradient: Gradient(colors: [Color.init(red: 0.4, green: 0.4, blue: 0.9),  .purple]), startPoint: .topLeading, endPoint: .topTrailing)*/

struct NewGameButton: View {
    var body: some View {
        Text("another game!")
            .font(.custom("Avenir Next", size: 20))
            .foregroundColor(.purple)
            .shadow(radius: 10)
            .padding()
            .background(Color.white)
            .cornerRadius(30)
    }
}

struct ScoreText: View {
    @EnvironmentObject var env: Env
    @State var turnLabel: String
    @Binding var turnCount: Int
    var body: some View {
        Text("\(turnLabel) CORE\n      \(turnCount)")
            .font(.custom("Avenir Next", size: 15))
            .foregroundColor(.white)
            .shadow(radius: 10)
            .padding(30)
            .background(Color.init(red: 0.8, green: 0.7, blue: 0.9))
            .cornerRadius(30)
    }
    
}
