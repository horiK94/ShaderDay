Shader "Custom/StainedGlass"
{
    Properties
    {
        _MainTex("main texture", 2D) = "white"{}
    }
    SubShader
    {
        Tags { "RenderType"="Tranparent" "Queue" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha:fade

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
            fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = color;
            float gray_scale = 0.3 * color.r + 0.6 * color.g + 0.1 * color.b;
            o.Alpha = 1 - step(0.2, gray_scale) * 0.2;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
