Shader "Unlit/Ice"
{
    Properties
    {
        _MainColor("main color", Color) = (0, 0, 0, 0)
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue" = "Transparent"
        }
        
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 vertexWorld : TEXCOORD0;
                float3 normal : TEXCOORD1;
            };

            float4 _MainColor;
            float _Alpha;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.vertexWorld = UnityObjectToWorldDir(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 normal = normalize(i.normal);
                fixed3 viewDir = normalize(_WorldSpaceCameraPos - i.vertexWorld);
                float alpha = 1 - saturate(dot(normal, viewDir));

                return fixed4(_MainColor.xyz, _MainColor.w * alpha * 1.5);
            }
            ENDCG
        }
    }
}
