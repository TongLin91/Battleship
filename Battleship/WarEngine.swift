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
    var myShip = [Int]()
    let ships = [5,4,3,3,2]
    private  var battleField = [State]()
    
    init(totalBlocks:Int){
        self.totalBlocks = totalBlocks
        setupBattleField()
    }
    
    fileprivate enum State{
        case hit
        case miss
    }

    func checkLocations(location: [Int]) -> Bool {
        for i in myShip{
            for j in location{
                if i == j{
                    return false
                }
            }
        }
        return true
    }
    
    func setupBattleField(){
        battleField = Array(repeating: .miss, count: totalBlocks)
        myShip.removeAll()
        for ship in ships{
            var condi = false
            let direction = Int(arc4random_uniform(UInt32(10)))
            while condi == false{
                var tempLocation = [Int]()
                let randomNum = Int(arc4random_uniform(UInt32(totalBlocks)))
                if direction%2 == 0{
                    if randomNum%10 <= 10-ship{
                        for num in 0..<ship{
                            tempLocation.append(randomNum+num)
                        }
                    }
                }else{
                    if randomNum < 100-10*(ship-1){
                        for num in 0..<ship{
                            tempLocation.append(randomNum+10*num)
                        }
                    }
                }
                if tempLocation.count > 0{
                    if checkLocations(location: tempLocation){
                        for i in tempLocation{
                            battleField[i] = .hit
                            myShip.append(i)
                        }
                        condi = true
                    }
                }
            }
        }
    }
    
    func checkCard(_ cardIn: Int) -> Bool{
        assert(cardIn < battleField.count)  //helps with debugging
        return battleField[cardIn] == .hit
    }
}
