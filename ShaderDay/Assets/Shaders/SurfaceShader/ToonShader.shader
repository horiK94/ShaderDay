Shader "Custom/ToonShader"
{
    Properties
    {
        _MainTex("main texture", 2D) = "white"{}
        _RampTex("ramp texture", 2D) = "White"{}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        //カスタムライティングをした場合は最初のLightingを覗いた部分の名前を指定する必要がある
        #pragma surface surf Toon

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        sampler2D _MainTex;
        sampler2D _RampTex;

        //カスタムライティングモデル
        //Lighting<Name> とする必要があり、指定した<Name>をsurfaceシェーダーの設定時に指定する必要がある
        fixed4 LightingToon (SurfaceOutput s, fixed3 lightDir, fixed atten)
        {
            fixed4 c;

            //ライトの向きとnormalが逆なら0, 同じなら1になるように補正
            fixed diffuse_correction = dot(s.Normal, lightDir)*0.5 + 0.5;
            //0 ~ 1に補正した状態でランプテクスチャの影の色を取得
            fixed3 ramp = tex2D(_RampTex, diffuse_correction).rgb;

            //ライトにより決まる色の決定
            //_LightColor0: ライトの色
            //今回はspecularを考慮しない. 完全に拡散反射光のみのライト考慮
            //最後にdiffuse_correctionをかけているが、これを単純に内積にすると、半分真っ黒になってしまうため
            c.rgb = s.Albedo * _LightColor0 * ramp * diffuse_correction;
            c.a = s.Alpha;
            return c;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            o.Albedo = tex2D(_MainTex, IN.uv_MainTex);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
