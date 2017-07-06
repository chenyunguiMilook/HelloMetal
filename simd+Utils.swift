//
//  simd+Utils.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/6.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit
import simd
import Accelerate

public func * (p: float2, m: CGAffineTransform) -> float2 {
    let x = m.a * CGFloat(p.x) + m.c * CGFloat(p.y) + m.tx
    let y = m.b * CGFloat(p.x) + m.d * CGFloat(p.y) + m.ty
    return float2(Float(x), Float(y))
}

public func * (p: float3, m:CGAffineTransform) -> float3 {
    let x = m.a * CGFloat(p.x) + m.c * CGFloat(p.y) + m.tx
    let y = m.b * CGFloat(p.x) + m.d * CGFloat(p.y) + m.ty
    return float3(Float(x), Float(y), p.z)
}

public func * (lhs:[float2], rhs:CGAffineTransform) -> [float2] {
    return lhs.map{ $0 * rhs }
}

public func *(points:[float3], t:CGAffineTransform) -> [float3] {
    let capacity = points.count * 3
    let matrix = [Float(t.a), Float(t.b), 0, Float(t.c), Float(t.d), 0, Float(t.tx), Float(t.ty), 1]
    var result = points
    
    points.withUnsafeBytes {
        let lFloats = $0.baseAddress?.bindMemory(to: Float.self, capacity: capacity)
        
        result.withUnsafeMutableBytes {
            let rFloats = $0.baseAddress?.bindMemory(to: Float.self, capacity: capacity)
            
            cblas_sgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, Int32(points.count), 3, 3, 1, lFloats, 3, matrix, 3, 0, rFloats, 3)
        }
    }
    return result
}

















