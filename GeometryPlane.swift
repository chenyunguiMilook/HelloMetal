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
        var faces = [int3](repeating: int3(0, 0, 0), count: faceCount)
        
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
        let uw = Int32(width)
        
        for i in 0 ..< height-1 {
            
            for j in 0 ..< width {
                
                let ui = Int32(i)
                let uj = Int32(j)
                
                if i%2 == 0 {
                    // emit extra index to create degenerate triangle
                    if (j == 0) {
                        faces[index].x = ui*uw+uj
                        faces[index].y = ui*uw+uj+1
                        faces[index].z = (ui+1)*uw+uj
                        index += 1
                        continue
                    }
                    
                    // emit extra index to create degenerate triangle
                    if (j == (width-1)) {
                        faces[index].x = ui*uw+uj
                        faces[index].y = (ui+1)*uw+uj
                        faces[index].z = (ui+1)*uw+uj-1
                        index += 1
                        continue
                    }
                    
                    faces[index].x = ui*uw+uj
                    faces[index].y = ui*uw+uj+1
                    faces[index].z = (ui+1)*uw+uj
                    index += 1
                    
                    faces[index].x = ui*uw+uj
                    faces[index].y = (ui+1)*uw+uj
                    faces[index].z = (ui+1)*uw+uj-1
                    index += 1
                    
                } else {
                    // emit extra index to create degenerate triangle
                    if (j == 0) {
                        faces[index].x = ui*uw+uj
                        faces[index].y = ui*uw+uj+1
                        faces[index].z = (ui+1)*uw+uj
                        index += 1
                        continue
                    }
                    
                    // emit extra index to create degenerate triangle
                    if (j == (width-1)) {
                        faces[index].x = ui*uw+uj
                        faces[index].y = (ui+1)*uw+uj
                        faces[index].z = (ui+1)*uw+uj-1
                        index += 1
                        continue
                    }
                    
                    faces[index].x = ui*uw+uj
                    faces[index].y = (ui+1)*uw+uj
                    faces[index].z = (ui+1)*uw+uj-1
                    index += 1
                    
                    faces[index].x = ui*uw+uj
                    faces[index].y = ui*uw+uj+1
                    faces[index].z = (ui+1)*uw+uj
                    index += 1
                }
            }
        }
        print("did init vertices")
        super.init(vertices: vertices, uvs: uvs, faces: faces)
    }
    
}
