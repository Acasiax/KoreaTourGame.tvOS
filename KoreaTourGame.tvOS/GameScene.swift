//
//  GameScene.swift
//  KoreaTourGame.tvOS
//
//  Created by 이윤지 on 2/20/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var gameEnded = false  // 게임 종료 여부를 나타내는 플래그
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    //땅
    let SW_PIECES = 20 //⛑️
    let ASP_PIECES = 15  //땅 블럭의 개수
    let groundSpeed: CGFloat = 8.5  //땅이 움직이는 속도
    let groundResetXpos: CGFloat = -150  //점프 후 다시 올라오는 위치
    var moveGroundAction: SKAction! //땅을 움직이는 액션을 저장
    var moveGroundActionForever: SKAction!
    var asphaltPieces = [SKSpriteNode]() //SKSpriteNode의 배열로, 게임에서 사용되는 땅 블럭(SKSpriteNode)을 저장하는 데 사용
    var sidewalkPieces = [SKSpriteNode]() //⛑️
    
    
    //캐릭터
    var pushAction: SKAction! //캐릭터가 움직이도록 푸쉬
    var charPushFrames = [SKTexture]() //캐릭터 픽셀들 저장
    var character: SKSpriteNode!
    let CHAR_X_POS: CGFloat = 150
    let CHAR_Y_POS: CGFloat = 380  //180
    var isJumping = false
    
    
