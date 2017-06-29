//
//  MySceneViewController.swift
//  HelloMetal
//
//  Created by Andrew K. on 11/5/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class MySceneViewController: MetalViewController, MetalViewControllerDelegate {
    var worldModelMatrix: Matrix4!
    var cube: Cube!
    
    let panSensivity: Float = 5.0
    var lastPanLocation: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        worldModelMatrix = Matrix4()
        worldModelMatrix.translate(0.0, y: 0.0, z: -4)
        worldModelMatrix.rotateAroundX(Matrix4.degrees(toRad: 25), y: 0.0, z: 0.0)
        
        cube = Cube(device: device, commandQ: commandQueue)
        metalViewControllerDelegate = self
        
        setupGestures()
    }
    
    // MARK: - MetalViewControllerDelegate
    func renderObjects(in drawable: CAMetalDrawable) {
        cube.render(commandQueue, pipelineState: pipelineState, drawable: drawable, parentModelViewMatrix: worldModelMatrix, projectionMatrix: projectionMatrix, clearColor: nil)
    }
    
    func updateLogic(_ timeSinceLastUpdate: CFTimeInterval) {
        cube.updateWithDelta(timeSinceLastUpdate)
    }
    
    // MARK: - Gesture related
    func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(MySceneViewController.pan(_:)))
        view.addGestureRecognizer(pan)
    }
    
    @objc func pan(_ panGesture: UIPanGestureRecognizer) {
        if panGesture.state == UIGestureRecognizerState.changed {
            let pointInView = panGesture.location(in: view)
            
            let xDelta = Float((lastPanLocation.x - pointInView.x) / view.bounds.width) * panSensivity
            let yDelta = Float((lastPanLocation.y - pointInView.y) / view.bounds.height) * panSensivity
            
            cube.rotationY -= xDelta
            cube.rotationX -= yDelta
            lastPanLocation = pointInView
            
        } else if panGesture.state == UIGestureRecognizerState.began {
            lastPanLocation = panGesture.location(in: view)
        }
    }
}
