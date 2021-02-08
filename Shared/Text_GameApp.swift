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

struct Stat: Codable {
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

enum DiceType: String, Codable {
    case d4
    case d6
    case d8
    case d10
    case d12
    case d20
    case one
}

class Item: Equatable, Codable {
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
enum WeaponProperty: String, Codable {
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

enum DamageType: String, Codable {
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
    
    enum WeaponKeys: CodingKey {
            case damagetype, properties, normalrange, longrange
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: WeaponKeys.self)
        self.damageType = try container.decode(DiceType.self, forKey: .damagetype)
        self.longRange = try container.decode(Int.self, forKey: .longrange)
        self.normalRange = try container.decode(Int.self, forKey: .normalrange)
        self.properties = try container.decode([WeaponProperty].self, forKey: .properties)
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
    
    enum SpellKeys: CodingKey {
        case isritual, iscantrip, castingtime, area
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: SpellKeys.self)
        self.area = try container.decode(Int.self, forKey: .area)
        self.castingTime = try container.decode(Int.self, forKey: .castingtime)
        self.isCantrip = try container.decode(Bool.self, forKey: .iscantrip)
        self.isRitual = try container.decode(Bool.self, forKey: .isritual)
    }
}

// Moving stuff

class Creature: Item {
    var stat: Stat = Stat(STR: 0, DEX: 0, CON: 0, INT: 0, WIS: 0, CHA: 0)
    var armor: Int!
    var hp: Int!
    var hpMax: Int!
    var weapons: [Weapon] = []
    var spells: [Spell] = []
    var challenge: Int!
    init(name: String, description: String, modifier: Stat, hp: Int) {
        super.init(name: name, description: description, modifier: modifier, cost: 0)
        self.hp = hp
        self.hpMax = hp
        self.armor = 0
        self.challenge = 5
    }
    
    enum CreatureKeys: CodingKey {
        case stat, armor, hp, weapons, spells, challenge
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CreatureKeys.self)
        self.stat = try container.decode(Stat.self, forKey: .stat)
        self.armor = try container.decode(Int.self, forKey: .armor)
        self.hp = try container.decode(Int.self, forKey: .hp)
        self.weapons = try container.decode([Weapon].self, forKey: .weapons)
        self.spells = try container.decode([Spell].self, forKey: .spells)
        self.challenge = try container.decode(Int.self, forKey: .challenge)
    }
    func AddWeapon(weapon: Weapon) {
        self.weapons.append(weapon)
    }
    func AddSpell(spell: Spell) {
        self.spells.append(spell)
    }
}

enum Classes: String, Codable, Equatable, CaseIterable {
    case Barbarian, Wizard, Rogue
}

enum Races: String, Codable, Equatable, CaseIterable {
    case Human, Elf, Dwarf
}

class Actor: Creature {
    var inventory: [Item] = []
    func addInventory(item: Item) {
        self.inventory.append(item)
    }
    override init(name: String, description: String, modifier: Stat, hp: Int) {
        super.init(name: name, description: description, modifier: modifier, hp: hp)
    }
    enum ActorKeys: CodingKey {
        case money, level, xp
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: ActorKeys.self)
        self.inventory = try container.decode([Item].self, forKey: .money)
    }
}

struct SpellSlot: Codable {
    var level: Int
    var spell: Spell
}

class Player: Actor {
    var money: Int = 16
    var level: Int = 3
    var xp: Int = 6554
    override init(name: String, description: String, modifier: Stat, hp: Int) {
        super.init(name: name, description: description, modifier: modifier, hp: hp)
    }
    enum PlayerKeys: CodingKey {
        case money, level, xp
    }
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: PlayerKeys.self)
        self.money = try container.decode(Int.self, forKey: .money)
        self.level = try container.decode(Int.self, forKey: .level)
        self.xp = try container.decode(Int.self, forKey: .xp)
    }
}

struct Save: Codable {
    var player: Player
    var currentFile: String
    var currentLine: String
}
