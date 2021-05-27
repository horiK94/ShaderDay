Shader "Custom/fBmNoise"
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

        fixed2 rand(fixed2 st){
            st = fixed2( dot(st,fixed2(127.1,311.7)),
                           dot(st,fixed2(269.5,183.3)) );
            return -1.0 + 2.0*frac(sin(st)*43758.5453123);
        }

        fixed parin(fixed2 uv)
        {
            fixed2 calc_uv = uv;
            fixed2 flo = floor(calc_uv);
            fixed2 fra = frac(calc_uv);

            fixed2 v00 = rand(flo);
            fixed2 v10 = rand(flo + fixed2(1, 0));
            fixed2 v01 = rand(flo + fixed2(0, 1));
            fixed2 v11 = rand(flo + fixed2(1, 1));

            fixed2 u =-2 * pow(fra, 3) + 3 * pow(fra, 2);

            fixed2 v0010 = lerp(dot(v00, fra - fixed2(0, 0)), dot(v10, fra - fixed2(1 ,0)), u.x);
            fixed2 v0111 = lerp(dot(v01, fra - fixed2(0, 1)), dot(v11, fra - fixed2(1 ,1)), u.x);

            return lerp(v0010, v0111, u.y) + 0.5;
        }

        fixed fBm(fixed2 uv)
        {
            fixed f = 0;
            fixed2 p = uv * fixed2(_Block_X, _Block_Y);

            f += 0.5 * parin(p);
            p *= 2.01;

            f += 0.25 * parin(p);
            p *= 2.02;

            f += 0.125 * parin(p);
            p *= 2.03;

            f += 0.0625 * parin(p);
            p *= 2.01;

            return f;
        }

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = fBm(IN.uv_MainTex);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
