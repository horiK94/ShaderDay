Shader "Custom/LavaLamp"
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
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed2 a = IN.uv_MainTex * 5;
            a.y -= _Time.g;
            fixed2 f = frac(a);
            a -= f;
            f = f*f*(3 - 2*f);
            fixed4 r = frac(sin(a.x + a.y * 1000 + fixed4(0, 1, 1000, 1001)) * 100000) * 30.0 / IN.uv_MainTex.y;
            o.Albedo =  IN.uv_MainTex.y + fixed3(1, 0.5, 0.2) * clamp(lerp(lerp(r.x, r.y, f.x), lerp(r.z, r.w, f.x), f.y) - 30, -0.2, 1);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
