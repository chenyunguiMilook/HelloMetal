//
//  GlobalFunction.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/6.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import CoreGraphics

public func calculateUVTransform(frameBufferSize: CGSize, zoomRect: CGRect, mirror: MirrorType, rotation: RotationType) -> CGAffineTransform {
    let normalizeSize = CGAffineTransform(scaleX: 1.0/frameBufferSize.width, y: 1.0/frameBufferSize.height)
    let zoomRect = zoomRect.applying(normalizeSize)
    return getUVTransform(zoomRect: zoomRect, mirror: mirror, rotation: rotation)
}

public func getUVTransformForFlippedVertically() -> CGAffineTransform {
    return MirrorType.vertical.mirror(aroundCenter: CGPoint(x: 0.5, y: 0.5))
}

private func getUVTransform(zoomRect: CGRect, mirror: MirrorType, rotation: RotationType) -> CGAffineTransform {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let mm = mirror.mirror(aroundCenter: center)
    var rm = CGAffineTransform.identity
    
    switch mirror {
    case .none, .horizontalAndVertical:
        rm = rotation.reverseRotation.rotate(aroundCenter: center)
    case .horizontal, .vertical:
        rm = rotation.rotate(aroundCenter: center)
    }
    let fm = stretchFit(rect: rect, into: zoomRect)
    return mm * rm * fm
}

public func stretchFit(rect: CGRect, into target: CGRect) -> CGAffineTransform {
    // 1. move to origin
    let tx = -rect.origin.x
    let ty = -rect.origin.y
    // 2. scale match size
    let sx = target.width / rect.width
    let sy = target.height / rect.height
    // 3. move to target origin
    let mx = target.origin.x
    let my = target.origin.y
    // 4. compsoe matrix multiply result
    return CGAffineTransform(a: sx, b: 0, c: 0, d: sy, tx: tx * sx + mx, ty: ty * sy + my)
}
