//
//  CGAffineTransform+Behavior.swift
//  OpenGLKit
//
//  Created by chenyungui on 2016/11/1.
//
//

import Foundation
import CoreGraphics
import OpenGLES

public func * (m1: CGAffineTransform, m2: CGAffineTransform) -> CGAffineTransform {
    return m1.concatenating(m2)
}

extension CGAffineTransform {
    
    public init(rotate radian:CGFloat, aroundCenter center:CGPoint) {
        let cosa = cos(radian)
        let sina = sin(radian)
        self.a =  cosa
        self.b =  sina
        self.c = -sina
        self.d =  cosa
        self.tx =  center.y * sina - center.x * cosa + center.x
        self.ty = -center.y * cosa - center.x * sina + center.y
    }
    
    public init(scaleX:CGFloat, scaleY:CGFloat, aroundCenter center:CGPoint) {
        self.a = scaleX
        self.b = 0
        self.c = 0
        self.d = scaleY
        self.tx = center.x - center.x * scaleX
        self.ty = center.y - center.y * scaleY
    }
    
    public init(transform m: CGAffineTransform, aroundCenter center: CGPoint) {
        let x = center.x - center.x * m.a - center.y * m.c + m.tx
        let y = center.y - center.x * m.b - center.y * m.d + m.ty
        self.init(a: m.a, b: m.b, c: m.c, d: m.d, tx: x, ty: y)
    }
}

