//
//  ViewController.swift
//  HelloMetal
//
//  Created by Main Account on 10/2/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

protocol MetalViewControllerDelegate: class {
    
    func updateLogic(_ timeSinceLastUpdate: CFTimeInterval)
    func renderObjects(in drawable: CAMetalDrawable)
}

class MetalViewController: UIViewController {
    
    var renderer: Renderer!
    
    var metalLayer: CAMetalLayer!
    var timer: CADisplayLink!
    var lastFrameTimestamp: CFTimeInterval = 0.0
    
    weak var metalViewControllerDelegate: MetalViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device = MTLCreateSystemDefaultDevice()
        self.renderer = Renderer(device: device!)
        
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        view.layer.addSublayer(metalLayer)
        
        timer = CADisplayLink(target: self, selector: #selector(MetalViewController.newFrame(_:)))
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let window = view.window else { return }
        let scale = window.screen.nativeScale
        let layerSize = view.bounds.size
        
        self.view.contentScaleFactor = scale
        self.metalLayer.frame = CGRect(x: 0, y: 0, width: layerSize.width, height: layerSize.height)
        self.metalLayer.drawableSize = CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
    }
    
    func render() {
        if let drawable = metalLayer.nextDrawable() {
            metalViewControllerDelegate?.renderObjects(in: drawable)
        }
    }
    
    @objc func newFrame(_ displayLink: CADisplayLink) {
        if lastFrameTimestamp == 0.0 {
            lastFrameTimestamp = displayLink.timestamp
        }
        
        let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
        lastFrameTimestamp = displayLink.timestamp
        
        gameloop(timeSinceLastUpdate: elapsed)
    }
    
    func gameloop(timeSinceLastUpdate: CFTimeInterval) {
        metalViewControllerDelegate?.updateLogic(timeSinceLastUpdate)
        
        autoreleasepool {
            self.render()
        }
    }
}
