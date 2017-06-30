//
//  ModelPlane.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/6/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal

public class ModelPlane : Model {
    
    public init(name: String = "Plane", device: MTLDevice, texture: MTLTexture, widthSegments: Int = 1, heightSegments: Int = 1) {
        let geometry = GeometryPlane(widthSegments: widthSegments, heightSegments: heightSegments)
        super.init(name: name, device: device, geometry: geometry, texture: texture)
    }
}
