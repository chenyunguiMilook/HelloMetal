//
//  Vertex.swift
//  HelloMetal
//
//  Created by Andrew K. on 10/23/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

public struct Vertex {
    
    var x, y, z: Float // position data
    var s, t: Float // texture coordinates
    
    public func floatBuffer() -> [Float] {
        return [x, y, z, s, t]
    }
}
