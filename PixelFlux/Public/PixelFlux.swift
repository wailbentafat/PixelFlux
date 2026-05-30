import Foundation
import Metal
import UIKit

/// High-level convenience API. Use filter classes directly for more control.
///
/// Named `PixelFluxEngine` to avoid shadowing the `PixelFlux` module name,
/// which would break Swift binary framework distribution (swiftinterface verification).
public final class PixelFluxEngine {
    public static let shared = PixelFluxEngine()
    private init() {}

    public func applyPassthrough(to inputImage: UIImage) throws -> UIImage? {
        return try PassthroughFilter().apply(to: inputImage)
    }

    public func applyBrightness(to inputImage: UIImage, brightness: Float) throws -> UIImage? {
        return try BrightnessFilter(brightness: brightness).apply(to: inputImage)
    }
}
