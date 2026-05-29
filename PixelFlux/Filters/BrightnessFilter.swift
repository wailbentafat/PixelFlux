import Foundation
import Metal
import UIKit

private struct BrightnessParams {
    var brightness: Float
}

public final class BrightnessFilter {
    private let pipeline: ComputePipeline
    public let brightness: Float

    public init(brightness: Float = 0.0) throws {
        self.brightness = brightness
        self.pipeline = try ComputePipeline(functionName: "brightnessKernel")
    }

    public func apply(to inputImage: UIKit.UIImage) throws -> UIKit.UIImage? {
        let input = try makeTexture(from: inputImage)
        var params = BrightnessParams(brightness: brightness)
        guard let buffer = GPUContext.shared.device.makeBuffer(
            bytes: &params,
            length: MemoryLayout<BrightnessParams>.size,
            options: .storageModeShared
        ) else {
            throw PixelFluxError.bufferCreationFailed
        }
        let output = makeEmptyTexture(matching: input)
        guard let cmd = GPUContext.shared.queue.makeCommandBuffer() else {
            throw PixelFluxError.commandBufferFailed
        }
        pipeline.encode(commandBuffer: cmd, input: input, output: output, buffers: [buffer])
        cmd.commit()
        cmd.waitUntilCompleted()
        return textureToUIImage(output)
    }
}
