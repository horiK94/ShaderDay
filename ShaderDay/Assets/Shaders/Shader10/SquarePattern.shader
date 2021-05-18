Shader "Shader10/SquarePattern"
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
                // fixed2 leftUp = step(0.2, i.uv);
                // fixed2 rightDown = step(0.2, 1 - i.uv);
                // return leftUp.x * leftUp.y * rightDown.x * rightDown.y;

                fixed2 squareSize = fixed2(0.8, 0.6);
                fixed2 leftDownPos = fixed2(0.5, 0.5) - squareSize * 0.5;
                fixed2 uv = step(leftDownPos, i.uv);
                // uv *= (1 - step(1 - leftDownPos, i.uv));
                uv *= step(leftDownPos, 1 - i.uv);
                return uv.x * uv.y;
            }
            ENDCG
        }
    }
}