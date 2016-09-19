//
//  WarEngine.swift
//  Battleship
//
//  Created by Tong Lin on 9/17/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class WarEngine{
    let totalBlocks: Int
    var myShips = [Int]()
    private let ships = [5,4,3,3,2]
    private var battleField = [State]()
    
    init(totalBlocks:Int){
        self.totalBlocks = totalBlocks
        setupBattleField()
    }
    
    fileprivate enum State{
        case hit
        case miss
    }

    func checkLocation(location: [Int]) -> Bool {
        for i in myShips{
            for j in location{
                if i == j{
                    return false
                }
            }
        }
        return true
    }
    
    func addShips(direction: Int, ship: Int) -> [Int]{
        let randomNum = Int(arc4random_uniform(UInt32(totalBlocks)))
        var intArr = [Int]()
        if direction%2 == 0 && randomNum%10 <= 10-ship{
            for num in 0..<ship{
                intArr.append(randomNum+num)
            }
            
        }else if direction%2 == 1 && randomNum < 100-10*(ship-1){
            for num in 0..<ship{
                intArr.append(randomNum+10*num)
            }
        }else{
            intArr = addShips(direction: direction, ship: ship)
        }
        return intArr
    }
    
    func setupBattleField(){
        battleField = Array(repeating: .miss, count: totalBlocks)
        for ship in ships{
            let direction = Int(arc4random_uniform(UInt32(10)))
            let tempShip: [Int] = addShips(direction: direction, ship: ship)
            for i in tempShip{
                battleField[i] = .hit
                myShips.append(i)
            }
        }
    }
    
    func checkShip(_ cardIn: Int) -> Bool{
        assert(cardIn < battleField.count)  //helps with debugging
        return battleField[cardIn] == .hit
    }
}
