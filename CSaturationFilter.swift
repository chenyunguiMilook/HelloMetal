//
//  CSaturationFilter.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/7.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal

public class CSaturationFilter : CustomFilter {
    
    public var saturation: Float = 0
    
    public init(library: MTLLibrary, saturation: Float) {
        self.saturation = saturation
        super.init(name: "Saturation", library: library)
    }
    
    public override func getParameters() -> [Float] {
        return [saturation]
    }
}
