//
//  Generators.swift
//  Text Game
//
//  Created by 김승재 on 2021/02/03.
//

import Foundation

// Action generator for battle, market, etc.

func useItem(actor: Player, item: Item) -> Player {
    actor.stat.add(stat: item.modifier)
    actor.hp += item.hpMod
    return actor
}

func generateStat() -> Stat {
    var diceRolls: [Int]
    var s = [0,0,0,0,0,0]
    for i in 0..<6 {
        diceRolls = [Int.random(in: 1...6),Int.random(in: 1...6),Int.random(in: 1...6),Int.random(in: 1...6)]
        let result = diceRolls.reduce(0, +) - diceRolls.min()!
        s[i] = result
    }
    return Stat(STR: s[0], DEX: s[1], CON: s[2], INT: s[3], WIS: s[4], CHA: s[5])
}

func returnRaceModifier(race: Races) -> Stat {
    return Stat(STR: 0, DEX: 0, CON: 1, INT: 0, WIS: 0, CHA: 0)
}

func nextLevelXPRequirement(level: Int) -> Int {
    return 8000
}

class Fight {
    // Each Fight() is for a fight scene.
    var player: Player
    var allies: [Actor]
    var enemies: [Creature]
    
    init (player: Player, allies: [Actor], enemies: [Creature]) {
        self.allies = allies
        self.enemies = enemies
        self.player = player
    }
    
    func battleIsWon() -> Bool {
        if self.enemies.isEmpty {
            return true
        } else {
            return false
        }
    }
    func battleIsLost() -> Bool {
        if self.allies.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func processTurn(weaponOfChoice: Weapon? = nil, target: Creature? = nil, item: Item? = nil){
        if let playerWeapon = weaponOfChoice {
            guard let creatureIndex = self.enemies.firstIndex(of: target!) else {
                print("Wait, there is no enemy of sort!")
                return
            }
            // Roll dice
            
        } else if let itemToUse = item {
            self.player = useItem(actor: self.player, item: itemToUse)
            if itemToUse.consumable && self.player.inventory.contains(itemToUse) {
                self.player.inventory.remove(at: self.player.inventory.firstIndex(of: itemToUse)!)
            }
        } else {
            print("Hey, invalid calling procedure!!!")
            
        }
    }
    
    func getFightResult() -> Dictionary<String, Any> {
        return ["allies": self.allies]
    }
}

class Trade {
    
}

class Choice {
    
}

class GM {
    var flags: [String] = []
    func commandHandler(rawLine: String) {
        var fontSize = 2
        let regex = try? NSRegularExpression(pattern: #"!(.*?) (.*)"#)
        if let match = regex?.firstMatch(in: rawLine, options: [], range: NSRange(location: 0, length: rawLine.utf16.count)) {
            switch rawLine {
                case "SET":
                    fontSize = 33
                case "UNSET":
                    fontSize = 24
                case "END":
                    fontSize = 18
                case "PLAYER":
                    fontSize = 23
                case "ACTOR":
                    fontSize = -1
                case "FIGHT":
                    fontSize = 123
                case "WON":
                    fontSize = 123
                case "LOST":
                    fontSize = 123
                case "CHOICE":
                    fontSize = 123
                case "IF":
                    fontSize = 123
                default:
                    let flag = String(rawLine[Range(match.range(at: 1), in: rawLine)!])
                    if self.flags.contains(flag) {
                        // The following contents are visible when FLAG is set
                    } else {
                        self.flags.append(flag)
                    }
            }
        }
    }
}
