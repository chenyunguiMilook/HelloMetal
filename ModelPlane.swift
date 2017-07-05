//
//  ModelPlane.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/6/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import UIKit

public class ModelPlane : Model {
    
    public init(name: String = "Plane",
                library: MTLLibrary,
                texture: MTLTexture?,
                textureSampler: MTLSamplerState? = nil,
                widthSegments: Int = 1,
                heightSegments: Int = 1) {
        
        let geometry = GeometryPlane(widthSegments: widthSegments, heightSegments: heightSegments)
        super.init(name: name, library: library, geometry: geometry, texture: texture, textureSampler: textureSampler)
    }
}

extension ModelPlane {
    
    public convenience init(name: String = "Plane",
                library: MTLLibrary,
                texture: UIImage,
                textureSampler: MTLSamplerState? = nil,
                widthSegments: Int = 1,
                heightSegments: Int = 1) {
        
        let texture = loadTexture(image: texture, device: library.device)
        self.init(name: name, library: library, texture: texture, textureSampler: textureSampler, widthSegments: widthSegments, heightSegments: heightSegments)
    }
    
    public convenience init(name: String = "Plane",
                            library: MTLLibrary,
                            texture: String,
                            textureSampler: MTLSamplerState? = nil,
                            widthSegments: Int = 1,
                            heightSegments: Int = 1) {
        
        let texture = loadTexture(imageNamed: texture, device: library.device)
        self.init(name: name, library: library, texture: texture, textureSampler: textureSampler, widthSegments: widthSegments, heightSegments: heightSegments)
    }
}










