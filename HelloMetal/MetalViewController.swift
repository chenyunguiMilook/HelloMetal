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
    
    func renderObjects(in drawable: CAMetalDrawable)
}

class MetalViewController: UIViewController {
    
    var renderer: Renderer!
    var metalLayer: CAMetalLayer!
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.render()
    }
    
    func render() {
        if let drawable = metalLayer.nextDrawable() {
            metalViewControllerDelegate?.renderObjects(in: drawable)
        }
    }
}
