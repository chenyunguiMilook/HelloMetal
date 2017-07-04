//
//  GeometryBuffer.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/4.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal

public class GeometryBuffer {
    
    public var geometry: Geometry
    
    public var vertexBuffer: MTLBuffer!
    public var uvBuffer: MTLBuffer!
    
    public var indexBuffer: MTLBuffer!
    public var indexCount: Int { return geometry.indices.count * 3 }
    
    public init(geometry: Geometry, device: MTLDevice) {
        self.geometry = geometry
        
        self.vertexBuffer = device.makeBuffer(bytes: geometry.verticesBuffer, length: geometry.verticesSize, options: .cpuCacheModeWriteCombined)
        self.uvBuffer = device.makeBuffer(bytes: geometry.uvsBuffer, length: geometry.uvsSize, options: .cpuCacheModeWriteCombined)
        self.indexBuffer = device.makeBuffer(bytes: geometry.indicesBuffer, length: geometry.indexSize, options: .cpuCacheModeWriteCombined)
    }
}

