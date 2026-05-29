import Foundation

public enum PixelFluxError: LocalizedError {
    case noCGImage
    case metalLibraryNotFound
    case functionNotFound(String)
    case commandBufferFailed
    case bufferCreationFailed

    public var errorDescription: String? {
        switch self {
        case .noCGImage:
            return "UIImage has no CGImage backing"
        case .metalLibraryNotFound:
            return "Metal shader library not found in any bundle"
        case .functionNotFound(let name):
            return "Metal function '\(name)' not found in library"
        case .commandBufferFailed:
            return "Failed to create Metal command buffer"
        case .bufferCreationFailed:
            return "Failed to create Metal buffer"
        }
    }
}
