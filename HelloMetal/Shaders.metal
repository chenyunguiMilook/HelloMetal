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

vertex float4 wireframe_vertex(const device packed_float2* vertex_array [[ buffer(0) ]],
                           unsigned int vertexID [[ vertex_id ]]) {
    return float4(vertex_array[vertexID], 0, 1.0);
}
fragment float4 wireframe_fragment(constant float4 &color [[ buffer(0) ]]) {
    return color;
}

// MARK: - point shaders

struct PointOut {
    float4 position [[position]];
    float pointSize [[point_size]];
};

vertex PointOut point_vertex(const device packed_float3* vertex_array [[ buffer(0) ]],
                             constant float &size [[ buffer(1) ]],
                              unsigned int vertexID [[ vertex_id ]]) {
    PointOut out;
    out.position = float4(vertex_array[vertexID], 1.0);
    out.pointSize = size;
    return out;
}

fragment float4 point_fragment(PointOut fragData [[stage_in]],
                              constant float4 &color [[buffer(0)]],
                              float2 pointCoord [[point_coord]]) {
    if (length(pointCoord - float2(0.5)) > 0.5) {
        discard_fragment();
    }
    return color;
}




