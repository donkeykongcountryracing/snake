//
//  File.swift
//  snake
//
//  Created by Ethan  Jin  on 1/11/2021.
//

import Foundation
import SpriteKit // imports things like skspritenode, uicolor, cgsize, cgpoint, sktexture and many other

class SnakeBody: SKSpriteNode{
    var row = 0 // var is changeable unlike let statement
    var column = 0
    var nextMove = ""
    var curMove = ""
    var nextPos = CGPoint(x: 0, y: 0)
    var jumped = false
    
    func getRow() -> Int{
        return row
    }
    
    
    func getCol() -> Int{
        return column
    }
    
    convenience init(image: String) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: image)
        let size = CGSize(width: 24.0, height: 24.0)
        self.init(texture: texture, color: color, size: size) // must self.init, takes self(the new object we made in this initialiser) and initialises it into the game scene. Sort of like return in a function, we must self.init in an initialiser like how we must return a value in a function. This states what the self/sprite made in this initialiser will be like, look like with the code inside the self.init() stating which texture, color, or other stuff will be included. Like a function this is the output/result for the input SnakeBody(image: "snakeBody")
    }
    
}

