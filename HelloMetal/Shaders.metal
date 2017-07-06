//
//  Shaders.metal
//  HelloMetal
//
//  Created by Main Account on 10/2/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    packed_float3 position;
};

struct UVIn{
    packed_float2 uv;
};

struct VertexOut{
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexOut basic_vertex(device VertexIn* vertex_array [[ buffer(0) ]],
                              device UVIn* uv_array [[ buffer(1) ]],
                              unsigned int vid [[ vertex_id ]]) {

    VertexIn input = vertex_array[vid];
    UVIn uvInput = uv_array[vid];
    
    VertexOut output;
    output.position = float4(input.position, 1);
    output.texCoord = uvInput.uv;
    
    return output;
}

fragment float4 basic_fragment(VertexOut interpolated [[stage_in]],
                               texture2d<float>  tex2D     [[ texture(0) ]],
                               sampler           sampler2D [[ sampler(0) ]]) {

    float4 color = tex2D.sample(sampler2D, interpolated.texCoord);
    return color;
}

// MARK: - wireframe shaders

vertex float4 wireframe_vertex(device VertexIn* points [[ buffer(0) ]],
                               unsigned int vid [[ vertex_id ]]) {
    return float4(points[vid].position, 1.0);
}

fragment float4 wireframe_fragment(constant float4 &color [[ buffer(0) ]]) {
    return color;
}




