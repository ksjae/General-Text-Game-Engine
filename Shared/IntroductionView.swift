//
//  IntroductionView.swift
//  Text Game
//
//  Created by 김승재 on 2021/02/02.
//

import SwiftUI

/*
 
 Code for
 1) initial launch handling
 2) Main menu
 3) Character setup menu
 
 */

struct TitleScreenView: View {
    /*
     Main Menu
     */
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        Text("General Text Game Engine™")
            .font(.title)
        Button(action: {
            withAnimation {
                viewRouter.currentPage = .introduction
            }
        }, label: {
            Text("New Game")
        })
        if let _ = UserDefaults.standard.string(forKey: "Savefile") {
            Button(action: {
                withAnimation {
                    viewRouter.currentPage = .content
                }
            }, label: {
                Text("Continue")
            })
        }
        Button(action: {
            withAnimation {
                viewRouter.currentPage = .about
            }
        }, label: {
            Text("About")
        })
    }
}


struct IntroductionView: View {
    /*
     Character creation (aka new game) menu
     */
    @StateObject var viewRouter: ViewRouter
    
    @State private var selectedGender = 1
    @State private var selectedRace = Races.Human
    @State private var selectedClass = Classes.Barbarian
    @State private var stat = Stat(STR: 0, DEX: 0, CON: 0, INT: 0, WIS: 0, CHA: 0)
    
    var body: some View {
            VStack(alignment: .center) {
                VStack {
                    if let _ = UserDefaults.standard.string(forKey: "hasPlayed") {
                        Text("Welcome back to")
                            .fontWeight(.black)
                            .font(.system(size: 36))
                    } else {
                        Text("Welcome to")
                            .fontWeight(.black)
                            .font(.system(size: 36))
                    }

                    Text("Mythical Lands")
                        .fontWeight(.black)
                        .font(.system(size: 36))
                        .foregroundColor(Color.accentColor)
                }
                VStack(alignment: .leading, spacing: 30) {
                    TextField("Name of your character", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    Text("I want to be a...")
                    GeometryReader { geometry in
                        HStack(alignment: .center) {
                            Picker(selection: $selectedGender, label: Text("Gender")) {
                                Text("Male").tag(1)
                                Text("Female").tag(2)
                                Text("Generic").tag(3)
                            }.frame(width: geometry.size.width/3 - 20, height: 150).clipped()
                            Picker(selection: $selectedRace, label: Text("Race Type")) {
                                ForEach(Races.allCases, id: \.self) {
                                        Text($0.rawValue)
                                }
                            }.frame(width: geometry.size.width/3, height: 150).clipped()
                            Picker(selection: $selectedClass, label: Text("Character Type")) {
                                ForEach(Classes.allCases, id: \.self) {
                                    Text($0.rawValue)
                                }
                            }.frame(width: geometry.size.width/3, height: 150).clipped()
                        }.frame(width: geometry.size.width, height: 90, alignment: .bottom).clipped()
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Now, roll the dice for your ability points.")
                        
                        HStack {
                            Text("Strength")
                            Text(String(self.stat.STR))
                            let mod = returnRaceModifier(race: selectedRace).STR
                            if mod > 0 {
                                Text("+\(mod)")
                            } else if mod < 0 {
                                Text("-\(mod)")
                            }
                        }
                        HStack {
                            Text("Dexterity")
                            Text(String(self.stat.DEX))
                            let mod = returnRaceModifier(race: selectedRace).DEX
                            if mod > 0 {
                                Text("+\(mod)")
                            } else if mod < 0 {
                                Text("-\(mod)")
                            }
                        }
                        HStack {
                            Text("Constitution")
                            Text(String(self.stat.CON))
                            let mod = returnRaceModifier(race: selectedRace).CON
                            if mod > 0 {
                                Text("+\(mod)")
                            } else if mod < 0 {
                                Text("-\(mod)")
                            }
                        }
                        HStack {
                            Text("Intelligence")
                            Text(String(self.stat.INT))
                            let mod = returnRaceModifier(race: selectedRace).INT
                            if mod > 0 {
                                Text("+\(mod)")
                            } else if mod < 0 {
                                Text("-\(mod)")
                            }
                        }
                        HStack {
                            Text("Wisdom")
                            Text(String(self.stat.WIS))
                            let mod = returnRaceModifier(race: selectedRace).WIS
                            if mod > 0 {
                                Text("+\(mod)")
                            } else if mod < 0 {
                                Text("-\(mod)")
                            }
                        }
                        HStack {
                            Text("Charisma")
                            Text(String(self.stat.CHA))
                            let mod = returnRaceModifier(race: selectedRace).CHA
                            if mod > 0 {
                                Text("+\(mod)")
                            } else if mod < 0 {
                                Text("-\(mod)")
                            }
                        }
                    }
                    Button(action: {
                        self.stat = generateStat()
                    }, label: {
                        Text("Roll dice")
                    })
                }
                .padding(.horizontal)

                Button(action: {
                    // SAVE to savefile - THIS BREAKS PREVIEW
                    // UserDefaults.standard.set("{}", forKey: "Savefile")
                    withAnimation {
                        viewRouter.currentPage = .content
                    }
                }) {
                    Text("Continue")
                }
                .padding()
                .cornerRadius(40)
                .padding(.horizontal, 20)
        }
    }
}

struct AboutView: View {
    @StateObject var viewRouter: ViewRouter
    var body: some View {
        Text("IN DEVELOPMENT.")
        Button(action: {
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        }, label: {
            Text("Clear Settings")
        })
    }
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView(viewRouter: ViewRouter())
    }
}
