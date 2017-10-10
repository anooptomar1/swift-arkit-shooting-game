import SpriteKit
import ARKit
import GameplayKit

class Scene: SKScene {
    
    let remainingLabel = SKLabelNode()
    var timer : Timer?
    
    var targetsCreated = 0
    var targetCount = 0 {
        didSet {
            remainingLabel.text = "Remaining: \(targetCount)"
        }
    }
    
    override func didMove(to view: SKView) {
        remainingLabel.fontSize = 16
        remainingLabel.fontName = "AmericanTypewriter"
        remainingLabel.color = .white
        remainingLabel.position = CGPoint(x: 0, y: view.frame.midY - 50)
        addChild(remainingLabel)
        targetCount = 0
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {
            timer in self.createTarget()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func createTarget() {
        if targetsCreated == 20 {
            timer?.invalidate()
            timer = nil
            return
        }
        
        targetsCreated += 1
        targetCount += 1
        
        guard let sceneView = self.view as? ARSKView else { return }
        
        let random = GKRandomSource.sharedRandom()
        
        let xRotation = simd_float4x4(SCNMatrix4MakeRotation(Float.pi / 2 * random.nextUniform(), 1, 0, 0))
        let yRotation = simd_float4x4(SCNMatrix4MakeRotation(Float.pi / 2 * random.nextUniform(), 0, 1, 0))
        
        let rotation = simd_mul(xRotation, yRotation)
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -1.5
        
        let transform = simd_mul(rotation, translation)
        
        let anchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: anchor)
    }
}
