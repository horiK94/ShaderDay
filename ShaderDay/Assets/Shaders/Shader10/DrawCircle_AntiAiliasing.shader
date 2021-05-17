Shader "Shader10/DrawCircle_AntiAiliasing"
{
    Properties
    {
        _MainTexture("Main Texture", 2D) = "white"{}
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
                fixed r = 0.3;

                fixed d = distance(i.uv, fixed2(0.5, 0.5));

                //smoothstep(a, b, x): x < a → 0, x > b → 1, a <= x <= b → 0 ~ 1で補完
                return smoothstep(r, r + 0.02, d);
            }
            ENDCG
        }
    }
}