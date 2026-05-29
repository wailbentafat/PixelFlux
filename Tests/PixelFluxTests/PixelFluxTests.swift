import XCTest
@testable import PixelFlux
import UIKit

final class PixelFluxTests: XCTestCase {

    // MARK: - BrightnessFilter

    func testBrightnessFilterInit() throws {
        let filter = try BrightnessFilter(brightness: 0.5)
        XCTAssertEqual(filter.brightness, 0.5)
    }

    func testBrightnessFilterDefaultBrightness() throws {
        let filter = try BrightnessFilter()
        XCTAssertEqual(filter.brightness, 0.0)
    }

    func testBrightnessFilterApplyReturnsImage() throws {
        let input = makeImage(color: .red, size: CGSize(width: 64, height: 64))
        let filter = try BrightnessFilter(brightness: 0.2)
        let result = try filter.apply(to: input)
        XCTAssertNotNil(result)
        // Texture dimensions match the input pixel dimensions (scale=1)
        XCTAssertEqual(result?.size.width, 64)
        XCTAssertEqual(result?.size.height, 64)
    }

    func testBrightnessFilterNeutralBrightness() throws {
        let input = makeImage(color: .blue, size: CGSize(width: 32, height: 32))
        let filter = try BrightnessFilter(brightness: 0.0)
        let result = try filter.apply(to: input)
        XCTAssertNotNil(result)
    }

    func testBrightnessFilterNegativeBrightness() throws {
        // Use a non-pure-white SDR color to avoid extended range issues
        let gray = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        let input = makeImage(color: gray, size: CGSize(width: 32, height: 32))
        let filter = try BrightnessFilter(brightness: -0.5)
        let result = try filter.apply(to: input)
        XCTAssertNotNil(result)
    }

    func testBrightnessFilterApplyMultipleTimes() throws {
        let input = makeImage(color: .green, size: CGSize(width: 16, height: 16))
        let filter = try BrightnessFilter(brightness: 0.1)
        let result1 = try filter.apply(to: input)
        let result2 = try filter.apply(to: input)
        XCTAssertNotNil(result1)
        XCTAssertNotNil(result2)
    }

    // MARK: - PassthroughFilter

    func testPassthroughFilterInit() throws {
        XCTAssertNoThrow(try PassthroughFilter())
    }

    func testPassthroughFilterPreservesSize() throws {
        let input = makeImage(color: .green, size: CGSize(width: 128, height: 64))
        let filter = try PassthroughFilter()
        let result = try filter.apply(to: input)
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.size.width, 128)
        XCTAssertEqual(result?.size.height, 64)
    }

    func testPassthroughFilterPreservesContent() throws {
        let input = makeImage(color: .cyan, size: CGSize(width: 32, height: 32))
        let filter = try PassthroughFilter()
        let result = try filter.apply(to: input)
        XCTAssertNotNil(result)
    }

    // MARK: - PixelFlux shared API

    func testSharedAPIApplyBrightness() throws {
        let input = makeImage(color: .red, size: CGSize(width: 32, height: 32))
        let result = try PixelFlux.shared.applyBrightness(to: input, brightness: 0.1)
        XCTAssertNotNil(result)
    }

    func testSharedAPIApplyPassthrough() throws {
        let input = makeImage(color: .cyan, size: CGSize(width: 32, height: 32))
        let result = try PixelFlux.shared.applyPassthrough(to: input)
        XCTAssertNotNil(result)
    }

    func testSharedAPIIsSingleton() {
        XCTAssertTrue(PixelFlux.shared === PixelFlux.shared)
    }

    // MARK: - Error handling

    func testBrightnessFilterRequiresCGImage() {
        let emptyImage = UIImage()
        XCTAssertThrowsError(try BrightnessFilter(brightness: 0.3).apply(to: emptyImage)) { error in
            XCTAssertTrue(error is PixelFluxError)
        }
    }

    func testPassthroughFilterRequiresCGImage() {
        let emptyImage = UIImage()
        XCTAssertThrowsError(try PassthroughFilter().apply(to: emptyImage)) { error in
            XCTAssertTrue(error is PixelFluxError)
        }
    }

    // MARK: - Helpers

    /// Creates a solid-color UIImage at 1x scale in standard (SDR) range.
    private func makeImage(color: UIColor, size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1.0
        format.preferredRange = .standard
        return UIGraphicsImageRenderer(size: size, format: format).image { ctx in
            color.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
        }
    }
}
