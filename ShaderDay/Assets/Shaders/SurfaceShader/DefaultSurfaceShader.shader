Shader "Custom/DefaultSurfaceShader"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows

        //なくても動くけどあったほうがいいらしい
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float dummy : TEXCOORD0;
        };
        
        fixed4 _Color;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            o.Albedo = _Color;
        }
        ENDCG
    }
}
