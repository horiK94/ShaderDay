Shader "Custom/RimLighting"
{
    Properties
    {
        _Color("Color", Color) = (0, 0, 0, 0)
        _EmissionColor("emission color", Color) = (0, 0, 0, 0)
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
        fixed4 _Color;
        fixed4 _EmissionColor;

        struct Input
        {
            float3 viewDir : TEXCOORD0;
            float3 worldNormal : TEXCOORD1;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float emission = 1 - abs(dot(normalize(IN.viewDir), normalize(IN.worldNormal)));
            o.Alpha = 1;
            o.Albedo = _Color;
            o.Emission = pow(emission, 3) * _EmissionColor;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
