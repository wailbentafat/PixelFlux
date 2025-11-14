import Foundation
import Metal
import MetalKit
import CoreImage
import UIKit


func makeTexture(from uiImage: UIImage) throws -> MTLTexture {
guard let cg = uiImage.cgImage else { throw NSError(domain: "PixelFlux", code: -20, userInfo: [NSLocalizedDescriptionKey: "UIImage has no CGImage"]) }
let loader = GPUContext.shared.textureLoader
let options: [MTKTextureLoader.Option: Any] = [
.SRGB: false,
.textureUsage: NSNumber(value: MTLTextureUsage.shaderRead.rawValue),
.textureStorageMode: NSNumber(value: MTLStorageMode.private.rawValue)
]
return try loader.newTexture(cgImage: cg, options: options)
}


func makeEmptyTexture(matching source: MTLTexture) -> MTLTexture {
let desc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: source.pixelFormat,
width: source.width,
height: source.height,
mipmapped: false)
desc.usage = [.shaderRead, .shaderWrite]
desc.storageMode = .private
guard let t = GPUContext.shared.device.makeTexture(descriptor: desc) else {
fatalError("Failed to create output texture")
}
return t
}


func image(from texture: MTLTexture) -> UIImage? {
guard let ciImage = CIImage(mtlTexture: texture, options: [CIImageOption.colorSpace: CGColorSpaceCreateDeviceRGB()]) else { return nil }
let ci = GPUContext.shared.ciContext
guard let cg = ci.createCGImage(ciImage, from: CGRect(x: 0, y: 0, width: texture.width, height: texture.height)) else { return nil }
return UIImage(cgImage: cg)
}
