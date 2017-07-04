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
    
    internal let inflightBuffersCount: Int
    private var bufferIndex: Int = 0
    
    public var geometry: Geometry
    
    private var vertexBuffers: [MTLBuffer] = []
    private var uvBuffers: [MTLBuffer] = []
    
    public var indexBuffer: MTLBuffer!
    public var indexCount: Int { return geometry.indices.count * 3 }
    
    public init(geometry: Geometry, device: MTLDevice, inflightBuffersCount: Int = 3) {
        self.geometry = geometry
        self.inflightBuffersCount = inflightBuffersCount
        
        for _ in 0 ..< inflightBuffersCount {
            if let vertexBuffer = device.makeBuffer(bytes: geometry.verticesBuffer, length: geometry.verticesSize, options: []) {
                vertexBuffers.append(vertexBuffer)
            }
            if let uvBuffer = device.makeBuffer(bytes: geometry.uvsBuffer, length: geometry.uvsSize, options: []) {
                uvBuffers.append(uvBuffer)
            }
        }
        self.indexBuffer = device.makeBuffer(bytes: geometry.indicesBuffer, length: geometry.indexSize, options: .cpuCacheModeWriteCombined)
    }
    
    public func nextGeometryBuffer() -> (vertexBuffer: MTLBuffer, uvBuffer: MTLBuffer) {
        let vBuffer = vertexBuffers[bufferIndex]
        memcpy(vBuffer.contents(), geometry.verticesBuffer, geometry.verticesSize)
        let uBuffer = uvBuffers[bufferIndex]
        memcpy(uBuffer.contents(), geometry.uvsBuffer, geometry.uvsSize)
        
        bufferIndex += 1
        if bufferIndex == inflightBuffersCount {
            bufferIndex = 0
        }
        return (vBuffer, uBuffer)
    }
}















