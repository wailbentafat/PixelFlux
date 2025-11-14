//
//  PixelFlux.metal
//  PixelFlux
//
//  Created by omar on 14/11/2025.
//

#include <metal_stdlib>
using namespace metal;


kernel void passthroughKernel(
texture2d<float, access::read> inTexture [[ texture(0) ]],
texture2d<float, access::write> outTexture [[ texture(1) ]],
uint2 gid [[ thread_position_in_grid ]]
) {
if (gid.x >= outTexture.get_width() || gid.y >= outTexture.get_height()) return;
float4 color = inTexture.read(gid);
outTexture.write(color, gid);
}
