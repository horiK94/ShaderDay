Shader "Unlit/RainShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size("rain size", Float) = 1
        _T("test time", Float) = 0
        _Distribution("distribution", Range(-5, 5)) = 1
        _Blur("blur", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #define S(a, b, t) smoothstep(a, b, t)

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            //uv分割数
            float _Size;
            //テスト用時間
            float _T;
            //水滴のuvのずらし量
            float _Distribution;
            //くもりガラスブレ量
            float _Blur;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed rand(fixed2 co)
            {
                co = frac(co * float2(123.34, 345.45));
                co += dot(co, co + 34.345);
                return frac(co.x * co.y);
            }

            //(x, y, z): x, y→ tex2Dで参照するuv座標のズレ. z→どの程度曇っているか 
            float3 Layer(float2 UV, float t)
            {
                //アスペクト比は実際の縦横比の逆. つまり、縦:横 = 1:2とする場合は uv座標に(2, 1)をかければ良い
                float2 aspect = fixed2(2, 1);

                float2 uv = UV * _Size * aspect;
                //水滴の落ちる速度に応じて格子も下げる(足していくと(0, 0)基準が下に下がることになる)
                uv.y += .25*t;
                //各格子の真ん中を中心とする
                float2 gv = frac(uv) - .5;

                //格子のIDを設定する
                float2 id = floor(uv);
                float idRand = rand(id);
                //sinのスタートが0~1だけずれることになるとあまり変わらないように見える → 0 ~ 2pi変わるようにする
                t += idRand * 3.141592 * 2;

                //uvのyの値が変わるとxも変わるため、yを固定した時のxの位置の(float drop = S(.05, .03, length(dropPos));による)幅分だけが
                //yを移動した分だけ水滴になる(yは-sin(t+sin(t+sin(t)*.5))*.45;よりt依存なのでどの程度の上下まで水滴が表示されるかは確定する)
                float blur = UV.y * 10;       //10を大きくすると少しのズレで移動量が増えることになるので、水滴が細くなる
                // float blur = t;
                float x = (idRand - .5)*.8;     //-.4 ~ .4
                x += (.4 - abs(x)) * sin(3*blur)*pow(sin(blur), 6)*.45;     
                float y = -sin(t+sin(t+sin(t)*.5))*.45;
                //雫の中心位置はxが-0.5に近いと少し下に、xが0.5に近いと少し上になるため、
                //左下から右上に伸びた円となる(楕円)
                // y += gv.x;
                
                //以下はハートになるのでちょっと微妙
                // y += abs(gv.x);

                //ちょっとだけ左下が軽くとかがった形になる
                //xの値を変えてしまうと左右に歪んでしまう
                // y -= gv.x * gv.x;
                //歪まないようにするにはxの位置だけyのズレを補正する
                y -= (gv.x - x) * (gv.x - x);

                //fixed2(x, y)は雫のgv位置なので、雫と現在のgv位置の差がdropPosとなる
                float2 dropPos = (gv - fixed2(x, y)) / aspect;
                //from > toなので、.05より大きければ0(黒), 0.3より小さければ1. その間は補完される
                //length(gv)だと、aspect比により縦長の円ができるので丸い円にするにはaspect比で割る必要がある
                float drop = S(.05, .03, length(dropPos));

                //雨の軌跡
                //雨は+.25*tすることで格子を下に下げているが、軌跡は下げたくない → gvに対し-.25*tをすれば元の位置にとどまる
                //またxはi.uv.yのときのブレをもとにしているので、ある一定の高さのズレをgvが求めていることになる
                float2 trailPos = (gv - fixed2(x, .25*t)) / aspect;
                // //8つの雨の軌跡を作成する → 上半分しか出ない(理由は、真ん中を(0, 0)としていてfrac()しているため)
                trailPos.y = (frac(trailPos.y * 8)-.5) / 8;
                //軌跡なのでサイズは小さめに
                float trailDrop = S(.03, .01, length(trailPos));

                //dropPosとは、雫と現在のgv位置の差なので、その差が高ければgvは上の位置にあり、低ければ下の位置にあることになる
                //よって、trailDrop = S(-.05, .05, dropPos.y)は現在の雫の位置から上にあれば白、下にあれば黒になる
                //これを軌跡にかけることによって過去の軌跡は明るく、まだ通ってない軌跡ほど暗く表示できる
                float fogTrail = S(-.05, .05, dropPos.y);
                //gv.yが.5より大きければ0. yより小さければ1となる
                //現在の位置gvが「現在の雫の位置(=y)より下の位置なら1、0.5(格子の一番上)に近ければ0に近くなる」ということ
                //ちなみにxに対しyは放物線(y -= (gv.x - x) * (gv.x - x)より)
                fogTrail *= S(.5, y, gv.y);

                // //上のことから、雨の軌跡が現在の雫の位置対して下なら黒、上なら雫に近いほど明るく表示させる
                trailDrop *= fogTrail;

                // dropPosがxに関する距離0になる放物線に対し、左右の0.05より離れたら暗くする
                fogTrail *= S(.05, .04, abs(dropPos.x));

                //colorの出力は今回の関数では行わないのでコメントアウト
                // //これにより、現在の雫に対して下に凸の放物線が引かれる(放物線になるのは y -= (gv.x - x) * (gv.x - x)より)
                // col.rgb += fogTrail *.5;
            
                // //drop: 現在下にある水滴
                // col.rgb += drop;
                // //trailDrop: 水滴の軌跡(8つ)
                // col.rgb += trailDrop;

                //uv座標を水滴のときだけ最大(1, 1)だけずらす. つまり白い部分は濃さだけuv座標をずらす。
                //白と黒の間の色がuv座標が違って見えることになる
                //どれくらいずらすかの_Distributionパラメータを追加することになる
                // float offset = drop + trailDrop;

                //一定方向しかずらせない上の式ではなく、
                //水滴の中心からどの程度ずれているかを求め、それをuv座標をずらす方向とする
                float2 offset = drop * dropPos + trailDrop * trailPos;

                // col *= 0;
                // col.rgb = rand(id);
                //格子を色付けする. 真ん中が(0, 0)で、左下(-0.5, -0.5), 右上(0.5, 0.5)なので上と右を赤くすれば格子ができる
                // if (gv.r > .48 || gv.g > .49)
                // {
                //     col = fixed4(1, 0, 0, 1);
                // }

                return float3(offset, fogTrail);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float t = fmod(_Time.y + _T, 7200);
                float4 col = 0;

                float3 layer = Layer(i.uv, t);
                layer += Layer(i.uv * 1.23+7.54, t *0.9 - 0.5);
                layer += Layer(i.uv * 1.35+1.54, t + sin(t));
                layer += Layer(i.uv * 1.57-7.54, t * 1.1 + 0.23);

                //ブラーの強度を7段階までできるように
                // float blurGlass = _Blur * 7;

                //ブラーによってぼかしたいのは水滴の箇所以外なので 1 - fogTrailをかける
                float blurGlass = _Blur * 7 * (1 - layer.z);

                // col.rgb = tex2D(_MainTex, i.uv + offset * _Distribution);
                //4つめの引数: 0が通常. 1つ上がるごとに1/2倍のミップマップが使用される
                //ミップマップによるボケを使用しながらブラーを表現する
                col.rgb = tex2Dlod(_MainTex, fixed4(i.uv + layer.xy * _Distribution, 0, blurGlass));

                return col;
            }
            ENDCG
        }
    }
}
