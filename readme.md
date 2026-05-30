
# PixelFlux

PixelFlux is a Swift framework for GPU-based image filters using Metal. It allows applying real-time image effects like brightness adjustments and pass-through filtering. The project includes a demo iOS app to test the filters visually.

**[📖 Documentation](https://wailbentafat.github.io/PixelFlux/)** — API reference, architecture guide, and getting started tutorial.

This is my first project working with Metal shaders and GPU programming. I built it to learn how to integrate Metal compute shaders into a Swift framework, structure reusable filter code, and connect it to an iOS app. While simple, it demonstrates the core concepts of GPU-based image processing.

## Project Structure

- `PixelFlux/` – The framework source code  
  - `Engine/` – Handles Metal setup, compute pipelines, and texture utilities  
  - `Filters/` – Swift classes wrapping Metal shaders (e.g., `BrightnessFilter`)  
  - `metal/` – Metal shader files (`.metal`) for GPU execution  
  - `Public/PixelFlux.swift` – Public API to apply filters from Swift code  
- `PixelFluxDemo/` – iOS app demonstrating usage of the framework  
- `PixelFluxDemoTests/` and `PixelFluxDemoUITests/` – Basic test targets  

## Usage

1. Build the `PixelFlux` framework in Xcode.  
2. Add it to the demo app target under **Frameworks, Libraries, and Embedded Content** and select **Embed & Sign**.  
3. Import the framework in your Swift code:

```swift
import PixelFlux

let filter = BrightnessFilter()
filter.brightness = 1.5
let outputTexture = filter.apply(inputTexture)
````

4. Run the demo app on a simulator or device to see the filters in action.

## Learning Goals

* Understand how Metal shaders work and how to execute them from Swift
* Learn how to structure a Swift framework for reuse
* Explore basic GPU-based image processing techniques
* Gain experience linking frameworks to iOS apps

PixelFlux is a learning project, but it provides a foundation to expand with more advanced filters, multi-texture processing, or video effects in the future.

```


