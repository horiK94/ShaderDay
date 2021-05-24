Shader "Custom/TextureShader"
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
            //テクスチャ座標はテクスチャ名にuv_をつけるだけで取れる
            fixed2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            //TRANSFORM_TEX()がなくてもTilling, Offsetが考慮される
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex + _Time.y);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
