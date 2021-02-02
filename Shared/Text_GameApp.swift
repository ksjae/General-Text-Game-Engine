//
//  Text_GameApp.swift
//  Shared
//
//  Created by 김승재 on 2021/02/01.
//

import SwiftUI

@main
struct Text_GameApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            MainView(viewRouter: ViewRouter())
        }
    }
}
