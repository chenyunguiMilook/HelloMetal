//
//  MTLRenderCommandEncoder+Behavior.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/10.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import UIKit

extension MTLRenderCommandEncoder {
    
    public func setVertex<T>(value: inout T, `for` index: Int) {
        let length = MemoryLayout<T>.size
        self.setVertexBytes(&value, length: length, index: index)
    }
    
    public func setFragment<T>(value: inout T, `for` index: Int) {
        let length = MemoryLayout<T>.size
        self.setFragmentBytes(&value, length: length, index: index)
    }
    
    public func setVertex<T>(values: [T], `for` index: Int) {
        let length = MemoryLayout<T>.size * values.count
        self.setVertexBytes(values, length: length, index: index)
    }
    
    public func setFragment<T>(values: [T], `for` index: Int) {
        let length = MemoryLayout<T>.size * values.count
        self.setFragmentBytes(values, length: length, index: index)
    }
}

