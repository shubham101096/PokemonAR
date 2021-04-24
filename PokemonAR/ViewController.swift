//
//  ViewController.swift
//  PokemonAR
//
//  Created by Shubham Mishra on 23/04/21.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        guard let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: .main) else {
            fatalError("Failed to load tracking images")
        }
        
        configuration.trackingImages = imagesToTrack
        configuration.maximumNumberOfTrackedImages = 2
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil}

        let refImage = imageAnchor.referenceImage

        let imagePlane = SCNPlane(width: refImage.physicalSize.width, height: refImage.physicalSize.height)

        let planeNode = SCNNode(geometry: imagePlane)
        planeNode.eulerAngles.x = -.pi/2
        planeNode.opacity = 0.5
        
        node.addChildNode(planeNode)
        return node
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        let configuration = ARImageTrackingConfiguration()
        guard let imagesToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: .main) else {
            fatalError("Failed to load tracking images")
        }
        
        configuration.trackingImages = imagesToTrack
        configuration.maximumNumberOfTrackedImages = 2
        // Run the view's session
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }
}
