import Foundation
import Metal
import UIKit


public final class PixelFlux {
public static let shared = PixelFlux()
private init() {}


public func applyPassthrough(to image: UIImage) throws -> UIImage? {
let input = try makeTexture(from: image)
let filter = try PassthroughFilter()
let out = try filter.process(input)
return image(from: out)
}


public func applyBrightness(to image: UIImage, brightness: Float) throws -> UIImage? {
let input = try makeTexture(from: image)
let filter = try BrightnessFilter()
let out = try filter.process(input, brightness: brightness)
return image(from: out)
}
}
