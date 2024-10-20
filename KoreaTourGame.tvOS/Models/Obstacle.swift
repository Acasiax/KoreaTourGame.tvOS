//
//  Obstacle.swift
//  AuroraSkater
//
//  Created by 이윤지 on 1/23/24.
//

import SpriteKit

class Obstacle: SKSpriteNode {
    
    // 재설정 및 시작 x-좌표에 대한 상수
    static let RESET_X_POS: CGFloat = -250.0
    static let START_X_POS: CGFloat = 1182.0
    
    // 움직임에 사용되는 SKAction들
    var moveAction: SKAction!
    var moveForever: SKAction!
    
    // 장애물 이동을 시작하는 메서드
    func startMoving() {
        // 장애물의 초기 위치 설정
//        self.position = CGPoint(x: Obstacle.START_X_POS, y: 170)
        self.position = CGPoint(x: Obstacle.START_X_POS, y: 270)
        // 왼쪽으로 이동하는 SKAction 생성
        moveAction = SKAction.moveBy(x: -8.5, y: 0, duration: 0.02)
        
        // 움직임 액션을 계속 반복하는 SKAction 생성
        moveForever = SKAction.repeatForever(moveAction)
       
        // z축에서의 높이를 나타내는 zPosition을 7로 설정
        self.zPosition = 7
        
        // 물리학 속성 초기화
        initPhysics()
        
        // 무한히 움직이는 액션 실행
        self.run(moveForever)
    }
    
    // 필요한 경우 위치를 확인하고 재설정하는 update 메서드 오버라이드
    @objc override func update() {
        if self.position.x <= Obstacle.RESET_X_POS {
            // 위치를 시작 위치로 재설정
            self.position = CGPoint(x: Obstacle.START_X_POS, y: self.position.y)
        }
    }
    
    // 물리학 속성을 초기화하는 메서드
    func initPhysics() {
        // 물리학적 힘의 영향을 받지 않도록 물리학 속성을 비동적으로 설정
        self.physicsBody?.isDynamic = false
    }
}
