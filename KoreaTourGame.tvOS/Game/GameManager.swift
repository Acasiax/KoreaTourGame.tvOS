//
//  GameManager.swift
//  KoreaTourGame.tvOS
//
//  Created by 이윤지 on 2/21/24.
//

import SpriteKit

class GameManager {
    static let sharedInstance = GameManager()
    
    let MOVEMENT_SPEED: CGFloat = -8.5
    
    //Colliders
    let COLLIDER_OBSTACLE: UInt32 = 1 << 0
    let COLLIDER_PLAYER: UInt32 = 1 << 1
    let COLLIDER_RIDEABLE: UInt32 = 1 << 2
}
