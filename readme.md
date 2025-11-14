````markdown
# PixelFlux

PixelFlux is a Swift framework for GPU-based image filters using Metal. It comes with a demo app to test filters on iOS.

> ⚠️ Note: This is my first project working with Metal shaders and GPU programming. I’m learning step by step.

## Project Structure

- `PixelFlux/` – The framework source code
  - `Engine/` – Handles Metal setup and compute pipelines
  - `Filters/` – Swift classes wrapping Metal shaders (e.g., BrightnessFilter)
  - `metal/` – Metal shader files (`.metal`)
  - `Public/PixelFlux.swift` – Public API for the framework
- `PixelFluxDemo/` – iOS app demonstrating the filters

## Usage

1. Build the framework target in Xcode.  
2. Add the framework to the demo app (embed & sign).  
3. Import in Swift code:

```swift
import PixelFlux

let filter = BrightnessFilter()
filter.brightness = 1.5
let outputTexture = filter.apply(inputTexture)
````

4. Run the demo app to see filters in action.

## Learning Goals

* Understand Metal shaders and GPU compute pipelines
* Learn how to structure a Swift framework
* Experiment with basic image processing

```


```