//    //Physics⛑️
//    let COLLIDER_CHAR_FRONT: UInt32 = 1 << 0
//    let COLLIDER_CHAR_BOTTOM: UInt32 = 1 << 1
//    let COLLIDER_OBSTACLE: UInt32 = 1 << 2
//    let COLLIDER_GROUND: UInt32 = 1 << 3
    
    
    override func didMove(to view: SKView) {
       
        setupBackground()
        setupGround()
        setupCharacter()
       
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(jump(_:)))
//        view.addGestureRecognizer(tapGestureRecognizer)
      
        let dumpster = Dumpster()
        dumpster.startMoving()
        self.addChild(dumpster)
        
        //⛑️
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.jump(_:)))
        tapGestureRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        self.view?.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupGameOverLabel() {
        //self.run(SKAction.playSoundFileNamed("sfxGameOver.wav", waitForCompletion: false))
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        gameOverLabel.zPosition = 20 // 확실히 보이도록 높은 z 위치에 설정
        gameOverLabel.isHidden = false // 초기에는 숨김
        gameOverLabel.name = "gameOverLabel" // 참조를 위해 이름 설정
        self.addChild(gameOverLabel)
    }

    
    
   
    
    
    
    
    func setupBackground() {
        //배경화면 설정
        let bg = SKSpriteNode(imageNamed: "drawingbg5")
        bg.position = CGPoint(x: 517, y: 420)
        bg.zPosition = 3 //순서
        self.addChild(bg)
//
//        let bg2 = SKSpriteNode(imageNamed: "bg2")
//        bg2.position = CGPoint(x: 517, y: 450)
//        bg2.zPosition = 2
//        self.addChild(bg2)
//        
//        let bg3 = SKSpriteNode(imageNamed: "bg3A")
//        bg3.position = CGPoint(x: 517, y: 500)
//        bg3.zPosition = 1
//        self.addChild(bg3)
        
        
        
        //skybg4
        let bg3 = SKSpriteNode(imageNamed: "skybg44")
        bg3.position = CGPoint(x: 517, y: 520)
        bg3.zPosition = 1
        self.addChild(bg3)
    }
    
    func setupGround() {
        
        moveGroundAction = SKAction.moveBy(x: -groundSpeed, y: 0, duration: 0.02)
        moveGroundActionForever = SKAction.repeatForever(moveGroundAction)
        // asphalt
        for x in 0..<ASP_PIECES {
            let asp = SKSpriteNode(imageNamed: "asphaltA")
            asp.zPosition = 4
            
           //원래 let collider = SKPhysicsBody(rectangleOf: CGSizeMake(asp.size.width, 5), center: CGPointMake(0, -30)) //⛑️
            let collider = SKPhysicsBody(rectangleOf: CGSizeMake(asp.size.width, 5), center: CGPointMake(0, 150)) //⛑️
            
            
            collider.isDynamic = false //⛑️
            asp.physicsBody = collider //⛑️

            asphaltPieces.append(asp)
            
            if x == 0 {
                let start = CGPointMake(0, 144)
                asp.position = start
            } else {
                asp.position = CGPointMake(asp.size.width + asphaltPieces[x - 1].position.x, asphaltPieces[x - 1].position.y)
            }
            asp.run(moveGroundActionForever)
            self.addChild(asp)
        }
        
        
        for x in 0..<ASP_PIECES {
            let asp = SKSpriteNode(imageNamed: "동아줄1")
            asp.zPosition = 5

            let collider = SKPhysicsBody(rectangleOf: CGSizeMake(asp.size.width, 5), center: CGPointMake(0, 150))
//            collider.isDynamic = false
//            asp.physicsBody = collider

            asphaltPieces.append(asp)
            
            // 모든 인스턴스의 y축 위치를 300으로 설정
            let positionX = x == 0 ? 0 : asp.size.width + asphaltPieces[x - 1].position.x
            asp.position = CGPointMake(positionX, 300) // y축 위치를 300으로 고정
            
            asp.run(moveGroundActionForever)
            self.addChild(asp)
        }

   
    }
    
    func setupCharacter() {
        
        for x in 0..<9{
            charPushFrames.append(SKTexture(imageNamed: "koreaRun\(x)"))
        }
        
        //sprite 설정
        character = SKSpriteNode(texture: charPushFrames[0])
        self.addChild(character)
        
        //푸쉬 애니메이션 설정
        character.run(SKAction.repeatForever(SKAction.animate(with: charPushFrames, timePerFrame: 0.1)))
        character.position = CGPointMake(CHAR_X_POS, CHAR_Y_POS)
        character.zPosition = 10
        
      
        
        let frontColliderSize = CGSizeMake(5, character.size.height * 0.80)
        let frontCollider = SKPhysicsBody(rectangleOf: frontColliderSize, center: CGPointMake(25, 0))
        frontCollider.collisionBitMask = GameManager.sharedInstance.COLLIDER_OBSTACLE
        
        
        
        let bottomColliderSize = CGSizeMake(character.size.width / 2, 5)
        let bottomCollider = SKPhysicsBody(rectangleOf: bottomColliderSize, center: CGPointMake(0, -(character.size.height / 2)))


        character.physicsBody = SKPhysicsBody(bodies: [frontCollider,bottomCollider])
       // character.physicsBody = SKPhysicsBody(rectangleOf: character.size)
        //restitution(탄성)
        //탄성은 두 물체가 충돌할 때 튕기는 정도를 나타냅니다. 여기서는 restitution을 0으로 설정하여 캐릭터가 충돌 시 튕기지 않도록 만듭니다.⬇️
        character.physicsBody?.restitution = 0
        //linearDamping (선형 감속) 선형 감속은 물리적 객체가 이동할 때 속도 감속을 나타냅니다. 여기서는 linearDamping을 0.1로 설정하여 캐릭터의 이동이 서서히 감속되도록 만듭니다.⬇️
        character.physicsBody?.linearDamping = 0.1
       // allowsRotation (회전 허용):
        character.physicsBody?.allowsRotation = false
        //mass (질량):
        character.physicsBody?.mass = 0.1
        //sDynamic (동적 여부):
      // character.physicsBody?.isDynamic = false
        character.physicsBody?.isDynamic = true  //⛑️
        //중력
        self.physicsWorld.gravity = CGVectorMake(0.0, -10)
        
       
     
        
    }
    
    
    //점프가 완료될 때까지 다시 점프하지 않도록 하는 점프 함수
    @objc func jump(_ gesture: UITapGestureRecognizer){
        //==은 동등연산자
        // 점프중이 false(아니)면 점프를 시작
        if isJumping == false {
            isJumping = true //할당연산자, 중복 점프가 발생하지 않도록 방지. 점프가 완료될 때까지 다시 점프하지 않도록
            //점프의 힘 적용
            let impulseX: CGFloat = 0.0 //x축은 그대로
            let impulseY: CGFloat = 60.0 //y축으로 60.0만큼의 힘으로 점프
            character.physicsBody?.applyImpulse(CGVectorMake(impulseX, impulseY))
            // character.physicsBody?.applyImpulse(CGVector(dx: impulseX, dy: impulseY)) //applyImpulse 메서드는 캐릭터에게 힘을 적용하는 역할을 합니다.
        }
    }
 
    func groundMovement(){
        for x in 0..<asphaltPieces.count{
            if asphaltPieces[x].position.x <= groundResetXpos {
                var index: Int!
                
                if x == 0 {
                    index = asphaltPieces.count - 1
                } else {
                    //배열의 첫 번째 요소에서는 이전 요소가 마지막 요소가 되어야 하기 때문
                    index = x - 1
                }
                let newPos = CGPoint(x: asphaltPieces[index].position.x + asphaltPieces[x].size.width, y: asphaltPieces[x].position.y)
                
                asphaltPieces[x].position = newPos
            }
        }
    }
    
    
    @objc override func update(_ currentTime: TimeInterval) {
        
        // 캐릭터의 x 위치가 CHAR_X_POS보다 작으면 게임 종료
        if let character = character, character.position.x < -30 {
            endGame()
        }
        
        // Called before each frame is rendered
        groundMovement()
//        if ceil(character.position.y) < CHAR_Y_POS {
//            character.physicsBody?.isDynamic = false
//            character.position = CGPointMake(CHAR_X_POS, CHAR_Y_POS)
//            isJumping = false
//        }
        
        
        //⛑️
        if isJumping {
            if floor(character.physicsBody!.velocity.dy) == 0 {
                //We have stopped falling
                isJumping = false
                
            }
        }
        
        for child in self.children{
            child.update()
        }
        
    }
   
    
    func endGame() {
        guard !gameEnded else { return }
        setupGameOverLabel()
        self.removeAllActions()
        //super.update()
        self.run(SKAction.playSoundFileNamed("sfxGameOver.wav", waitForCompletion: false))
        // 여기에 게임 종료 관련 로직을 구현합니다.
        // 예를 들어, 게임 오버 화면을 보여주거나 게임 리셋 등을 수행할 수 있습니다.
       
        print("게임 종료")
       
        // 게임 종료를 위한 추가 로직을 여기에 추가합니다.
        gameEnded = true  // 게임 종료 플래그 설정
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == GameManager.sharedInstance.COLLIDER_OBSTACLE || contact.bodyB.categoryBitMask == GameManager.sharedInstance.COLLIDER_OBSTACLE {
            print("부딪쳤어")
            self.removeAllActions()
            
         //   musicPlayer.stop()
            
            //self.run(SKAction.playSoundFileNamed("sfxGameOver.wav", waitForCompletion: false))
            
        //    player.playCrashAnim()
            
//            for node in asphaltPieces {
//                node.removeAllActions()
//            }
//            
//            for node in sidewalkPieces {
//                node.removeAllActions()
//            }
//            
//            for x in 0..<3 {
//                farBG[x].removeAllActions()
//                midBG[x].removeAllActions()
//                frontBG[x].removeAllActions()
//            }
//            
//            for obs in obstacles {
//                obs.removeAllActions()
//            }
//            
//            for bld in buildings {
//                bld.removeAllActions()
//            }
        }
        
    }
      
}
