//
//  fruit.swift
//  snake
//
//  Created by Ethan  Jin  on 22/10/2021.
//

import Foundation
import SpriteKit


class Fruit: SKSpriteNode{
    var row: Int = 0
    var column: Int = 0
    
    convenience init(imageNamed: String) {
        let color = UIColor()
        let texture = SKTexture(imageNamed: imageNamed)
        let size = CGSize(width: 17, height: 17)
        
        self.init(texture: texture, color: color, size: size)/*initialize a textured sprite in color using an existing texture object*/
    }
    
}
