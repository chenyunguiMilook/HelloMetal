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
    packed_float2 texCoord;
};

struct VertexOut{
    float4 position [[position]];
    float2 texCoord;
};

struct Uniforms{
    float4x4 modelMatrix;
    float4x4 projectionMatrix;
};

vertex VertexOut basic_vertex(device VertexIn* vertex_array [[ buffer(0) ]],
                              constant Uniforms&  uniforms    [[ buffer(1) ]],
                              unsigned int vid [[ vertex_id ]]) {

    float4x4 mv_Matrix = uniforms.modelMatrix;
    float4x4 proj_Matrix = uniforms.projectionMatrix;

    VertexIn input = vertex_array[vid];
    
    VertexOut output;
    output.position = proj_Matrix * mv_Matrix * float4(input.position, 1);
    output.texCoord = input.texCoord;
    
    return output;
}

fragment float4 basic_fragment(VertexOut interpolated [[stage_in]],
                               texture2d<float>  tex2D     [[ texture(0) ]],
                               sampler           sampler2D [[ sampler(0) ]]) {

    float4 color = tex2D.sample(sampler2D, interpolated.texCoord);
    return color;
}
