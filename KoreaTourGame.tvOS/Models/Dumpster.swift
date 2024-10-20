//
//  Dumpster.swift
//  AuroraSkater
//
//  Created by 이윤지 on 1/23/24.
//

import SpriteKit

class Dumpster: Obstacle {
   
    convenience init(){
        self.init(imageNamed: "호랑이장애물1")
    }
    
    override func initPhysics() {
        
     
        let frontCollider = SKPhysicsBody(rectangleOf: CGSizeMake(5, self.size.height), center: CGPointMake(-(self.size.width / 2), 0))
        
        
        
        
        frontCollider.categoryBitMask = GameManager.sharedInstance.COLLIDER_OBSTACLE
        frontCollider.contactTestBitMask = GameManager.sharedInstance.COLLIDER_PLAYER
        
        
        
        let topCollider = SKPhysicsBody(rectangleOf: CGSizeMake(self.size.width * 0.80, 5), center: CGPointMake(0, self.size.height / 2 - 10))
        
        self.physicsBody = SKPhysicsBody(bodies: [frontCollider,topCollider])
        
        
        
        super.initPhysics()
    }
}
