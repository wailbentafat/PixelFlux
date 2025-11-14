import Foundation
import Metal


final class ComputePipeline {
let state: MTLComputePipelineState
private let device: MTLDevice


init(functionName: String) throws {
self.device = GPUContext.shared.device
guard let lib = device.makeDefaultLibrary() else {
throw NSError(domain: "PixelFlux", code: -1, userInfo: [NSLocalizedDescriptionKey: "Default Metal library not found. Make sure .metal files are in target."])
}
guard let fn = lib.makeFunction(name: functionName) else {
throw NSError(domain: "PixelFlux", code: -2, userInfo: [NSLocalizedDescriptionKey: "Function \(functionName) not found in default library."])
}
self.state = try device.makeComputePipelineState(function: fn)
}


func encode(commandBuffer: MTLCommandBuffer, input: MTLTexture, output: MTLTexture, buffers: [MTLBuffer] = []) {
guard let encoder = commandBuffer.makeComputeCommandEncoder() else { return }
encoder.setComputePipelineState(state)
encoder.setTexture(input, index: 0)
encoder.setTexture(output, index: 1)


for (i, b) in buffers.enumerated() {
encoder.setBuffer(b, offset: 0, index: i)
}


let threadsPerThreadgroup = MTLSize(width: 16, height: 16, depth: 1)
let threadsPerGrid = MTLSize(width: input.width, height: input.height, depth: 1)
encoder.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadgroup)
encoder.endEncoding()
}
}
