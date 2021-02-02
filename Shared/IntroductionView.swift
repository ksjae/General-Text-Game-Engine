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
        Button(action: {
            withAnimation {
                viewRouter.currentPage = .content
            }
        }, label: {
            Text("Continue")
        })
    }
}


struct IntroductionView: View {
    /*
     Character creation (aka new game) menu
     */
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {

                VStack {
                    Text("Welcome to")
                        .fontWeight(.black)
                        .font(.system(size: 36))

                    Text("Mythical Lands")
                        .fontWeight(.black)
                        .font(.system(size: 36))
                        .foregroundColor(Color.accentColor)
                }
                Spacer(minLength: 30)
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading) {
                        Text("First, who are you?")
                        TextField("Name of your character", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                        Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Gender")) {
                            Text("man").tag(1)
                            Text("woman").tag(2)
                            Text("other").tag(3)
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("And you are a...")
                        Picker(selection: /*@START_MENU_TOKEN@*/.constant(1)/*@END_MENU_TOKEN@*/, label: Text("Character Type")) {
                            Text("Barbarian").tag(1)
                            Text("Rogue").tag(2)
                            Text("Wizard").tag(3)
                        }
                    }
                    
                    VStack {
                        Text("Now, roll the dice for your ability points.")
                        HStack(){
                            Text("Hit Points")
                            Text("5")
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                                Text("Roll dice")
                            })
                        }
                    }
                }
                .padding(.horizontal)

                Button(action: {
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
}

struct IntroductionView_Previews: PreviewProvider {
    static var previews: some View {
        IntroductionView(viewRouter: ViewRouter())
    }
}
