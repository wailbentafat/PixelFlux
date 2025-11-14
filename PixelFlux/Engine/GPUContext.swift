import Foundation
import Metal
import MetalKit
import CoreImage


final class GPUContext {
static let shared: GPUContext = {
return try! GPUContext()
}()


let device: MTLDevice
let queue: MTLCommandQueue
let ciContext: CIContext
let textureLoader: MTKTextureLoader


private init() throws {
guard let device = MTLCreateSystemDefaultDevice() else {
fatalError("Metal not supported on this device")
}
self.device = device
guard let q = device.makeCommandQueue() else {
fatalError("Failed to create command queue")
}
self.queue = q
self.ciContext = CIContext(mtlDevice: device)
self.textureLoader = MTKTextureLoader(device: device)
}
}
