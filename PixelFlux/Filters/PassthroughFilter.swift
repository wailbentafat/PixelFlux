import Foundation
import Metal
import UIKit

public final class PassthroughFilter: Filter {
    private let pipeline: ComputePipeline

    public init() throws {
        self.pipeline = try ComputePipeline(functionName: "passthroughKernel")
    }

    public func process(_ input: MTLTexture) throws -> MTLTexture {
        let output = makeEmptyTexture(matching: input)
        guard let cmd = GPUContext.shared.queue.makeCommandBuffer() else {
            throw PixelFluxError.commandBufferFailed
        }
        pipeline.encode(commandBuffer: cmd, input: input, output: output)
        cmd.commit()
        cmd.waitUntilCompleted()
        return output
    }

    public func apply(to inputImage: UIKit.UIImage) throws -> UIKit.UIImage? {
        let input = try makeTexture(from: inputImage)
        let output = try process(input)
        return textureToUIImage(output)
    }
}
