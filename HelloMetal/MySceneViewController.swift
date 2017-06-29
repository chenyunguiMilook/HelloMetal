//
//  MySceneViewController.swift
//  HelloMetal
//
//  Created by Andrew K. on 11/5/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class MySceneViewController: MetalViewController, MetalViewControllerDelegate {
    var modelViewMatrix: Matrix4!
    
    let panSensivity: Float = 5.0
    var lastPanLocation: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelViewMatrix = Matrix4()
        modelViewMatrix.translate(0.0, y: 0.0, z: -4)
        modelViewMatrix.rotateAroundX(Matrix4.degrees(toRad: 25), y: 0.0, z: 0.0)
        
        metalViewControllerDelegate = self
        
        setupGestures()
    }
    
    // MARK: - MetalViewControllerDelegate
    func renderObjects(in drawable: CAMetalDrawable) {
        
        self.renderer.render(in: drawable, modelViewMatrix: modelViewMatrix, projectionMatrix: projectionMatrix)
    }
    
    func updateLogic(_ timeSinceLastUpdate: CFTimeInterval) {
        renderer.model.updateWithDelta(timeSinceLastUpdate)
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
            
            renderer.model.rotationY -= xDelta
            renderer.model.rotationX -= yDelta
            lastPanLocation = pointInView
            
        } else if panGesture.state == UIGestureRecognizerState.began {
            lastPanLocation = panGesture.location(in: view)
        }
    }
}
