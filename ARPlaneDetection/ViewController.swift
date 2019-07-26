//
//  ViewController.swift
//  ARPlaneDetection
//
//  Created by wuufone on 2019/7/22.
//  Copyright © 2019 江武峯. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet weak var arScnView: ARSCNView!
    @IBOutlet weak var planeSizeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        self.arScnView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            putABoxOnPlane(node)
            drawDetectedPlane(anchor, node)
            showPlaneSize(anchor)
        }
    }
}

extension ViewController {
    fileprivate func putABoxOnPlane(_ node: SCNNode) {
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        box.materials.first?.diffuse.contents = UIColor.purple.withAlphaComponent(0.8)
        let boxNode = SCNNode(geometry: box)
        node.addChildNode(boxNode)
    }
    
    fileprivate func drawDetectedPlane(_ anchor: ARAnchor, _ node: SCNNode) {
        let planeAnchor = anchor as! ARPlaneAnchor
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        plane.materials.first?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
        plane.materials.first?.isDoubleSided = true
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles = SCNVector3Make(0.5*Float.pi, 0, 0)
        node.addChildNode(planeNode)
    }
    
    private func showPlaneSize(_ anchor: ARAnchor) {
        let planeAnchor = anchor as! ARPlaneAnchor
        let planeWidth = String(format: "%2.2f", planeAnchor.extent.x * 100)
        let planeHeight = String(format: "%2.2f", planeAnchor.extent.z * 100)
        DispatchQueue.main.async {
            self.planeSizeLabel.text = "平面大小為：\(planeWidth)cm x \(planeHeight)cm"
        }
    }
}
