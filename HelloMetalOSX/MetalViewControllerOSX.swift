//
//  ViewController.swift
//  HelloMetal
//
//  Created by Main Account on 10/2/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import Metal
import QuartzCore

protocol MetalViewControllerDelegateOSX : class {
    func updateLogic(_ timeSinceLastUpdate:CFTimeInterval)
    func renderObjects(_ drawable:CAMetalDrawable)
}

class MetalViewControllerOSX: NSViewController {
    var device: MTLDevice! = nil
    var metalLayer: CAMetalLayer! = nil
    var pipelineState: MTLRenderPipelineState! = nil
    var commandQueue: MTLCommandQueue! = nil
    var timer: CVDisplayLink?
    var projectionMatrix: Matrix4!
    var lastFrameTimestamp: CFTimeInterval = 0.0

    weak var metalViewControllerDelegate: MetalViewControllerDelegateOSX?

    let useLowPowerDevice = false

    override func loadView() {
        super.loadView()

        view.wantsLayer = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 85.0), aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height), nearZ: 0.01, farZ: 100.0)

        if (useLowPowerDevice) {
            for dv in MTLCopyAllDevices() {
                if (dv.isLowPower) {
                    device = dv
                    print("Using low power device")
                }
            }
        }
        if (device == nil) {
            device = MTLCreateSystemDefaultDevice()
            print("Using default device")
        }

        metalLayer = CAMetalLayer()
        metalLayer.device = device
        metalLayer.pixelFormat = .bgra8Unorm
        metalLayer.framebufferOnly = true
        metalLayer.frame = view.layer!.frame
        view.layer!.addSublayer(metalLayer)


        commandQueue = device.makeCommandQueue()

        let defaultLibrary = device.newDefaultLibrary()
        let fragmentProgram = defaultLibrary!.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary!.makeFunction(name: "basic_vertex")


        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = MTLBlendOperation.add;
        pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = MTLBlendOperation.add;
        pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = MTLBlendFactor.one;
        pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = MTLBlendFactor.one;
        pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = MTLBlendFactor.oneMinusSourceAlpha;
        pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = MTLBlendFactor.oneMinusSourceAlpha;

        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        } catch let error as NSError {
            print("Failed to create pipeline state, error \(error.localizedDescription)")
        }

        func displayLinkOutputCallback(_ displayLink: CVDisplayLink, _ inNow: UnsafePointer<CVTimeStamp>, _ inOutputTime: UnsafePointer<CVTimeStamp>, _ flagsIn: CVOptionFlags, _ flagsOut: UnsafeMutablePointer<CVOptionFlags>, _ displayLinkContext: UnsafeMutableRawPointer) -> CVReturn {

            let time = Double(inNow.pointee.videoTime) / 1000000000.0;
            unsafeBitCast(displayLinkContext, to: MetalViewControllerOSX.self).newFrame(time)

            return kCVReturnSuccess
        }

        CVDisplayLinkCreateWithActiveCGDisplays(&timer)
        CVDisplayLinkSetOutputCallback(timer!, displayLinkOutputCallback as? CVDisplayLinkOutputCallback, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
        CVDisplayLinkStart(timer!)
    }

    override func viewDidAppear() {
        view.window!.title = device.name!
    }

    override func viewDidLayout() {
        super.viewDidLayout()

        if let window = view.window {
            let scale = window.screen!.backingScaleFactor
            let layerSize = view.bounds.size

            metalLayer.frame = CGRect(x: 0, y: 0, width: layerSize.width, height: layerSize.height)
            metalLayer.drawableSize = CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
        }
        projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 85.0), aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height), nearZ: 0.01, farZ: 100.0)
    }

    func render() {
        if let drawable = metalLayer.nextDrawable(){
            self.metalViewControllerDelegate?.renderObjects(drawable)
        }
    }

    func newFrame(_ time: Double) {
        if lastFrameTimestamp == 0.0 {
            lastFrameTimestamp = time
        }

        let elapsed: CFTimeInterval = time - lastFrameTimestamp
        gameloop(timeSinceLastUpdate: elapsed)

        lastFrameTimestamp = time
    }

    func gameloop(timeSinceLastUpdate: CFTimeInterval) {
        self.metalViewControllerDelegate?.updateLogic(timeSinceLastUpdate)

        autoreleasepool {
            self.render()
        }
    }
}
