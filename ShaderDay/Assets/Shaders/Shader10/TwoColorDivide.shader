Shader "Shader10/TwoDivide"
{
    Properties
    {
        _MainTexture("Main Texture", 2D) = "white"{}
        _ColorA("Color A", Color) = (0, 0, 0, 0)
        _ColorB("Color B", Color) = (0, 0, 0, 0)
    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed4 _ColorA;
            fixed4 _ColorB;

            struct v2f
            {
                fixed4 vertex : SV_POSITION;
                fixed2 uv : TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag(v2f i) : SV_TARGET
            {
                fixed4 colorA = _ColorA;
                fixed4 colorB = _ColorB;
                return lerp(colorA, colorB, step(i.uv.x, 0.2));
            }
            ENDCG
        }
    }
}