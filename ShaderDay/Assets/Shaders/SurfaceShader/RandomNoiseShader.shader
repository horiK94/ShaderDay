Shader "Custom/RandomNoiseShader"
{
    Properties
    {
        _MainTex("main texture", 2D) = "white"{}
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

        sampler2D _MainTex;

        struct Input
        {
            fixed2 uv_MainTex;
        };

        fixed rand(fixed2 co, float _seed)
        {
            return frac(sin(dot(co.rg ,fixed2(12.9898,78.233)) + _seed) * 43758.5453);
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = rand(IN.uv_MainTex, _Time.r);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
