import Foundation
import Metal


public final class PassthroughFilter: Filter {
private let pipeline: ComputePipeline


public init() throws {
self.pipeline = try ComputePipeline(functionName: "passthroughKernel")
}


public func process(_ input: MTLTexture) throws -> MTLTexture {
let output = makeEmptyTexture(matching: input)
guard let cmd = GPUContext.shared.queue.makeCommandBuffer() else { throw NSError(domain: "PixelFlux", code: -30, userInfo: nil) }
pipeline.encode(commandBuffer: cmd, input: input, output: output)
cmd.commit()
cmd.waitUntilCompleted()
return output
}
}
