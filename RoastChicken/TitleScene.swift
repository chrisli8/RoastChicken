//
//  TitleScene.swift
//  RoastChicken
//
//  Created by Chris Li on 4/4/18.
//  Copyright © 2018 Chris Li. All rights reserved.
//

import Foundation
import SpriteKit

class TitleScene: SKScene {
    
    let titleLabel = SKLabelNode(fontNamed: "Avenir")
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let title = "Roast Chicken"
        titleLabel.text = title
        titleLabel.fontSize = 40
        titleLabel.fontColor = SKColor.red
        titleLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        addChild(titleLabel)
        
        self.backgroundColor = SKColor.gray
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: self.size)
        self.view?.presentScene(gameScene)
    }
    
}
