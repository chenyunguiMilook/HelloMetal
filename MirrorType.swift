//
//  RotationType.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/6.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import CoreGraphics

public enum MirrorType {
    case none, horizontal, vertical, horizontalAndVertical
}

extension MirrorType {
    
    private func getScale() -> (x: CGFloat, y: CGFloat) {
        switch self {
        case .none:                  return ( 1,  1)
        case .horizontal:            return (-1,  1)
        case .vertical:              return ( 1, -1)
        case .horizontalAndVertical: return (-1, -1)
        }
    }
    
    public var reverseMirror: MirrorType {
        switch self {
        case .none:                  return .none
        case .horizontal:            return .vertical
        case .vertical:              return .horizontal
        case .horizontalAndVertical: return .horizontalAndVertical
        }
    }
    
    public var matrix:CGAffineTransform {
        let scale = getScale()
        return CGAffineTransform(scaleX: scale.x, y: scale.y)
    }
    
    public func mirror(aroundCenter center: CGPoint) -> CGAffineTransform {
        let scale = getScale()
        return CGAffineTransform(scaleX: scale.x, scaleY: scale.y, aroundCenter: center)
    }
}
