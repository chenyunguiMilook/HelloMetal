//
//  MySceneViewController.swift
//  HelloMetal
//
//  Created by Andrew K. on 11/5/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class MySceneViewController: UIViewController {
    
    var renderer: Renderer!
    var metalLayer: CAMetalLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let device = MTLCreateSystemDefaultDevice()
        self.renderer = Renderer(device: device!)
        self.renderer.delegate = self
        
        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = false
        view.layer.addSublayer(metalLayer)
        
        let tap = UITapGestureRecognizer()
            tap.numberOfTapsRequired = 1
            tap.addTarget(self, action: #selector(onTap(gesture:)))
        self.view.addGestureRecognizer(tap)
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
    
    @objc func onTap(gesture: UIGestureRecognizer) {
        
        //let geometry = self.renderer.model.geometry
        
        self.render()
    }
    
    func render() {
        if let drawable = metalLayer.nextDrawable() {
            self.renderer.render(in: drawable)
        }
    }
}

extension MySceneViewController : RendererDelegate {
    
    func renderer(_ renderer: Renderer, didFinishRenderingWith image: UIImage?) {
        DispatchQueue.main.async {
            let view = UIImageView(image: image)
            view.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
            self.view.addSubview(view)
        }
    }
}








