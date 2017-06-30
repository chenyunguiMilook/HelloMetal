//
//  Vertex.swift
//  HelloMetal
//
//  Created by Andrew K. on 10/23/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

public struct Vertex {
    
    var x, y, z: Float // position data
    
    public func floatBuffer() -> [Float] {
        return [x, y, z]
    }
}


public struct UV {
    var x, y: Float
    
    public func floatBuffer() -> [Float] {
        return [x, y]
    }
}


public struct Indices {
    var x, y, z: UInt32
    
    public func intBuffer() -> [UInt32] {
        return [x, y, z]
    }
}
