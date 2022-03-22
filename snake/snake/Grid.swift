//
//  Grid.swift
//  Snake v2
//
//  Created by Daniel Budd on 9/1/18.
//  Copyright © 2018 Daniel Budd. All rights reserved.
//
import Foundation
import SpriteKit

//Look again


class Grid:SKSpriteNode{
    var rows: Int!
    var cols: Int!
    var cellSize: CGFloat!
    
    convenience init(cellSize: CGFloat, rows: Int, cols:Int, renderGrid: Bool){
        let texture = Grid.gridTexture(cellSize, rows: rows, cols: cols, renderGrid: renderGrid)
        self.init(texture: texture, color: SKColor.clear, size: texture.size())
//        self.scene?.view!.layer.addSublayer(layer)
        self.cellSize = cellSize
        self.rows = rows
        self.cols = cols
    }
    
    override init(texture: SKTexture!, color: SKColor, size: CGSize){
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    class func gridTexture(_ cellSize: CGFloat, rows:Int, cols:Int, renderGrid: Bool) -> SKTexture{
        //Add 1 to the height and width to ensure the borders are within the Sprite
        let size = CGSize(width: CGFloat(cols) * cellSize + 1.0, height: CGFloat(rows) * cellSize + 1.0)
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        let bezierPath = UIBezierPath()
        let offset: CGFloat = 0.5
        if renderGrid{
            //Draw vertical lines
            for i in 0...cols{
                let x = CGFloat(i) * cellSize + offset
                bezierPath.move(to: CGPoint(x: x, y: 0))
                bezierPath.addLine(to: CGPoint(x: x, y: size.height))
            }
            //Draw horizontal lines
            for i in 0...rows {
                let y = CGFloat(i) * cellSize + offset
                bezierPath.move(to: CGPoint(x: 0, y: y))
                bezierPath.addLine(to: CGPoint(x: size.width, y: y))
            }
        } else {
            bezierPath.move(to: CGPoint(x:0, y: 0))
            bezierPath.addLine(to: CGPoint(x: 0, y: size.height))
            
            bezierPath.move(to: CGPoint(x: CGFloat(cols) * cellSize + offset, y: 0))
            bezierPath.addLine(to: CGPoint(x: size.width, y: size.height))
            
            bezierPath.move(to: CGPoint(x:0, y: 0))
            bezierPath.addLine(to: CGPoint(x: size.width, y: 0))
            
            bezierPath.move(to: CGPoint(x: 0, y: CGFloat(rows) * cellSize + offset))
            bezierPath.addLine(to: CGPoint(x: size.width, y: size.height))
        }
        
        SKColor.systemGreen.setStroke()
        bezierPath.lineWidth = 1.0
        bezierPath.stroke()
        context!.addPath(bezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return SKTexture(image: image!)
    }
    
    
    func gridPosition(_ row: Int, col: Int) -> CGPoint{
        let offset = cellSize / 2.0
        let x = CGFloat(col) * cellSize - (cellSize * CGFloat(cols)) / 2.0 + offset
        let y = CGFloat(rows - row - 1) * cellSize - (cellSize * CGFloat(rows)) / 2.0 + offset
        return CGPoint(x: x, y: y)
    }
    
    func isEmpty(_ row: Int, col: Int) -> Bool {
        return false
    }
}
