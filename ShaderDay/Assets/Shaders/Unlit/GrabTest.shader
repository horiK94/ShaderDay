Shader "Unlit/GrabTest"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Transform" "Queue"="Transparent" }
        LOD 100

        GrabPass{ "_GrabTexture" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex, _GrabTexture;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                //ComputeGrabScreenPos: ワールド座標をクリップ座標(-w ~ wもしくは0 ~ wに変換する)
                //UNITY_PROJ_COORD: 基本引数の値をそのまま返す(PS vitaのときは変換されるらしい)
                o.uv = UNITY_PROJ_COORD(ComputeGrabScreenPos(o.vertex));
                //最終的に、xyzを正規化デバイス系の-1 ~ 1の値に変換すればよく、
                //そのためにwで乗算する必要がある

                //Q. 通常のuv座標はwで乗算してなくない？
                //A. 普通はGPUが自動で行っているため気にする必要がない
                //今回のように深度値を利用したい等でクリップ座標を出力したときはwで割る必要がある
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                // i.uv.xy(-w ~ w)を正規化デバイス系の-1 ~ 1の値に変換
                fixed4 col = tex2D(_GrabTexture, i.uv.xy / i.uv.w);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
