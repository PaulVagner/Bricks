//
//  GameData.swift
//  Break
//
//  Created by Jo Albright on 10/10/15.
//  Copyright © 2015 Jo Albright. All rights reserved.
//

import Foundation

private let _mainData = GameData()

class GameData: NSObject {

    class func mainData() -> GameData { return _mainData }
    
    var topScore = 0
    
    var currentScore = 0 {
        
        didSet {
            
            if currentScore > topScore { topScore = currentScore }
            
        }
        
    }
    
    var currentLevel = 0

    // levels = array of tuples where each tuple is made of 2 Int type values
    var levels: [(Int,Int)] = [
    
        (24,4),
        (6,3),
        (9,2), // (col,row)
        (11,2),
        (8,3),
        (9,3),
        (8,4),
        (8,4),
        (12,5),
        (14,3),
        (20,6)
        
    ]
    
}
