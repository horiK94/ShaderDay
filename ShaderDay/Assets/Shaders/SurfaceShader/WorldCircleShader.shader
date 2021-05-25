Shader "Custom/WorldCircleShader"
{
    Properties
    {
        _Duration("duration", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        fixed _Duration;

        struct Input
        {
            float3 worldPos;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float d = distance(IN.worldPos, 0);
            float g = step(0.98, sin((d - _Time.g) * _Duration));
            o.Albedo = fixed4(0.5, 0, 0.5, 1) + g;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
