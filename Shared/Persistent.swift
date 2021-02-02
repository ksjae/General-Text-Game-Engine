//
//  Persistence.swift
//  Shared
//
//  Created by 김승재 on 2021/02/02.
//

import CoreData

struct PersistenceController {
    
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        var contents = ["여러분만의 게임 만들기, 원래는 어려웠습니다. 하지만 와따 스튜디오의 GTGE는 이 모든 것을 쉽게 만들어 드립니다. 글만 쓰면 당신만의 게임을 만들 수 있습니다. 단순한 코딩을 통해 다양한 게임을 만들 수 있습니다. 유니티로 텍스트 기반 게임을 만들려 하면서 얼마나 괴로우셨나요. 그래서 내놓았습니다 - General Text Game Engine.", "이렇게 보시는 것처럼, 그림을 비롯한 다양한 미디어 파일 지원도 포함됩니다. 모던한 텍스트 어드벤쳐를 지원하기 딱 좋은 엔진이죠. 최신 SwiftUI 기반으로 돌아가기 때문에 모든 Apple 플랫폼에서 돌아갑니다. 맥, 아이폰, 아이패드 모든 환경에서 막힘없이 돌아가죠.","DSL을 이용한 로직 설계도 계획 중이니, 추후 업데이트를 유심히 팔로우 해주시면 감사하겠습니다. (꾸벅)"]
        var imageNames = ["keyboard", ""]
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for content in contents {
            let newItem = Paragraph(context: viewContext)
            newItem.text = content
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Text_Game")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
