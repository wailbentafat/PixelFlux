import Foundation
import Metal

public protocol Filter {
    func process(_ input: MTLTexture) throws -> MTLTexture
}
