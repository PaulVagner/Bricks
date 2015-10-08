//
//  TopBarView.swift
//  Break
//
//  Created by Paul Vagner on 10/8/15.
//  Copyright © 2015 Paul Vagner. All rights reserved.
//

import UIKit

class TopBarView: UIView {

    var lives: Int = 0 {
        
        didSet {
           
            //remove current circles
            for circle in lifeView.subviews {
                
                circle.removeFromSuperview()
                
            }
            
            
            
            //add circles based on life count
            for l in 0..<lives {
             
                let circleTotal = lives * 10 + (lives - 1) * 5
                
                let circle = UIView(frame: CGRect(x: l * 15 - (circleTotal / 2), y: Int(lifeView.center.y) - 5, width: 10, height: 10))
                
                circle.layer.cornerRadius = 5
                circle.backgroundColor = UIColor.yellowColor()
                
                lifeView.addSubview(circle)
            }
            
        }
    }
   
    var score: Int = 0 {
    
        didSet {
           
            scoreLabel.text = "\(score)"
            
        }
    }
    
    private let titleLabel = UILabel(frame: CGRectMake(20, 0, 100, 50))
    private let scoreLabel = UILabel(frame: CGRectMake(0, 0, 100, 50))
    private let lifeView = UIView(frame: CGRectMake(0, 0, 0, 50))
    
    override func didMoveToSuperview() {
        
        score = 0
        lives = 15
        
        titleLabel.text = "BREAK"
        titleLabel.textColor = UIColor.greenColor()
        
        
        scoreLabel.text = "0"
        scoreLabel.frame.origin.x = frame.width - 120
        scoreLabel.textColor = UIColor.greenColor()
        scoreLabel.textAlignment = .Right
        
        lifeView.center.x = center.x
        
        addSubview(titleLabel)
        addSubview(scoreLabel)
        addSubview(lifeView)
        
        
        
    }
    
}
    

