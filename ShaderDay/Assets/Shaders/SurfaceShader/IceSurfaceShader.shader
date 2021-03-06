Shader "Custom/IceSurfaceShader"
{
    Properties
    {
        _Color("Color", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float3 viewDir : TEXCOORD0;
            float3 worldNormal : TEXCOORD1;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float alpha = 1 - abs(dot(IN.viewDir, IN.worldNormal));
            o.Alpha  = alpha * 1.5;
            o.Albedo = (0.2, 0.2, 0.2, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
