//
//  FirstViewController.swift
//  Battleship
//
//  Created by Jason Gresh on 9/16/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var buttonContainer: UIView!
    
    let totalBlocks: Int
    var shipFound = [Int]()
    
    let engine: WarEngine
    var loaded: Bool
    let resetTitle = "Reset"
    
    required init?(coder aDecoder: NSCoder) {
        self.totalBlocks = 100
        self.loaded = false
        self.engine = WarEngine(totalBlocks: self.totalBlocks)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if !loaded {
            setUpGameButtons(v: buttonContainer, totalButtons: self.totalBlocks, buttonsPerRow: 10)
            self.view.setNeedsDisplay()
        }
        loaded = true
    }
    
    func resetButtonColors() {
        for v in buttonContainer.subviews {
            if let button = v as? UIButton {
                button.backgroundColor = UIColor.cyan
                button.isEnabled = true
            }
        }
    }
    
    func handleReset() {
        shipFound.removeAll()
        engine.myShips.removeAll()
        resetButtonColors()
        engine.setupBattleField()
        setUpGameLabel()
    }
    
    func disableCardButtons() {
        for v in buttonContainer.subviews {
            if let button = v as? UIButton {
                button.isEnabled = false
            }
        }
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        handleReset()
    }
    
    func endGameCheck(){
        if engine.myShips.sorted() == shipFound.sorted(){
            gameLabel.text = "All ships sunk!"
            disableCardButtons()
        }
    }
    
    func buttonTapped(_ sender: UIButton) {
        gameLabel.text = sender.currentTitle
        if engine.checkShip(sender.tag - 1) {
            gameLabel.text = "Target found!"
            sender.backgroundColor = UIColor.green
            shipFound.append(sender.tag - 1)
            sender.isEnabled = false
            endGameCheck()
        } else {
            gameLabel.text = "Nope! Guess again."
            sender.backgroundColor = UIColor.gray
            sender.isEnabled = false
        }
        //print(engine.myShips.sorted())
        //print(shipFound.sorted())
    }
    
    func setUpGameLabel() {
        gameLabel.text = "Battleship!"
    }
    
    func setUpGameButtons(v: UIView, totalButtons: Int, buttonsPerRow : Int) {
        for i in 1...totalBlocks {
            let y = ((i - 1) / buttonsPerRow)
            let x = ((i - 1) % buttonsPerRow)
            let side : CGFloat = v.bounds.size.width / CGFloat(buttonsPerRow)
            
            let rect = CGRect(origin: CGPoint(x: side * CGFloat(x), y: (CGFloat(y) * side)), size: CGSize(width: side, height: side))
            let button = UIButton(frame: rect)
            button.tag = i
            button.backgroundColor = UIColor.cyan
            button.setTitle(String(i), for: UIControlState())
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            v.addSubview(button)
        }
        setUpGameLabel()
    }

}

