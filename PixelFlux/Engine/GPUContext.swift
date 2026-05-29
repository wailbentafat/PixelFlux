import Foundation
import Metal
import MetalKit
import CoreImage

final class GPUContext {
    static let shared: GPUContext = {
        guard let ctx = try? GPUContext() else {
            fatalError("Metal is not supported on this device")
        }
        return ctx
    }()

    let device: MTLDevice
    let queue: MTLCommandQueue
    let ciContext: CIContext
    let textureLoader: MTKTextureLoader

    private init() throws {
        guard let device = MTLCreateSystemDefaultDevice() else {
            throw PixelFluxError.metalLibraryNotFound
        }
        self.device = device
        guard let q = device.makeCommandQueue() else {
            throw PixelFluxError.commandBufferFailed
        }
        self.queue = q
        self.ciContext = CIContext(mtlDevice: device)
        self.textureLoader = MTKTextureLoader(device: device)
    }
}
