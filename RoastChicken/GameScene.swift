//
//  GameScene.swift
//  RoastChicken
//
//  Created by Chris Li on 3/2/18.
//  Copyright © 2018 Chris Li. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var squareShapeNode = SKShapeNode(rectOf: CGSize(width: 50.0, height: 50.0) ,
                                              cornerRadius: 5)
    private var scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    
    private var score = 0
    private var eventStarted = false
    private var winOpen = false
    
    override func didMove(to view: SKView) {
        
        let backgroundMusic = SKAudioNode(fileNamed: "RoastChickenIntro.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
        
        
        squareShapeNode.position = CGPoint(x: frame.size.width / 2, y: 450)
        squareShapeNode.fillColor = UIColor.blue
        squareShapeNode.strokeColor = UIColor.clear
        addChild(squareShapeNode)
        
        // Get label node from scene and store it for use later
//        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
//        if let label = self.label {
//            label.alpha = 0.0
//            label.run(SKAction.fadeIn(withDuration: 2.0))
//        }
        
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Finger here"
        label.fontSize = 40
        label.fontColor = SKColor.red
        label.position = CGPoint(x: frame.size.width / 2, y: 200)
        addChild(label)

        scoreLabel.text = String(score)
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: frame.size.width / 2, y: 500)
        addChild(scoreLabel)
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        if !eventStarted {
            var baseWaitTime = 1.0
            let randomAdjuster = arc4random_uniform(1500)
            baseWaitTime += Double(randomAdjuster) / 100.0
            
            let needle = SKSpriteNode(imageNamed: "Needle")
            needle.position = CGPoint(x: frame.size.width / 2, y: frame.size.height + needle.size.height / 2)
            // TODO: Get x/y of finger and send need towards finger
            let needleDecent = SKAction.move(to: CGPoint(x: frame.size.width / 2, y: pos.y + needle.size.height / 2), duration: baseWaitTime)
            addChild(needle)
            
            needle.run(needleDecent)
            squareShapeNode.fillColor = UIColor.yellow
            let wait = SKAction.wait(forDuration:baseWaitTime)
            let action = SKAction.run {
                // your code here ...
                print("RED")
                self.backgroundColor = UIColor.red
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                self.eventStarted = false
                self.winOpen = true
            }
            let resetPause = SKAction.wait(forDuration: 0.20)
            let resetColor = SKAction.run {
                self.winOpen = false
                self.backgroundColor = UIColor.darkGray
                needle.removeFromParent()
            }
            let oneRevolution:SKAction = SKAction.rotate(byAngle: CGFloat.pi * 2, duration: baseWaitTime)
            let repeatRotation:SKAction = SKAction.repeatForever(oneRevolution)
            squareShapeNode.run(oneRevolution)
            run(SKAction.sequence([wait,action,resetPause,resetColor]))
            eventStarted = true
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
        if winOpen {
            print("Win")
            score += 1
            squareShapeNode.fillColor = UIColor.green
        } else {
            print("Fail")
            score = 0
            squareShapeNode.fillColor = UIColor.red
        }
        scoreLabel.text = String(score)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
