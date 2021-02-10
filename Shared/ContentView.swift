//
//  ContentView.swift
//  Shared
//
//  Created by 김승재 on 2021/02/01.
//

import SwiftUI

/**

 Code for in-game displays (the ViewController/Scene where the player will mainly be
 
*/
//MARK:- Text View
struct ContentView: View {
    
    @State var showOverlay = true
    @StateObject var viewRouter: ViewRouter
    
    let contents = ["여러분만의 게임 만들기, 원래는 어려웠습니다. 하지만 와따 스튜디오의 GTGE는 이 모든 것을 쉽게 만들어 드립니다. 글만 쓰면 당신만의 게임을 만들 수 있습니다. 단순한 코딩을 통해 다양한 게임을 만들 수 있습니다. 유니티로 텍스트 기반 게임을 만들려 하면서 얼마나 괴로우셨나요. 그래서 내놓았습니다 - General Text Game Engine.", "이렇게 보시는 것처럼, 그림을 비롯한 다양한 미디어 파일 지원도 포함됩니다. 모던한 텍스트 어드벤쳐를 지원하기 딱 좋은 엔진이죠. 최신 SwiftUI 기반으로 돌아가기 때문에 모든 Apple 플랫폼에서 돌아갑니다. 맥, 아이폰, 아이패드 모든 환경에서 막힘없이 돌아가죠.","DSL을 이용한 로직 설계도 계획 중이니, 추후 업데이트를 유심히 팔로우 해주시면 감사하겠습니다. (꾸벅)"]
    let tempPlayer = Player(name: "John Apple", description: "", stat: Stat(STR: 2, DEX: 0, CON: 1, INT: 1, WIS: 0, CHA: 1), hp: 12, charClass: Classes.Rogue, race: Races.Human)
    let save = Save(player: Player(name: "John Apple", description: "", stat: Stat(STR: 2, DEX: 0, CON: 1, INT: 1, WIS: 0, CHA: 1), hp: 12, charClass: Classes.Rogue, race: Races.Human), currentFile: "Introduction", currentLineNo: 0)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            ScrollViewReader { scrollView in
                LazyVStack {
                    ForEach(self.contents, id: \.self){content in
                        ParagraphView(textContent: content, picturePath: "generic")
                    }
                }
                .padding(EdgeInsets(top: 100, leading: 12, bottom: 5, trailing: 12))
            }
        }
        .overlay(HUDView(isShowing: self.$showOverlay, player: tempPlayer), alignment: .top)
        .onTapGesture {
            withAnimation {
                self.showOverlay.toggle()
            }
        }
    }
}

struct ParagraphView: View {
    let textContent: String?
    let picturePath: String?
    let fontSize: Int = 14
    var body: some View {
        if let content = self.textContent {
            Text(content)
                .font(Font.custom("KoPubWorldBatangPL", size: CGFloat(self.fontSize)))
                .padding(.bottom)
                .lineSpacing(CGFloat(self.fontSize)*0.3)
                .layoutPriority(3)
        }
        
        if let path = picturePath {
            Image(path)
                .resizable()
                .scaledToFill()
                .frame(width: 250.0, alignment: .center)
        }
    }
}

//MARK:- HUD
struct HUDView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var isShowing : Bool
    @State var settingsPressed: Bool = false
    @State var characterPressed: Bool = true
    var player: Player
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(Color("Background"))
                .edgesIgnoringSafeArea(.all)
                .frame(height: 50, alignment: .top)
                .overlay(
                    HStack(alignment: .top) {
                        Button(action: {
                            settingsPressed = false
                            characterPressed.toggle()
                        }){
                            Image(systemName: "person")
                        }.padding()
                        Spacer()
                        VStack{
                            Text(player.name)
                            HStack {
                                Text("♥ \(player.hp)/\(player.hpMax)")
                                Text("Armor \(player.armor)")
                                Text("❍ \(player.money)")
                                Text("LV \(player.level)")
                            }
                        }
                        Spacer()
                        Button(action: {
                            characterPressed = false
                            settingsPressed.toggle()
                        }){
                            Image(systemName: "gear")
                        }.padding()
                    }.frame(height: 50)
                )
            ZStack {
                GeometryReader { geometry in
                    if settingsPressed {
                        Rectangle()
                            .frame(width: geometry.size.width - 20, height: 300)
                            .foregroundColor(Color("Background"))
                            .overlay(SettingsView())
                    }
                    
                    if characterPressed {
                        Rectangle()
                            .frame(width: geometry.size.width - 20, height: 300)
                            .foregroundColor(Color("Background"))
                            .overlay(PlayerView(player: player, width: geometry.size.width))
                    }
                }
            }
        }
        .opacity(self.isShowing ? 1 : 0)
    }
}

struct SettingsView: View {
    var body: some View {
        CheckboxField(
            id: "sfx",
            label: "Sound Effects",
            size: 14,
            textSize: 14,
            callback: {}
        )
        CheckboxField(
            id: "BGM",
            label: "Background Music",
            size: 14,
            textSize: 14,
            callback: {}
        )
    }
}

struct PlayerView: View {
    let player: Player
    let width: CGFloat
    let statNames = ["Strength", "Dexterity", "Constitution", "Intelligence", "Wisdom", "Charisma"]
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person.crop.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                VStack {
                    Text("\(player.name)")
                        .font(.title)
                    Text("A \(player.race.rawValue) \(player.characterClass.rawValue)")
                }
            }.padding(.top).frame(width: width - 40, alignment: .center)
            HStack {
                ForEach(0..<6) { index in
                    VStack {
                        Text("\(self.statNames[index])")
                            .font(.caption)
                        Text("\(player.stat.list()[index])")
                    }
                }
            }.padding(.top)
            Text("Equipment")
                .font(.title2)
                .frame(width: width - 40, alignment: .leading)
                .padding(.top)
                .padding(.leading)
            ForEach (player.inventory) { inven in
                Button(action: {
                    // show item details
                }, label: {
                    Text("\(inven.name)")
                })
            }
        }
        
    }
}

//MARK:- Battle

struct BattleView {
    var body: some View {
        Text("Fight!")
    }
}


//MARK: Merchant

struct ItemView {
    var body: some View {
        Text("Buy!")
    }
}

struct MerchantView {
    var body: some View {
        Text("Buy!")
    }
}


/*
 
 //MARK:- Other codes
 
 */

//MARK: Checkbox Field
struct CheckboxField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int
    let callback: ()->()
    
    init(
        id: String,
        label:String,
        size: CGFloat = 10,
        color: Color = Color.black,
        textSize: Int = 14,
        callback: @escaping ()->()
        ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self.callback = callback
    }
    
    @State var isMarked:Bool = false
    
    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.callback()
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square" : "square")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
                Text(label)
                    .font(Font.system(size: size))
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
    }
}
