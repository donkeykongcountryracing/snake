//
//  GameScene.swift
//  snake
//
//  Created by Ethan  Jin  on 22/10/2021.
//

import SpriteKit
import GameplayKit


var hiScore = 1
var hiScoreXPos = -15

class GameScene: SKScene {
    
    var gameTimer: Timer! // defines gameTimer as a timer. Timer fires something after a specified amount of time.
    var gameOver = UILabel()
    let viewWidth: CGFloat /* defines what datatype it is before stating value inside the constant, because normally UIScreen.main.bounds.width would be an integer, we need it to be a float to divide it well so we have to define the constant as a float type to make sure UIScreen.main.bounds.width is be a float*/ = UIScreen.main.bounds.width
    let viewHeight: CGFloat = UIScreen.main.bounds.width
    let gridCols = 10
    let gridRows = 10
    var duration = 1.0
    let label = SKSpriteNode()
    let screen = SKShapeNode(rectOf: CGSize(width: 800, height: 16800))
    
    let layer = SKSpriteNode()
    
    let restartButton = SKSpriteNode()
    let pauseButton = SKSpriteNode()
    let playButton = SKSpriteNode()
    
    let scoreLabel = SKLabelNode(fontNamed: "Arial")
    var score = 1
    let hiScoreLabel = SKLabelNode(fontNamed: "Arial")
    
    var snakeHead = SnakeBody(image: "snakehead") //we call on the class snakebody, which allows us access the code inside, and then we call on the class's initialiser, no need to specify which because for each class there can only be one initialier.
    var shinyApple: Fruit = Fruit(imageNamed: "shinyApple")
    var apple: Fruit = Fruit(imageNamed: "apple")
    var megaApple: Fruit = Fruit(imageNamed: "mega")
    var poisonApple: Fruit = Fruit(imageNamed: "poison")
    var evilApple: Fruit = Fruit(imageNamed: "apple")
    var superApple: Fruit = Fruit(imageNamed: "super")
    var mySnake: [SnakeBody] = [] // this is an empty array, length 0
    // the snake body are now defined as an array of bodies. The snakeBody or any class like a fruit, is sort of like skspritenode or int or uilabel. It is a variable but instead of being modifiable like skspritenode is it is very specified and only has specified parameters you can change. It is a variable like skspritenode and int but instead of being able to modify it a lot you can only change some things like the texture but the size or colour of it, for example stay the same and define the variable, specifying why it is a SnakeBody class/variable (because of the constant colour and size we know it is a SnakeBody variable/class)
    var grid: Grid = Grid(cellSize: 0, rows: 1, cols: 1, renderGrid: true)
    
    
    override func didMove(to view: SKView) {
        layer.size = CGSize(width: 265, height: 265)
        layer.color = .brown
        layer.zPosition = -1
        self.addChild(layer)
        
            let background = SKSpriteNode()
            background.texture = SKTexture(imageNamed: "background")
            background.zPosition = -10
            background.size = self.size
            self.addChild(background)
        
        self.addChild(screen)
        
        scaleMode = .resizeFill
        view.backgroundColor =  UIColor.black
        
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: -65, y: 150)
        scoreLabel.fontSize = 40
        scoreLabel.text = "Score: " + String(score)
        self.addChild(scoreLabel)
        
        hiScoreLabel.fontColor = .black
        hiScoreLabel.position = CGPoint(x: hiScoreXPos, y: 200)
        hiScoreLabel.fontSize = 40
        hiScoreLabel.text = "High Score: " + String(hiScore)
        self.addChild(hiScoreLabel)
        
        createRestartButton(pos: CGPoint(x: -100, y: -216))
        createPauseButton()
        createPlayButton()
        
        grid = Grid(cellSize: viewWidth / 12 /* you divide the width because you want the whole grid to fit in the view, and the width is smaller. If you made the size the height over 12 than the cell-size would be much bigger and if you put them next to each other for the row in the grid, the grids width/row wouldn't fit horizontally in the view */, rows: gridRows, cols: gridCols, renderGrid: true)
        grid.position = CGPoint.zero
        self.addChild(grid)
        grid.addChild(apple)
        grid.addChild(shinyApple)
        grid.addChild(megaApple)
        grid.addChild(poisonApple)
        grid.addChild(evilApple)
        self.addChild(superApple)
        
        //snake head
        snakeHead.row = 3
        snakeHead.column = 5
        snakeHead.position = grid.gridPosition(snakeHead.row, col: snakeHead.column)
        grid.addChild(snakeHead)
        
        snakeHead.nextMove = "right"
        mySnake.append(snakeHead) //append adds an element to the end of mySnake array
        
        
        //snake body
        let snakeBody = SnakeBody(image: "snakebody")
        snakeBody.row = snakeHead.row - 1
        snakeBody.column = snakeHead.column
        snakeBody.position = grid.gridPosition(snakeBody.row, col: snakeBody.column)
        snakeBody.nextPos = grid.gridPosition(snakeBody.row + 1, col: snakeBody.column)
        grid.addChild(snakeBody)
        
