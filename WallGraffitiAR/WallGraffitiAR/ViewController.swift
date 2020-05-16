//
//  ViewController.swift
//  WallGraffitiAR
//
//  Created by Cory Green on 5/10/20.
//  Copyright © 2020 Cory Green. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.showsStatistics = true
    }

    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            return
        }
        
        let config = ARWorldTrackingConfiguration()
        config.isLightEstimationEnabled = true
        config.planeDetection = [.vertical]
        sceneView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // pausing things when the view disappears //
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: sceneView) else {
            return
        }
        
        let hitResultsFeaturePoints: [ARHitTestResult] = sceneView.hitTest(location, types: .featurePoint)
        
        if let hit = hitResultsFeaturePoints.first {
            let transformHit = hit.worldTransform

            let pointTranslation = transformHit.translation
            
            // creating text //
            let text = SCNText(string: "Hey there", extrusionDepth: 2)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
            text.materials = [material]
            
            // setting the location //
            let node = SCNNode()
            node.scale = SCNVector3(0.01, 0.01, 0.01)
            node.geometry = text
            
            // setting the position //
            node.simdPosition = SIMD3(pointTranslation.x, pointTranslation.y, pointTranslation.z)
            
            sceneView.scene.rootNode.addChildNode(node)
        }
    }

}

// creating an extension of float4x4 //
extension float4x4 {
  var translation: float3 {
  let translation = self.columns.3
    return float3(translation.x, translation.y, 0.0)
  }
}
