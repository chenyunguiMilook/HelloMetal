//
//  Geometry.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/6/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import simd

public class Geometry {
    
    public var vertices: [float3]
    public var uvs: [float2]
    public var indices: [uint3]
    
    public init(vertices: [float3], uvs: [float2], indices: [uint3]) {
        self.vertices = vertices
        self.uvs = uvs
        self.indices = indices
    }
}

extension Geometry {
    
    public var verticesSize: Int {
        return MemoryLayout<float3>.size * vertices.count
    }
    
    public var uvsSize: Int {
        return MemoryLayout<float2>.size * uvs.count
    }
    
    public var indexSize: Int {
        return MemoryLayout<uint3>.size * indices.count
    }
}

public class GeometryContainer {
    
    public var geometry: Geometry
    public var vertexBuffer: MTLBuffer!
    public var uvBuffer: MTLBuffer!
    public var indexBuffer: MTLBuffer!
    public var indexCount: Int { return geometry.indices.count }
    
    public init(geometry: Geometry, device: MTLDevice) {
        self.geometry = geometry
        
        var vertices: [Float] = geometry.vertices.map{ [$0.x, $0.y, $0.z] }.flatMap{ $0 }
        self.vertexBuffer = device.makeBuffer(bytes: &vertices, length: geometry.verticesSize, options: .cpuCacheModeWriteCombined)
        
        var uvs: [Float] = geometry.uvs.map{ [$0.x, $0.y] }.flatMap{ $0 }
        self.uvBuffer = device.makeBuffer(bytes: &uvs, length: geometry.uvsSize, options: .cpuCacheModeWriteCombined)
        
        var indices: [UInt32] = geometry.indices.map{ [$0.x, $0.y, $0.z] }.flatMap{ $0 }
        self.indexBuffer = device.makeBuffer(bytes: &indices, length: geometry.indexSize, options: .cpuCacheModeWriteCombined)
    }
}











