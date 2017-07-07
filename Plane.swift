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

public class Plane : GeometryRenderer {
    
    public init(name: String = "Plane",
                library: MTLLibrary,
                pixelFormat: MTLPixelFormat,
                textureSampler: MTLSamplerState? = nil,
                widthSegments: Int = 1,
                heightSegments: Int = 1) {
        
        let geometry = GeometryPlane(widthSegments: widthSegments, heightSegments: heightSegments)
        super.init(name: name, library: library, pixelFormat: pixelFormat, geometry: geometry, textureSampler: textureSampler)
    }
}









