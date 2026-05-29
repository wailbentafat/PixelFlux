import Foundation
import Metal

final class ComputePipeline {
    let state: MTLComputePipelineState
    private let device: MTLDevice

    init(functionName: String) throws {
        self.device = GPUContext.shared.device
        let lib = try ComputePipeline.loadLibrary(device: device)
        guard let fn = lib.makeFunction(name: functionName) else {
            throw PixelFluxError.functionNotFound(functionName)
        }
        self.state = try device.makeComputePipelineState(function: fn)
    }

    private static func loadLibrary(device: MTLDevice) throws -> MTLLibrary {
        // Try Bundle.module first (SPM builds embed the metallib in the module bundle).
        // Fall back to the framework bundle via a known class, then the main bundle.
        let candidates: [Bundle] = [
            Bundle.module,
            Bundle(for: GPUContext.self),
            Bundle.main
        ]
        for bundle in candidates {
            if let url = bundle.url(forResource: "default", withExtension: "metallib"),
               let lib = try? device.makeLibrary(URL: url) {
                return lib
            }
        }
        // Last resort: makeDefaultLibrary (looks in main bundle only)
        if let lib = device.makeDefaultLibrary() {
            return lib
        }
        throw PixelFluxError.metalLibraryNotFound
    }

    func encode(
        commandBuffer: MTLCommandBuffer,
        input: MTLTexture,
        output: MTLTexture,
        buffers: [MTLBuffer] = []
    ) {
        guard let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
        encoder.setComputePipelineState(state)
        encoder.setTexture(input, index: 0)
        encoder.setTexture(output, index: 1)
        for (i, b) in buffers.enumerated() {
            encoder.setBuffer(b, offset: 0, index: i)
        }
        let threadsPerGroup = MTLSize(width: 16, height: 16, depth: 1)
        let threadsPerGrid = MTLSize(width: input.width, height: input.height, depth: 1)
        encoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerGroup)
        encoder.endEncoding()
    }
}
