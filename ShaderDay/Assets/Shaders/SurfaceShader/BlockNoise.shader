Shader "Custom/BlockNoise"
{
    Properties
    {
        _MainTex("main texture", 2D) = "white"{}
        _Block_X("block x", Int) = 1
        _Block_Y("block y", Int) = 1
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
        int _Block_X;
        int _Block_Y;

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
            fixed2 uv = fixed2(IN.uv_MainTex.r * _Block_X, IN.uv_MainTex.g *  _Block_Y);
            float left_uv_x = trunc(uv.r) / _Block_X;
            float left_uv_y = trunc(uv.g) / _Block_Y;
            fixed leftUv =  rand(fixed2(left_uv_x, left_uv_y), 0);

            o.Albedo = leftUv;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
