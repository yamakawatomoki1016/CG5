Shader "Unlit/NewUnlitShader 4_Specular"
{
    Properties
    {
        _MaskTex ("Texture", 2D) = "black" {}
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Shininess ("Shininess", Range(1,128)) = 16
    }

    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MaskTex;
            float4 _MaskTex_ST;
            float4 _SpecColor;
            float _Shininess;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // マスクテクスチャ
                fixed4 maskColor = tex2D(_MaskTex, i.uv);

                // --- 簡易スペキュラ計算 ---
                // 法線（Z方向固定）
                float3 N = float3(0,0,1);
                // 光方向（上方向）
                float3 L = normalize(float3(0,1,1));
                // カメラ方向（正面）
                float3 V = normalize(float3(0,0,1));

                // 反射ベクトル
                float3 R = reflect(-L, N);

                // スペキュラ強度
                float spec = pow(max(dot(R, V), 0.0), _Shininess);

                // マスクの明度にスペキュラを掛ける
                fixed3 finalColor = maskColor.rgb + spec * _SpecColor.rgb;

                return fixed4(finalColor, maskColor.a);
            }

            ENDCG
        }
    }
}
