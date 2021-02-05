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
    
    mutating func add(stat: Stat) {
        self.CHA += stat.CHA
        self.CON += stat.CON
        self.DEX += stat.DEX
        self.INT += stat.INT
        self.WIS += stat.WIS
        self.STR += stat.STR
    }
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



class Item: Equatable {
    var name: String!
    var desc: String = ""
    var modifier: Stat = Stat(STR: 0, DEX: 0, CON: 0, INT: 0, WIS: 0, CHA: 0)
    var id: UUID!
    var trueCost: Int = 0
    var consumable: Bool!
    var hpMod: Int
    init(name: String, description: String, modifier: Stat, cost: Int, hp: Int = 0, consumable: Bool = false) {
        self.name = name
        self.desc = description
        self.modifier = modifier
        self.trueCost = cost
        self.id = UUID()
        self.hpMod = hp
        self.consumable = consumable
    }
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
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

enum DamageType {
    case cleaving
    case slashing
    case thrusting
    case tearing
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
class Spell: Weapon {
    var isRitual: Bool!, isCantrip: Bool!
    var castingTime: Int = 0
    var area: Int = 1 // # of enemy affected
    init(name: String, description: String, modifier: Stat, cost: Int, damage: DiceType, properties: [WeaponProperty], normalRange: Int = 5, longRange: Int = 5, area: Int = 1, castingTime: Int = 0, isRitual: Bool = false, isCantrip: Bool = false) {
        super.init(name: name, description: description, modifier: modifier, cost: cost, damage: damage, properties: properties, normalRange: normalRange, longRange: longRange)
        self.area = area
        self.castingTime = castingTime
        self.isRitual = isRitual
        self.isCantrip = isCantrip
    }
}

// Moving stuff

class Creature: Item {
    var stat: Stat = Stat(STR: 0, DEX: 0, CON: 0, INT: 0, WIS: 0, CHA: 0)
    var armor: Int!
    var hp: Int!
    var weapons: [Weapon] = []
    var spells: [Spell] = []
    var challenge: Int!
    init(name: String, description: String, modifier: Stat, cost: Int, hp: Int) {
        super.init(name: name, description: description, modifier: modifier, cost: cost)
        self.hp = hp
    }
    func AddWeapon(weapon: Weapon) {
        self.weapons.append(weapon)
    }
    func AddSpell(spell: Spell) {
        self.spells.append(spell)
    }
}

class Actor: Creature {
    var inventory: [Item] = []
    func addInventory(item: Item) {
        self.inventory.append(item)
    }
}

class Player: Actor {
    
}
