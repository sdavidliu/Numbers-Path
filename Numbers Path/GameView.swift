//
//  GameView.swift
//  Numbers Path
//
//  Created by Jimy Liu Mini on 4/8/16.
//  Copyright © 2016 Dave&Joe. All rights reserved.
//

import Foundation
import SpriteKit

class GameView: SKSpriteNode {
    
    let TILE_SIZE: CGFloat = 50.0
    var numRows = 5
    var numCols = 5
    
    var block: SKSpriteNode!
    var generationTimer: NSTimer!
    
    func difficultyChange(str: String){
        if (str == "easy"){
            numRows = 5
            numCols = 5
        }else{
            numRows = 7
            numCols = 5
        }
    }
    
    func repaint(arr: Array<Array<Int>>) {
        
        for i in 0...numCols-1 {
            for j in 0...numRows-1 {
                if (arr[i][j] == -1){
                    block = SKSpriteNode(imageNamed: "blank2.png")
                }else if (arr[i][j] == 0){
                    block = SKSpriteNode(imageNamed: "0.png")
                }else if (arr[i][j] == 1){
                    block = SKSpriteNode(imageNamed: "1.png")
                }else if (arr[i][j] == 2){
                    block = SKSpriteNode(imageNamed: "2.png")
                }else if (arr[i][j] == 3){
                    block = SKSpriteNode(imageNamed: "3.png")
                }else if (arr[i][j] == 4){
                    block = SKSpriteNode(imageNamed: "4.png")
                }else if (arr[i][j] == 5){
                    block = SKSpriteNode(imageNamed: "5.png")
                }else if (arr[i][j] == 6){
                    block = SKSpriteNode(imageNamed: "6.png")
                }else if (arr[i][j] == 7){
                    block = SKSpriteNode(imageNamed: "7.png")
                }else if (arr[i][j] == 8){
                    block = SKSpriteNode(imageNamed: "8.png")
                }else if (arr[i][j] == 9){
                    block = SKSpriteNode(imageNamed: "9.png")
                }else if (arr[i][j] == 10){
                    block = SKSpriteNode(imageNamed: "10.png")
                }else if (arr[i][j] == 11){
                    block = SKSpriteNode(imageNamed: "11.png")
                }else if (arr[i][j] == 12){
                    block = SKSpriteNode(imageNamed: "12.png")
                }else if (arr[i][j] == 13){
                    block = SKSpriteNode(imageNamed: "13.png")
                }else if (arr[i][j] == 14){
                    block = SKSpriteNode(imageNamed: "14.png")
                }else if (arr[i][j] == 15){
                    block = SKSpriteNode(imageNamed: "15.png")
                }else if (arr[i][j] == 16){
                    block = SKSpriteNode(imageNamed: "16.png")
                }else if (arr[i][j] == 17){
                    block = SKSpriteNode(imageNamed: "17.png")
                }else if (arr[i][j] == 18){
                    block = SKSpriteNode(imageNamed: "18.png")
                }else if (arr[i][j] == 19){
                    block = SKSpriteNode(imageNamed: "19.png")
                }else{
                    block = SKSpriteNode(imageNamed: "20.png")
                }
                block.size = CGSizeMake(TILE_SIZE, TILE_SIZE)
                block.position = CGPointMake(CGFloat(i)*TILE_SIZE, CGFloat(j)*TILE_SIZE)
                block.zPosition = -1
                addChild(block)
            }

        }

    }
    
}