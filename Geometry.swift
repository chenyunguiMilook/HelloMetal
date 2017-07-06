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
import UIKit

public class Geometry {
    
    private var _vertices: [float3]
    private var _uvs: [float2]
    
    public private(set) var vertices: [float3]
    public private(set) var uvs: [float2]
    public private(set) var indices: [uint3]
    
    public var vertexTransform: CGAffineTransform = .identity {
        didSet {
            self.vertices = _vertices * vertexTransform
        }
    }
    public var uvTransform: CGAffineTransform = .identity {
        didSet {
            self.uvs = _uvs * uvTransform
        }
    }
    
    public init(vertices: [float3], uvs: [float2], indices: [uint3]) {
        self._vertices = vertices
        self.vertices = vertices
        self._uvs = uvs
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

extension Geometry {
    
    public var edgeSize: Int {
        return MemoryLayout<Float>.size * indices.count * 3 * 4
    }
    
    public var edgeBuffer: [Float] {
        
        // each face have three edge, each edge need four value(start.x, start.y, end.x, end.y)
        let edgeValueCount = indices.count * 3 * 4
        var edges = [Float](repeating: 0, count: edgeValueCount)
        
        var index:Int = 0
        for i in 0 ..< indices.count {
            
            let v0 = Int(indices[i].x)
            let v1 = Int(indices[i].y)
            let v2 = Int(indices[i].z)
            
            // v0 to v1
            edges[index]   = vertices[v0].x
            edges[index+1] = vertices[v0].y
            edges[index+2] = vertices[v1].x
            edges[index+3] = vertices[v1].y
            
            // v0 to v2
            edges[index+4] = vertices[v0].x
            edges[index+5] = vertices[v0].y
            edges[index+6] = vertices[v2].x
            edges[index+7] = vertices[v2].y
            
            // v1 to v2
            edges[index+8]  = vertices[v1].x
            edges[index+9]  = vertices[v1].y
            edges[index+10] = vertices[v2].x
            edges[index+11] = vertices[v2].y
            
            index = index + 12
        }
        
        return edges
    }
}









