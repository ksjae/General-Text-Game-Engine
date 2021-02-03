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

struct ContentView: View {
    
    @State var showOverlay = true
    @StateObject var viewRouter: ViewRouter
    
    let storyFile = Bundle.main.url(forResource: "story", withExtension: "md")
    let contents = ["여러분만의 게임 만들기, 원래는 어려웠습니다. 하지만 와따 스튜디오의 GTGE는 이 모든 것을 쉽게 만들어 드립니다. 글만 쓰면 당신만의 게임을 만들 수 있습니다. 단순한 코딩을 통해 다양한 게임을 만들 수 있습니다. 유니티로 텍스트 기반 게임을 만들려 하면서 얼마나 괴로우셨나요. 그래서 내놓았습니다 - General Text Game Engine.", "이렇게 보시는 것처럼, 그림을 비롯한 다양한 미디어 파일 지원도 포함됩니다. 모던한 텍스트 어드벤쳐를 지원하기 딱 좋은 엔진이죠. 최신 SwiftUI 기반으로 돌아가기 때문에 모든 Apple 플랫폼에서 돌아갑니다. 맥, 아이폰, 아이패드 모든 환경에서 막힘없이 돌아가죠.","DSL을 이용한 로직 설계도 계획 중이니, 추후 업데이트를 유심히 팔로우 해주시면 감사하겠습니다. (꾸벅)"]
    
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
        .overlay(HUDView(isShowing: self.$showOverlay), alignment: .top)
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
    let fontSize = 14
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

struct HUDView: View {
    @Binding var isShowing : Bool
    var body: some View {
        VStack {
            Rectangle()
                .foregroundColor(.gray)
                .frame(height: 50)
                .overlay(
                    HStack() {
                        Button(action: {}){
                            Image(systemName: "person")
                        }.padding()
                        Spacer()
                        VStack{
                            Text("Player Name")
                            Text("Player stat : 1/2/3/4/5/6")
                        }
                        Spacer()
                        Button(action: {}){
                            Image(systemName: "gear")
                        }.padding()
                    })
        }.opacity(self.isShowing ? 1 : 0)
        
    }
}

/*
 
 Other codes for debugging purposes
 
 */

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())
    }
}


extension Color {
    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }
}
