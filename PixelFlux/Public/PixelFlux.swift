import Foundation
import Metal
import UIKit

/// High-level convenience API. Use filter classes directly for more control.
public final class PixelFlux {
    public static let shared = PixelFlux()
    private init() {}

    public func applyPassthrough(to inputImage: UIImage) throws -> UIImage? {
        return try PassthroughFilter().apply(to: inputImage)
    }

    public func applyBrightness(to inputImage: UIImage, brightness: Float) throws -> UIImage? {
        return try BrightnessFilter(brightness: brightness).apply(to: inputImage)
    }
}
