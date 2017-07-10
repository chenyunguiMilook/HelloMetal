//
//  GeometryWireframeBuffer.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/10.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal

public class GeometryWireframeBuffer {
    
    internal let inflightBuffersCount: Int
    private var bufferIndex: Int = 0
    
    public var geometry: Geometry
    private var edgeBuffers: [MTLBuffer] = []
    
    public init(geometry: Geometry, device: MTLDevice, inflightBuffersCount: Int = 3) {
        self.geometry = geometry
        self.inflightBuffersCount = inflightBuffersCount
        
        for _ in 0 ..< inflightBuffersCount {
            if let vertexBuffer = device.makeBuffer(bytes: geometry.edgeBuffer, length: geometry.edgeSize, options: []) {
                edgeBuffers.append(vertexBuffer)
            }
        }
    }
    
    public func nextGeometryBuffer() -> MTLBuffer {
        let edgeBuffer = edgeBuffers[bufferIndex]
        memcpy(edgeBuffer.contents(), geometry.edgeBuffer, geometry.edgeSize)
        
        bufferIndex += 1
        if bufferIndex == inflightBuffersCount {
            bufferIndex = 0
        }
        return edgeBuffer
    }
}

