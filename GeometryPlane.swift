//
//  GeometryPlane.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/6/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import simd

public class GeometryPlane : Geometry {
    
    public let widthSegments:Int
    public let heightSegments:Int
    
    public init(widthSegments:Int, heightSegments:Int) {
        
        self.widthSegments = widthSegments
        self.heightSegments = heightSegments
        
        let width = widthSegments + 1   // width: means along width has how many vertices
        let height = heightSegments + 1 // height: means along height has how many vertices
        
        let verticesCount = width * height
        var vertices = [float3](repeating: float3(0, 0, 0), count: verticesCount)
        var uvs = [float2](repeating: float2(0, 0), count: verticesCount)
        
        let faceCount = (width-1) * (height-1) * 2
        var indices = [uint3](repeating: uint3(0, 0, 0), count: faceCount)
        
        var index = 0
        let fw = Float(width)
        let fh = Float(height)
        
        for i in 0 ..< height {
            
            for j in 0 ..< width {
                
                index = i*width+j
                let fi = Float(i)
                let fj = Float(j)
                
                vertices[index].x = -1.0 + fj*(2.0/(fw-1.0))
                vertices[index].y =  1.0 - fi*(2.0/(fh-1.0))
                vertices[index].z =  0.0
                
                uvs[index].x = fj/(fw-1.0)
                uvs[index].y = 1.0 - fi/(fh-1.0)
            }
        }
        
        index = 0 // reset index for calculate face indices
        let uw = UInt32(width)
        
        for i in 0 ..< height-1 {
            
            for j in 0 ..< width {
                
                let ui = UInt32(i)
                let uj = UInt32(j)
                
                if i%2 == 0 {
                    // emit extra index to create degenerate triangle
                    if (j == 0) {
                        indices[index].x = ui*uw+uj
                        indices[index].y = ui*uw+uj+1
                        indices[index].z = (ui+1)*uw+uj
                        index += 1
                        continue
                    }
                    
                    // emit extra index to create degenerate triangle
                    if (j == (width-1)) {
                        indices[index].x = ui*uw+uj
                        indices[index].y = (ui+1)*uw+uj
                        indices[index].z = (ui+1)*uw+uj-1
                        index += 1
                        continue
                    }
                    
                    indices[index].x = ui*uw+uj
                    indices[index].y = ui*uw+uj+1
                    indices[index].z = (ui+1)*uw+uj
                    index += 1
                    
                    indices[index].x = ui*uw+uj
                    indices[index].y = (ui+1)*uw+uj
                    indices[index].z = (ui+1)*uw+uj-1
                    index += 1
                    
                } else {
                    // emit extra index to create degenerate triangle
                    if (j == 0) {
                        indices[index].x = ui*uw+uj
                        indices[index].y = ui*uw+uj+1
                        indices[index].z = (ui+1)*uw+uj
                        index += 1
                        continue
                    }
                    
                    // emit extra index to create degenerate triangle
                    if (j == (width-1)) {
                        indices[index].x = ui*uw+uj
                        indices[index].y = (ui+1)*uw+uj
                        indices[index].z = (ui+1)*uw+uj-1
                        index += 1
                        continue
                    }
                    
                    indices[index].x = ui*uw+uj
                    indices[index].y = (ui+1)*uw+uj
                    indices[index].z = (ui+1)*uw+uj-1
                    index += 1
                    
                    indices[index].x = ui*uw+uj
                    indices[index].y = ui*uw+uj+1
                    indices[index].z = (ui+1)*uw+uj
                    index += 1
                }
            }
        }
        print("did init vertices")
        super.init(vertices: vertices, uvs: uvs, indices: indices)
    }
    
}
