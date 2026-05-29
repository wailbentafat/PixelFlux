import Foundation
import Metal
import MetalKit
import CoreImage
import UIKit

func makeTexture(from uiImage: UIImage) throws -> MTLTexture {
    guard let cg = uiImage.cgImage else {
        throw PixelFluxError.noCGImage
    }
    let loader = GPUContext.shared.textureLoader
    let options: [MTKTextureLoader.Option: Any] = [
        .SRGB: false,
        .textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue),
        .textureStorageMode: NSNumber(value: MTLStorageMode.shared.rawValue)
    ]
    return try loader.newTexture(cgImage: cg, options: options)
}

func makeEmptyTexture(matching source: MTLTexture) -> MTLTexture {
    let desc = MTLTextureDescriptor.texture2DDescriptor(
        pixelFormat: source.pixelFormat,
        width: source.width,
        height: source.height,
        mipmapped: false
    )
    desc.usage = [.shaderRead, .shaderWrite]
    desc.storageMode = .shared
    guard let t = GPUContext.shared.device.makeTexture(descriptor: desc) else {
        fatalError("Failed to create output texture")
    }
    return t
}

func textureToUIImage(_ texture: MTLTexture) -> UIImage? {
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    guard let ciImage = CIImage(mtlTexture: texture, options: [CIImageOption.colorSpace: colorSpace]) else {
        return nil
    }
    let flipped = ciImage.transformed(by: CGAffineTransform(scaleX: 1, y: -1)
        .translatedBy(x: 0, y: -ciImage.extent.height))
    let ci = GPUContext.shared.ciContext
    guard let cg = ci.createCGImage(flipped, from: flipped.extent) else { return nil }
    return UIImage(cgImage: cg)
}
