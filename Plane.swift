//
//  Plane.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/6/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal

public class Plane: Node {
    
    public init(device: MTLDevice, commandQ: MTLCommandQueue) {
        //Front
        let A = Vertex(x: -1.0, y:   1.0, z:   0, s: 0, t: 1)
        let B = Vertex(x: -1.0, y:  -1.0, z:   0, s: 0, t: 0)
        let C = Vertex(x:  1.0, y:  -1.0, z:   0, s: 1, t: 0)
        let D = Vertex(x:  1.0, y:   1.0, z:   0, s: 1, t: 1)
        
        // 2
        let verticesArray:Array<Vertex> = [
            A,B,C ,A,C,D,   //Front
        ]
        
        //3
        let texture = MetalTexture(resourceName: "cube", ext: "png")
        texture.loadTexture(device: device, flip: true)
        
        super.init(name: "Cube", vertices: verticesArray, device: device, texture: texture.texture)
    }
}
