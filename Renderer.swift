//
//  Renderer.swift
//  HelloMetal
//
//  Created by chenyungui on 2017/6/29.
//  Copyright © 2017年 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import MetalKit
import MetalPerformanceShaders

let availableSources: Int = 3

public protocol RendererDelegate : class {
    func renderer(_ renderer: Renderer, didFinishRenderingWith image: UIImage?)
}

public class Renderer : NSObject {
    
    public weak var delegate: RendererDelegate?
    
    var device: MTLDevice!
    var library: MTLLibrary!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var model: Plane!
    var modelWireframe: GeometryWireframeRenderer!
    var filter: MPSImageGaussianBlur!
    
    var avaliableResourcesSemaphore: DispatchSemaphore!
    
    deinit {
        for _ in 0 ..< availableSources {
            self.avaliableResourcesSemaphore.signal()
        }
    }
    
    public init(device: MTLDevice) {
        super.init()
        self.device = device
        self.library = device.makeDefaultLibrary()!
        self.commandQueue = device.makeCommandQueue()
        self.model = Plane(library: library, pixelFormat: .bgra8Unorm, texture: "cube.png")
        self.model.geometry.uvTransform = getUVTransformForFlippedVertically()
        self.filter = MPSImageGaussianBlur.init(device: device, sigma: 0.5)
        
        self.modelWireframe = GeometryWireframeRenderer(name: "", library: library, pixelFormat: .bgra8Unorm, geometry: model.geometry, color: .red)
        self.avaliableResourcesSemaphore = DispatchSemaphore(value: availableSources)
    }
    
    public func renderFilter(in drawable: CAMetalDrawable) {
        
//        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
//        guard let texture = loadTexture(imageNamed: "cube.png", device: device) else { return }
//        let commandEncoder = commandBuffer.makeComputeCommandEncoder()
//        self.filter.encode(commandBuffer: commandBuffer, sourceTexture: texture, destinationTexture: drawable.texture)
        
        
    }
    
    public func render(in drawable: CAMetalDrawable) {
        
        _ = self.avaliableResourcesSemaphore.wait(timeout: DispatchTime.distantFuture)
        
        // MARK: - start render model to a texture
        guard let renderTarget = createBlankTexture(device: device, texture: drawable.texture) else { return }
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = renderTarget
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 0, 0, 0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        commandBuffer.addCompletedHandler { _ in
            // copy pixel buffer from drawable.texture
            //self.delegate?.renderer(self, didFinishRenderingWith: drawable.texture.exportImage())
            self.avaliableResourcesSemaphore.signal()
        }
        
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        self.model.render(commandEncoder: commandEncoder)
        //self.modelWireframe.render(commandEncoder: commandEncoder)
        
        commandEncoder.endEncoding()
        
        // MARK: - filter the texture and present it
        let filter = MPSImageGaussianBlur.init(device: device, sigma: 15.0)
        filter.encode(commandBuffer: commandBuffer, sourceTexture: renderTarget, destinationTexture: drawable.texture)
        
        commandBuffer.present(drawable) // the present target could be a MTLTexture
        commandBuffer.commit()
    }
}










