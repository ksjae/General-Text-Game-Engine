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

// Custom struct definition

struct Stat {
    var STR: Int
    var DEX: Int
    var CON: Int
    var INT: Int
    var WIS: Int
    var CHA: Int
}

enum DiceType {
    case d4
    case d6
    case d8
    case d10
    case d12
    case d20
    case one
}

class Item {
    var name: String!
    var desc: String = ""
    var modifier: Stat = Stat(STR: 0, DEX: 0, CON: 0, INT: 0, WIS: 0, CHA: 0)
    var id: UUID!
    var trueCost: Int = 0
    var consumable: Bool!
    init(name: String, description: String, modifier: Stat, cost: Int, consumable: Bool = false) {
        self.name = name
        self.desc = description
        self.modifier = modifier
        self.trueCost = cost
        self.id = UUID()
        self.consumable = consumable
    }
}


// Weapons
enum WeaponProperty {
    case ammunition
    case finesse
    case heavy
    case light
    case loading
    case range
    case reach
    case thrown
    case twohanded
    case versatile
}

class Weapon: Item {
    var damageType: DiceType!
    var properties: [WeaponProperty]!
    var normalRange, longRange: Int?
    init(name: String, description: String, modifier: Stat, cost: Int, damage: DiceType, properties: [WeaponProperty], normalRange: Int = 5, longRange: Int = 5) {
        super.init(name: name, description: description, modifier: modifier, cost: cost)
        self.damageType = damage
        if normalRange != 5 {
            self.normalRange = normalRange
            self.longRange = longRange
        }
    }
}

// Spells


// Moving stuff

class Creature: Item {
    var stat: Stat = Stat(STR: 0, DEX: 0, CON: 0, INT: 0, WIS: 0, CHA: 0)
    var armor: Int!
    var hp: Int!
    var weapon: Weapon!
    var challenge: Int!
}

class Actor: Item {
    
}