        mySnake.append(snakeBody)
        generateFruit()
        generateShinyFruit()
        generateMegaFruit()
        generateEvilFruit()
        generatePoisonFruit()
        generateSuperFruit()
        
        //        to continually move the snake
        let action = SKAction.sequence([SKAction.run(tick), SKAction.wait(forDuration: 0.5)])
        self.run(SKAction.repeatForever(action))
        
        //        gesture recogniser
        let directions: [UISwipeGestureRecognizer.Direction/*states that the type of variable the directions variable is a swipe direction recognizer, it also states that the directions variable is an array of swipe direction recognizer*/] =  [.right, .left, .up, .down] //we have the colon and declaring that the type of the variable "directions" is a swipe direction recogniser because .up has many different meanings and specifying the type of variable "directions" is will allow the code to specify the meaning of .up and know what its meaning/function is
        
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.respondToSwipeGesture(_:)))
            
            gesture.direction/*permitted direction of swipe for this gesture recognizer*/ = direction
            view.addGestureRecognizer/*adds gesture recognizer to view*/(gesture)
        }
    }
    
    func createRestartButton(pos: CGPoint){
        restartButton.name = "restartButton"
        restartButton.position = pos
        restartButton.color = .white
        restartButton.zPosition = 103
        restartButton.texture = SKTexture(imageNamed: "restart")
        restartButton.size = CGSize(width: 150, height: 150)
        self.addChild(restartButton)
    }
    
    func createPauseButton(){
        pauseButton.size = CGSize(width: 103, height: 103)
        pauseButton.position = CGPoint(x: 0, y: -220)
        pauseButton.color = .white
        pauseButton.zPosition = 102
        pauseButton.name = "pauseButton"
        pauseButton.texture = SKTexture(imageNamed: "pause")
        
        self.addChild(pauseButton)
    }
    
    func createPlayButton(){
        playButton.size = CGSize(width: 107, height: 107)
        playButton.position = CGPoint(x: 100, y: -215)
        playButton.color = .purple
        playButton.name = "playButton"
        playButton.zPosition = 102
        playButton.texture = SKTexture(imageNamed: "play")
        
        self.addChild(playButton)
    }
    
    func restartScene(){
        self.removeAllActions()
        self.removeAllChildren()
        self.scene?.removeFromParent()
        self.isPaused = true
        
        //What is super.viewDidLoad() and what does the code below really mean
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .resizeFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @objc func respondToSwipeGesture(_ gesture: UISwipeGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                if snakeHead.curMove != "left"{
                    snakeHead.nextMove = "right"
                }
            case UISwipeGestureRecognizer.Direction.down:
                if snakeHead.curMove != "up"{
                    snakeHead.nextMove = "down"
                }
            case UISwipeGestureRecognizer.Direction.left:
                if snakeHead.curMove != "right"{
                    snakeHead.nextMove = "left"
                }
            case UISwipeGestureRecognizer.Direction.up:
                if snakeHead.curMove != "down"{
                    snakeHead.nextMove = "up"
                }
            default:
                break// should never get here.}}
            }
        }
    }
    
    func generateFruit(){
        let row = Int(arc4random_uniform(UInt32(gridRows-1))+1)
        let col = Int(arc4random_uniform(UInt32(gridCols-1)) + 1)
        apple.position = grid.gridPosition(row, col: col)
        apple.row = row
        apple.column = col
    }
    
    
    func generateShinyFruit(){
        let row = Int(arc4random_uniform(UInt32(gridRows-1)) + 1)
        let col = Int(arc4random_uniform(UInt32(gridCols-1)) + 1)
        
        let random = Int.random(in: 1...3)
        if random == 1 {
            shinyApple.position = grid.gridPosition(row, col: col)
            shinyApple.row = row
            shinyApple.column = col
        }
        else{
            shinyApple.position = grid.gridPosition(100, col: 100)
        }
    }
    
    func generateMegaFruit(){
        let row = Int(arc4random_uniform(UInt32(gridRows-1)) + 1)
        let col = Int(arc4random_uniform(UInt32(gridCols-1)) + 1)
        
        let random = Int.random(in: 1...5)
        if random == 1 {
            megaApple.position = grid.gridPosition(row, col: col)
            megaApple.row = row
            megaApple.column = col
        }
        else{
            megaApple.position = grid.gridPosition(100, col: 100)
        }
    }
    
    func generatePoisonFruit(){
        let row = Int(arc4random_uniform(UInt32(gridRows-1)) + 1)
        let col = Int(arc4random_uniform(UInt32(gridCols-1)) + 1)
        
        let random = Int.random(in: 1...4)
        if random == 1 {
            poisonApple.position = grid.gridPosition(row, col: col)
            poisonApple.row = row
            poisonApple.column = col
        }
        else{
            poisonApple.position = grid.gridPosition(100, col: 100)
        }
    }
    func generateSuperFruit(){
        let row = Int(arc4random_uniform(UInt32(gridRows-1)) + 1)
        let col = Int(arc4random_uniform(UInt32(gridCols-1)) + 1)
        
        let random = Int.random(in: 1...12)
        if random == 1 {
            superApple.position = grid.gridPosition(row, col: col)
            superApple.row = row
            superApple.column = col
        }
        else{
            superApple.position = grid.gridPosition(100, col: 100)
        }
    }
    
    func endSceneMush(){
        let endScene = SKSpriteNode()
        endScene.texture = SKTexture(imageNamed: "mushEnd")
        endScene.zPosition = 10
        endScene.size = self.size
        self.addChild(endScene)
        scene?.view?.isPaused = true
        label.position.y = 80
        label.color = .clear
        label.size = CGSize(width: 300, height: 160)
        label.texture = SKTexture(imageNamed: "gameOver")
        label.zPosition = 200
        self.addChild(label)
        if score > hiScore {
            hiScore = score
            if hiScore >= 10{
                hiScoreXPos = -4
            }
        }
    }
    
    func generateEvilFruit(){
        let row = Int(arc4random_uniform(UInt32(gridRows-1)) + 1)
        let col = Int(arc4random_uniform(UInt32(gridCols-1)) + 1)
        
        let random = Int.random(in: 1...5)
        if random == 1 {
            evilApple.position = grid.gridPosition(row, col: col)
            evilApple.row = row
            evilApple.column = col
        }
        else{
            evilApple.position = grid.gridPosition(100, col: 100)
        }
    }
    
    func deleteBody(){
        mySnake.removeLast(2)
        score -= 2
    }
    
    func appendBody(){
        let lastBody = mySnake.last
        let newBody = SnakeBody(image: "snakebody")
        newBody.position = lastBody!.position
        newBody.row = lastBody!.row
        newBody.column = lastBody!.column
        newBody.nextPos = grid.gridPosition(newBody.row, col: newBody.column)
        mySnake.append(newBody)
        grid.addChild(newBody)
    }
    
    func tick(){
        switch(snakeHead.nextMove){
        case "right":
            snakeHead.column += 1
            snakeHead.curMove = "right"
            snakeHead.run(SKAction.rotate(toAngle: CGFloat(Double.pi * 1.5), duration: 0.1, shortestUnitArc: true))
            break
        case "down":
            snakeHead.row += 1
            snakeHead.curMove = "down"
            snakeHead.run(SKAction.rotate(toAngle: CGFloat(Double.pi), duration: 0.1, shortestUnitArc: true))
            break
        case "left":
            snakeHead.column -= 1
            snakeHead.curMove = "left"
            snakeHead.run(SKAction.rotate(toAngle: CGFloat(Double.pi / 2.0), duration: 0.1, shortestUnitArc: true))
            break
        case "up":
            snakeHead.row -= 1
            snakeHead.curMove = "up"
            snakeHead.run(SKAction.rotate(toAngle: CGFloat(0), duration: 0.1, shortestUnitArc: true))
            break
        default:
            break
        }
        
        snakeHead.jumped = false
        
        if snakeHead.column == gridCols{
            snakeHead.column = 0
            snakeHead.jumped = true
        }
        else if snakeHead.column < 0{
            snakeHead.column = gridCols - 1
            snakeHead.jumped = true
        }
        if snakeHead.row == gridRows{
            snakeHead.row = 0
            snakeHead.jumped = true
        }
        else if snakeHead.row < 0{
            snakeHead.row = gridRows - 1
            snakeHead.jumped = true
        }
        if snakeHead.row == apple.row && snakeHead.column == apple.column || snakeHead.row == shinyApple.row && snakeHead.column == shinyApple.column{
            generateMegaFruit()
            generateFruit()
            generateShinyFruit()
            generatePoisonFruit()
            generateEvilFruit()
            generateSuperFruit()
            appendBody()
            score += 1
            scoreLabel.text = "Score: " + String(score)
            if snakeHead.row == shinyApple.row && snakeHead.column == shinyApple.column{
                duration = duration * 1.3
                self.speed = CGFloat(duration)
                if score >= 10{
                    scoreLabel.position.x = -53
                }
            }
        }
        if snakeHead.row == megaApple.row && snakeHead.column == megaApple.column{
            score += 3
            for _ in 0..<3{
                appendBody()
            }
            scoreLabel.text = "Score: " + String(score)
            generateMegaFruit()
            generateFruit()
            generateShinyFruit()
            generatePoisonFruit()
            generateEvilFruit()
            generateSuperFruit()
            if score >= 10{
                scoreLabel.position.x = -56
            }
        }
        if snakeHead.row == poisonApple.row && snakeHead.column == poisonApple.column{
            let endScene = SKSpriteNode()
            endScene.texture = SKTexture(imageNamed: "end")
            endScene.zPosition = 10
            endScene.size = self.size
            self.addChild(endScene)
            scene?.view?.isPaused = true
            label.position.y = 80
            label.color = .clear
            label.size = CGSize(width: 300, height: 160)
            label.texture = SKTexture(imageNamed: "gameOver")
            label.zPosition = 200
            self.addChild(label)
            if score > hiScore {
                hiScore = score
                if hiScore >= 10{
                    hiScoreXPos = -4
                }
            }
        }
        if snakeHead.row == evilApple.row && snakeHead.column == evilApple.column{
            if score <= 10{
                endSceneMush()
            }
            if score > 10 && score < 20 {
                for _ in 1..<3 {
                    deleteBody()
                }
            }
            if score >= 20 && score < 50 {
                for _ in 1..<6 {
                    deleteBody()
                }
            }
            if score >= 50 && score < 80 {
                for _ in 1..<8 {
                    deleteBody()
                }
            }
            if score >= 80{
                for _ in 1..<11{
                    deleteBody()
                }
            }
            generateMegaFruit()
            generateFruit()
            generateShinyFruit()
            generatePoisonFruit()
            generateEvilFruit()
            generateSuperFruit()
        }
        
        if  snakeHead.row == superApple.row && snakeHead.column == superApple.column{
            if score < 20 {
                for _ in 1..<7 {
                    appendBody()
                    score += 1
                }
            }
            if score >= 20 && score < 50 {
                for _ in 1..<11 {
                    appendBody()
                    score += 1
                }
            }
            if score >= 50 && score < 80 {
                for _ in 1..<15 {
                    appendBody()
                    score += 1
                }
            }
            if score >= 80{
                for _ in 1..<20{
                    appendBody()
                    score += 1
                }
            }
            generateMegaFruit()
            generateFruit()
            generateShinyFruit()
            generatePoisonFruit()
            generateEvilFruit()
            generateSuperFruit()
        }
        
        let moveDuration: Double = snakeHead.jumped ? 0: 0.1
        
        snakeHead.nextPos = grid.gridPosition(snakeHead.getRow(), col: snakeHead.getCol()) // update the position
        snakeHead.run(SKAction.move(to: snakeHead.nextPos, duration: moveDuration))
        
        
        for i in (1 ... mySnake.count - 1).reversed(){
            let snakeToFollow = mySnake[i - 1]
            let snakeToMove = mySnake[i]
            let moveDuration: Double = snakeToMove.jumped ? 0 : 0.1
            
            snakeToMove.run(SKAction.move(to: snakeToMove.nextPos, duration: moveDuration))
            if snakeHead.row == snakeToMove.row && snakeHead.column == snakeToMove.column{
                //Game over ... pause game.
                let endScene = SKSpriteNode()
                endScene.texture = SKTexture(imageNamed: "snakeEnd")
                endScene.zPosition = 10
                endScene.size = self.size
                self.addChild(endScene)
                scene?.view?.isPaused = true
                label.position.y = 80
                label.color = .clear
                label.size = CGSize(width: 300, height: 160)
                label.texture = SKTexture(imageNamed: "gameOver")
                label.zPosition = 200
                self.addChild(label)
                if score > hiScore {
                    hiScore = score
                    if hiScore >= 10{
                        hiScoreXPos = -4
                    }
                }
            }
            snakeToMove.nextPos = grid.gridPosition(snakeToFollow.row, col: snakeToFollow.column)
            snakeToMove.row = snakeToFollow.row
            snakeToMove.column = snakeToFollow.column
            snakeToMove.jumped = snakeToFollow.jumped
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let loc = touch.location(in: self)
            let touchedNode: SKNode = self.atPoint(loc)
            if let name = touchedNode.name {
                if name == "restartButton" {
                    restartScene()
                }
                if name == "pauseButton"{
                    restartButton.zPosition = 102
                    
                    screen.fillColor = .yellow
                    screen.alpha = 0.85
                    screen.zPosition = 101
                    
                    self.isPaused = true
                    
                    hiScoreLabel.zPosition = 200
                    scoreLabel.zPosition = 200
                }
                if name == "playButton"{
                    screen.alpha = 0
                    self.isPaused = false
                }
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if score == 97 {
            label.position.y = 80
            label.color = .clear
            label.size = CGSize(width: 360, height: 240)
            label.texture = SKTexture(imageNamed: "win")
            label.zPosition = 200
            self.addChild(label)
        }
        
    }
    
}
