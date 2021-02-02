//
//  MainView.swift
//  Text Game
//
//  Created by 김승재 on 2021/02/02.
//

import SwiftUI

enum Page {
    case introduction
    case content
    case title
}

struct MainView: View {
    
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        switch viewRouter.currentPage {
            case .content:
                ContentView(viewRouter: viewRouter)
            case .introduction:
                IntroductionView(viewRouter: viewRouter)
            case .title:
                TitleScreenView(viewRouter: viewRouter)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewRouter: ViewRouter())
    }
}
