Shader "Custom/ValueNoise"
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

        fixed valueNoise(fixed2 uv)
        {
            fixed2 box_uv = floor(uv * fixed2(_Block_X, _Block_Y));
            fixed2 frac_uv = frac(uv * fixed2(_Block_X, _Block_Y));

            float v00 = rand(box_uv, 0); 
            float v11 = rand(box_uv + fixed2(1, 1), 0);

            float v01 = rand(box_uv + fixed2(0, 1), 0);
            float v10 = rand(box_uv + fixed2(1, 0), 0);
            
            //位置を補間
            fixed2 u = -2 * pow(frac_uv, 3) + 3 * pow(frac_uv, 2);

            float v0010 = lerp(v00, v10, u.x);
            float v0111 = lerp(v01, v11, u.x);

            return lerp(v0010, v0111, u.y);
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            float c = valueNoise(IN.uv_MainTex);
            o.Albedo = fixed4(c, c, c, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
