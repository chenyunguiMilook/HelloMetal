//
//  Mirror.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/6.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import CoreGraphics

public enum MGLRotation : Int {
    case none, angle90, angle180, angle270
}

extension MGLRotation {
    
    public var angle:CGFloat {
        switch self {
        case .none:     return  0
        case .angle90:  return  CGFloat.pi/2
        case .angle180: return  CGFloat.pi
        case .angle270: return -CGFloat.pi/2
        }
    }
    
    public var reverseRotation: MGLRotation {
        switch self {
        case .none:     return .none
        case .angle90:  return .angle270
        case .angle180: return .angle180
        case .angle270: return .angle90
        }
    }
    
    public func rotate(aroundCenter center: CGPoint) -> CGAffineTransform {
        return CGAffineTransform(rotate: self.angle, aroundCenter: center)
    }
}
