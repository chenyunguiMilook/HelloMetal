//
//  MySceneViewController.swift
//  HelloMetal
//
//  Created by Andrew K. on 11/5/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

class MySceneViewController: MetalViewController, MetalViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        metalViewControllerDelegate = self
    }
    
    // MARK: - MetalViewControllerDelegate
    func renderObjects(in drawable: CAMetalDrawable) {
        self.renderer.render(in: drawable)
    }
}
