//
//  MySceneViewController.swift
//  HelloMetal
//
//  Created by Andrew K. on 11/5/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class MySceneViewController: MetalViewController, MetalViewControllerDelegate {
    
    let panSensivity: Float = 5.0
    var lastPanLocation: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalViewControllerDelegate = self
        
        setupGestures()
    }
    
    // MARK: - MetalViewControllerDelegate
    func renderObjects(in drawable: CAMetalDrawable) {
        
        self.renderer.render(in: drawable)
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
            lastPanLocation = pointInView
            
        } else if panGesture.state == UIGestureRecognizerState.began {
            lastPanLocation = panGesture.location(in: view)
        }
    }
}
