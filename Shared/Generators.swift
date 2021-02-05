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
