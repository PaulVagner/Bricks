//
//  StartViewController.swift
//  Break
//
//  Created by Paul Vagner on 10/8/15.
//  Copyright © 2015 Paul Vagner. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBAction func Play(sender: AnyObject) {
    
        let gameVC = GameViewController()
        navigationController?.viewControllers = [gameVC]
        
        
        
        
    }
    

}
