Shader "Custom/GrassOnBlock"
{
    Properties
    {
        _GrassAmountTex("grass amount texture", 2D) = "white"{}
        _BlockTex("block texture", 2D) = "white"{}
        _GrassTex("grass texture", 2D) = "white"{}
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

        sampler2D _GrassAmountTex;
        sampler2D _BlockTex;
        sampler2D _GrassTex;

        struct Input
        {
            fixed2 uv_BlockTex;
            fixed2 uv_GrassTex;
            fixed2 uv_GrassAmountTex;
        };

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 blockColor = tex2D(_BlockTex, IN.uv_BlockTex);
            fixed4 grassColor = tex2D(_GrassTex, IN.uv_GrassTex);
            
            fixed4 amount = tex2D(_GrassAmountTex, IN.uv_GrassAmountTex);

            o.Albedo = lerp(blockColor, grassColor, amount);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
