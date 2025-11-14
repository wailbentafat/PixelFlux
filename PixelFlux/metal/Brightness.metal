//
//  Brightness.metal
//  PixelFlux
//
//  Created by omar on 14/11/2025.
//

#include <metal_stdlib>
using namespace metal;


struct BrightnessParams {
float brightness;
};


kernel void brightnessKernel(
texture2d<float, access::read> inTexture [[ texture(0) ]],
texture2d<float, access::write> outTexture [[ texture(1) ]],
constant Brightness params [[ buffer(0) ]],
uint2 gid [[ thread_position_in_grid ]]
) {
if (gid.x >= outTexture.get_width() || gid.y >= outTexture.get_height()) return;
float4 color = inTexture.read(gid);
color.rgb = color.rgb * (1.0 + params.brightness);
outTexture.write(color, gid);
}
