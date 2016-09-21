//
//  BattleshipBrain.swift
//  Battleship
//
//  Created by Jason Gresh on 9/18/16.
//  Copyright © 2016 C4Q. All rights reserved.
//


import Foundation

class BattleshipBrain {
    enum Coordinate {
        enum Ship {
            case carrier(Int)
            case battleship(Int)
        }
        enum State {
            case hidden, shown
        }
        case occupied(State, Ship)
        case empty(State)
        
        mutating func tryToHit(){
            switch self {
            case .occupied(let state, let ship):
                switch state {
                case .hidden:
                    self = Coordinate.occupied(.shown, ship)
                case .shown:
                    break
                }
            case .empty:
                self = Coordinate.empty(.shown)
            }
        }
    }
    
    enum GamePhase{
        case Planning
        case Gaming
    }
    
    let rows: Int
    let columns: Int
    var count: Int
    var phase: GamePhase
    
    private var coordinates: [[Coordinate]]
    
    init(rows: Int, columns: Int){
        self.rows = rows
        self.columns = columns
        self.phase = .Planning
        self.coordinates = [[Coordinate]]()
        self.count = 0
        setupBoard()
    }
    
    
    func setupBoard() {
        for _ in 0..<rows {
            self.coordinates.append([Coordinate](repeating: .empty(.hidden), count: columns))
            
            // this just sets one hit per column
            //coordinates[r][c] = Coordinate.occupied(.hidden, .carrier(5))
        }
    }
    
    func setCoordinate(r: Int, c: Int){
        coordinates[r][c] = Coordinate.occupied(.hidden, .carrier(5))
        count += 1
    }
    
    func resetBoard() {
        self.coordinates = [[Coordinate]]()
        self.phase = .Planning
        self.count = 0
        setupBoard()
    }
    
    subscript(i: Int, j: Int) -> Coordinate {
        return coordinates[i][j]
    }
    
    func strike(atRow r: Int, andColumn c: Int){
        coordinates[r][c].tryToHit()
    }
    
    func delay(delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    func gameFinished() -> Bool {
        for r in 0..<rows {
            for c in 0..<columns {
                // if any occupied coordinates are hidden we're not done
                if case .occupied(.hidden, _) = coordinates[r][c] {
                    return false
                }
            }
        }
        return true
    }
}
