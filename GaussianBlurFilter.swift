//
//  GaussianBlurFilter.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/7/7.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import MetalPerformanceShaders

final public class GaussianBlurFilter: MetalFilter {
    
    public init(device: MTLDevice, sigma: Float) {
        super.init(device: device, filter: MPSImageGaussianBlur.init(device: device, sigma: sigma))
    }
}
