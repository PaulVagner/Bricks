//
//  GameViewController.swift
//  Break
//
//  Created by Paul Vagner on 10/8/15.
//  Copyright © 2015 Paul Vagner. All rights reserved.
//

import UIKit

import AVFoundation



enum BoundaryType: String {
    
    case Floor, LeftWall, RightWall, Ceiling
    
}

class GameViewController: UIViewController, UIDynamicAnimatorDelegate, UICollisionBehaviorDelegate, AVAudioPlayerDelegate {
    
    // sets "animator" to UIDynamicAnimator
    var animator: UIDynamicAnimator!
    
    //creates behavior variables
    let ballBehavior = UIDynamicItemBehavior()
    let brickBehavior = UIDynamicItemBehavior()
    let paddleBehavior = UIDynamicItemBehavior()
    
    var attachment: UIAttachmentBehavior?
    
    //gravity
    let gravity = UIGravityBehavior()
    //collision
    let collision = UICollisionBehavior()
    //topbar
    let topBar = TopBarView(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
    //paddle
    let paddle = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 10))
    //audio player
    var players = [AVAudioPlayer]()
    
    
    // MARK: -  ALL METHODS 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameData.mainData().currentScore = 0
        
               // MARK: Background
        
        let background = UIImageView(image: UIImage(named: "background"))
        background.frame = view.frame
        view.addSubview(background)
        
        //topbar
        //MARK: TopBar
        topBar.frame.size.width = view.frame.width
        view.addSubview(topBar)
        
        //setup Behaviors
        setupBehaviors()
        
        //sets and creates the dimentions of the ball.
        
        //run create game elements
        createPaddle()
        createBall()
        createBricks()
        
    } // end viewDidLoad()
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        
        
        for brick in brickBehavior.items as! [UIView] {
            
            if brick === item1  || brick == item2 as! UIView {
              
                playSound("Beep")
                
                //removes the brick from the array.
                brickBehavior.removeItem(brick)
                //removes the collision placeholder where the brick was.
                collision.removeItem(brick)
                //removes the brick location.
                brick.removeFromSuperview()
                
                topBar.score += 5
                GameData.mainData().currentScore += 15
                
            }
            
        }
        playSound("Bloop")

        
        //check brick count
        
        if brickBehavior.items.count == 0 {
            
            //you win
            GameData.mainData().currentLevel++
            
            endGame()
            
        }
        
        
    } // end 2 items contact (ball hitting the brick)
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        
        
        if let idString = identifier as? String, let boundaryName = BoundaryType(rawValue: idString) {
            
            switch boundaryName {
                
            case .Ceiling : print("I can fly high")
                
            case .Floor :
                
                if let ball = item as? UIView {
                    
                    
                    ballBehavior.removeItem(ball)
                    collision.removeItem(ball)
                    ball.removeFromSuperview()
                    
                    
                }
                // Game Over
                
                if topBar.lives == 0 {
                    
                    GameData.mainData().currentLevel = 0
                    endGame()
                    
                    
                    
                } else {
                    
//                    print("Burn Baby Burn!!! - DISCO INFERNO!!!")
                    topBar.lives--
                    
                    createBall()
                    
                }
                
            case .LeftWall : print("HIT Left")
                
            case .RightWall : print("Hit Right")
                
            }
        }
        
    } // end when item & boundary collision
    
    // MARK: - 👇 TOUCH METHODS
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //this causes to run the code with the "TouchesMoved"
        touchesMoved(touches, withEvent: event)
        
    } //end touches began
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            
            let point = touch.locationInView(view)
            
            attachment?.anchorPoint.x = point.x
        } // end touches moved
        
    }
    // MARK: - Create Game Elements
    // MARK: Brick Setup
    func createBricks() {
        
        let level = GameData.mainData().currentLevel
        
        let (cols,rows) = GameData.mainData().levels[level]
        
        //Bricks and their dimentions
        
        let brickH = 30
        let brickSpacing = 3
        
        
        let totalSpacing = (cols + 1) * brickSpacing
        let brickW = (Int(view.frame.width) - totalSpacing) / cols
        
        
        for c in 0..<cols {
            
            for r in 0..<rows {
               
                //sets the position of the bricks on screen
                let x = c * (brickW + brickSpacing) + brickSpacing
                let y = r * (brickH + brickSpacing) + brickSpacing + 60
                
                let brick = UIView(frame: CGRect(x: x, y: y, width: brickW, height: brickH))
                brick.backgroundColor = UIColor.purpleColor()
                brick.layer.cornerRadius = 5
                
                view.addSubview(brick)
                
                collision.addItem(brick)
                brickBehavior.addItem(brick)
                
                
            }
        }
        
    }
    //MARK: Ball setup
    func createBall() {
        
        let ball = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        ball.layer.cornerRadius = 10
        ball.backgroundColor = UIColor.greenColor()
        view.addSubview(ball)
        
        ball.center.x = paddle.center.x
        ball.center.y = paddle.center.y - 20
        
        ballBehavior.addItem(ball)
        //        gravity.addItem(ball)
        collision.addItem(ball)
        
        // push
        let push = UIPushBehavior(items: [ball], mode: UIPushBehaviorMode.Instantaneous)
        
        
        push.pushDirection = CGVector(dx: 0.1, dy: -0.1)
        
        animator.addBehavior(push)
        
        
        print(animator.behaviors.count)
    }
    
    func createPaddle() {
        
        paddle.backgroundColor = UIColor.blueColor()
        paddle.layer.cornerRadius = 5
        
        paddle.center = CGPoint(x: view.center.x, y: view.frame.height - 40)
        
        view.addSubview(paddle)
        
        paddleBehavior.addItem(paddle)
        
        collision.addItem(paddle)
        
        attachment = UIAttachmentBehavior(item: paddle, attachedToAnchor: paddle.center)
        
        animator.addBehavior(attachment!)
        
        
    }
    
    // MARK: - Setup World
    
    func setupBehaviors() {
        
        animator = UIDynamicAnimator(referenceView: view)
        
        // Do any additional setup after loading the view.
        animator.delegate = self
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(ballBehavior)
        animator.addBehavior(brickBehavior)
        animator.addBehavior(paddleBehavior)
        
        
        //setup ball behavior
        ballBehavior.friction = 0
        ballBehavior.resistance = 0
        ballBehavior.elasticity = 1
        ballBehavior.allowsRotation = false
        
        collision.collisionDelegate = self
        
        //setup brick behavior
        brickBehavior.anchored = true
        
        //setup paddle behavior
        paddleBehavior.allowsRotation = false
        
        
        //wrap view in boundary
        collision.translatesReferenceBoundsIntoBoundary = true
        
        collision.addBoundaryWithIdentifier(BoundaryType.Ceiling.rawValue, fromPoint: CGPoint(x: 0, y: 40), toPoint: CGPoint(x: view.frame.width, y: 40))
        collision.addBoundaryWithIdentifier(BoundaryType.Floor.rawValue, fromPoint: CGPoint(x: 0, y: view.frame.height - 10), toPoint: CGPoint(x: view.frame.width, y: view.frame.height - 10))
        collision.addBoundaryWithIdentifier(BoundaryType.LeftWall.rawValue, fromPoint: CGPoint(x: 0, y: 40), toPoint: CGPoint(x: 0, y: view.frame.height - 10))
        collision.addBoundaryWithIdentifier(BoundaryType.RightWall.rawValue, fromPoint: CGPoint(x: view.frame.width, y: 40), toPoint: CGPoint(x: view.frame.width, y: view.frame.height - 10))
        
    }
    //MARK: - End Game
    
    func endGame () {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Game Over
        
        
        
        let startVC = storyboard.instantiateViewControllerWithIdentifier("StartVC")
        
        navigationController?.viewControllers = [startVC]
        
        
        
    }
    //MARK: SoundEffects
    func playSound(named: String) {
        
        // MARK: AudioPlayer
        if let fileData = NSDataAsset(name: named) {
            
            let data = fileData.data
            
            
            do{
                
              let player = try AVAudioPlayer(data: data)
                
                player.play()
                
                players.append(player)
                
                print(players.count)
                
            } catch {
                
                print(error)
            }
            
            
        }

    }

    
} // end class
