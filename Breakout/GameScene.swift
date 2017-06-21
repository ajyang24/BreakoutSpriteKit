//
//  GameScene.swift
//  Breakout
//
//  Created by Andrew Yang on 6/21/17.
//  Copyright © 2017 Andrew Yang. All rights reserved.
//

import SpriteKit
import GameplayKit
// SKPhysicsContactDelegate : Add to use contact PHYSICS
class GameScene: SKScene, SKPhysicsContactDelegate
{
    var ball : SKSpriteNode!
    var paddle : SKSpriteNode!
    var brick : SKSpriteNode!
    var loseZone : SKSpriteNode!
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame) //makes edge of the view part of the physics
        createBackground()
        makeBall()
        
        //this will start ball movement
        
        makePaddle()
        conceiveBrick()
        constructLoseZone()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {

        if ball.physicsBody?.isDynamic == false
        {
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.applyImpulse(CGVector(dx: 5, dy: 5))
        }
        
        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {

        for touch in touches
        {
            let location = touch.location(in: self)
            paddle.position.x = location.x
        }

    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if contact.bodyA.node?.name == "Brick" || contact.bodyB.node?.name == "Brick"
        {
            print("brick hit")
            brick.removeFromParent()
        }
        if contact.bodyA.node?.name == "loseZone" || contact.bodyB.node?.name == "loseZone"
        {
            print("lose zone entered")
        }
    }

    
    
    
    func createBackground()
    {
        let stars = SKTexture(imageNamed: "stars")
        
        for i in 0...1 //creates two stars Background for seamless image(scrolls)
        {
            let starsBackground = SKSpriteNode(texture: stars)
            starsBackground.zPosition = -1 //sets stacking order(background in the back)
            starsBackground.anchorPoint = CGPoint(x: 0.5, y: 0.5) //anchors the images
            starsBackground.position = CGPoint(x: 0, y: (starsBackground.size.height*CGFloat(i)-CGFloat(1*i)))
            
            addChild(starsBackground)
            
            let moveDown = SKAction.moveBy(x: 0, y: -starsBackground.size.height, duration: 20)
            let reset = SKAction.moveBy(x: 0, y: starsBackground.size.height, duration: 0)
            let moveLoop = SKAction.sequence([moveDown, reset])
            let loop = SKAction.repeatForever(moveLoop)
            starsBackground.run(loop)
            
        }
    }
    
    func makeBall()
    {
        let ballDiameter = (frame.width)/20
        ball = SKSpriteNode(color: UIColor.cyan, size: CGSize(width: ballDiameter, height: ballDiameter))
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        
        //applies physics body to ball
        ball.physicsBody = SKPhysicsBody(rectangleOf: ball.size)
        
        ball.physicsBody?.isDynamic = false //uses all physics properties(contact, gravity etc.)
        
        ball.physicsBody?.usesPreciseCollisionDetection = true
        ball.physicsBody?.allowsRotation = false
        ball.physicsBody?.friction = 0
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.restitution = 1
        ball.physicsBody?.angularDamping = 0
        ball.physicsBody?.linearDamping = 0
        ball.physicsBody?.contactTestBitMask = (ball.physicsBody?.collisionBitMask)!
        
        addChild(ball)
        
        
    }
    
    func makePaddle()
    {
        paddle = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.width/5, height: frame.height/25))
        paddle.position = CGPoint(x: frame.midX, y: frame.minY + 125)
        paddle.name = "Paddle"
        paddle.physicsBody = SKPhysicsBody(rectangleOf: paddle.size)
        paddle.physicsBody?.isDynamic = false
        
        addChild(paddle)
        
    }
    
    func conceiveBrick()
    {
        brick = SKSpriteNode(color: UIColor.white, size: CGSize(width: frame.width/6, height: frame.height/24.5))
        brick.position = CGPoint(x: frame.midX, y: frame.maxY - 30)
        brick.name = "Brick"
        brick.physicsBody = SKPhysicsBody(rectangleOf: brick.size)
        brick.physicsBody?.isDynamic = false
        
        addChild(brick)

    }
    
    func constructLoseZone()
    {
        loseZone = SKSpriteNode(color: UIColor.clear, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody(rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        
        addChild(loseZone)
        
    }

}
