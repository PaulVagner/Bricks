//
//  StartViewController.swift
//  Break
//
//  Created by Paul Vagner on 10/8/15.
//  Copyright © 2015 Paul Vagner. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    
    @IBOutlet weak var topScoreLabel: UILabel!

    
    
    //sends user to GameViewController when "Play" is pressed
    @IBAction func Play(sender: AnyObject) {
    
        let gameVC = GameViewController()
        navigationController?.viewControllers = [gameVC]
        
        
        
        
    }
    override func viewDidLoad() {
       
        let topScore = GameData.mainData().topScore
        topScoreLabel.text = "High Score \(topScore)"
        
    }
    
}
