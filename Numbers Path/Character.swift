//
//  Character.swift
//  Number Path
//
//  Created by Jimy Liu Mini on 4/8/16.
//  Copyright © 2016 Dave&Joe. All rights reserved.
//

import Foundation
import SpriteKit

class Character: SKSpriteNode {
    
    var body: SKSpriteNode!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(30, 30))
        
        body = SKSpriteNode(imageNamed: "square-selection-512.png")
        body.size = CGSizeMake(50, 50)
        body.position = CGPointMake(0, 0)
        addChild(body)
        
    }
    
    func move(direction: String) {
        if (direction == "up"){
            let translate = SKAction.moveByX(0, y: 50, duration: 0.1)
            runAction(translate)
        }else if (direction == "down"){
            let translate = SKAction.moveByX(0, y: -50, duration: 0.1)
            runAction(translate)
        }else if (direction == "right"){
            let translate = SKAction.moveByX(50, y: 0, duration: 0.1)
            runAction(translate)
        }else{
            let translate = SKAction.moveByX(-50, y: 0, duration: 0.1)
            runAction(translate)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}