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
    public var vertexBufferProvider: BufferProvider<[float3]>
    public var uvBufferProvider: BufferProvider<[float2]>
    public var indexCount: Int { return geometry.indices.count }
    public var indexBuffer: MTLBuffer!
    
    public init(geometry: Geometry, device: MTLDevice) {
        self.geometry = geometry
        self.vertexBufferProvider = BufferProvider<[float3]>(device: device, bufferLength: geometry.verticesSize)
        self.uvBufferProvider = BufferProvider<[float2]>(device: device, bufferLength: geometry.uvsSize)
        self.indexBuffer = device.makeBuffer(length: geometry.indexSize, options: [])
        let indexBufferPointer = self.indexBuffer.contents()
        memcpy(indexBufferPointer, &geometry.indices, geometry.indexSize)
    }
    
    public var nextVertexBuffer: MTLBuffer {
        return self.vertexBufferProvider.nextUniformsBuffer(of: &geometry.vertices)
    }
    
    public var nextUVBuffer: MTLBuffer {
        return self.uvBufferProvider.nextUniformsBuffer(of: &geometry.uvs)
    }
}











