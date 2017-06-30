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
    
    public init(device: MTLDevice) {
        //Front
        let A = Vertex(x: -1.0, y:   1.0, z:   0)
        let B = Vertex(x: -1.0, y:  -1.0, z:   0)
        let C = Vertex(x:  1.0, y:  -1.0, z:   0)
        let D = Vertex(x:  1.0, y:   1.0, z:   0)
        
        // 2
        let verticesArray:Array<Vertex> = [
            A,B,C,D,   //Front
        ]
        
        let E = UV(x: 0, y: 1)
        let F = UV(x: 0, y: 0)
        let G = UV(x: 1, y: 0)
        let H = UV(x: 1, y: 1)
        
        let uvArray: [UV] = [E, F, G, H]
        let I = Indices(x: 0, y: 1, z: 2)
        let J = Indices(x: 0, y: 2, z: 3)
        let indexArray: [Indices] = [I, J]
        
        //3
        let texture = MetalTexture(resourceName: "cube", ext: "png")
        texture.loadTexture(device: device, flip: true)
        
        super.init(name: "Cube", vertices: verticesArray, uvs: uvArray, indices: indexArray, device: device, texture: texture.texture)
    }
}
