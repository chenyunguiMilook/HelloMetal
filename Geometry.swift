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
    
    public var verticesBuffer: [Float] {
        return vertices.map{ [$0.x, $0.y, $0.z] }.flatMap{ $0 }
    }
    
    public var uvsBuffer: [Float] {
        return uvs.map{ [$0.x, $0.y] }.flatMap{ $0 }
    }
    
    public var indicesBuffer: [UInt32] {
        return indices.map{ [$0.x, $0.y, $0.z] }.flatMap{ $0 }
    }
    
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











