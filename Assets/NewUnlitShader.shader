Shader "Unlit/NewUnlitShader"
{
    Properties
{
    _MainTex ("Main Texture", 2D) = "white" {}
    _Color ("Tint Color", Color) = (1,0,0,0.3)
}

SubShader
{
    Tags { "Queue" = "Transparent" }

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
            UNITY_FOG_COORDS(1)
            float4 vertex : SV_POSITION;
        };

        sampler2D _MainTex;
        float4 _MainTex_ST;
        float4 _Color;

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            UNITY_TRANSFER_FOG(o, o.vertex);
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            // テクスチャの色を取得
            fixed4 tex = tex2D(_MainTex, i.uv);

            // カラーで乗算（任意の色調整＋アルファ調整も可）
            tex *= _Color;

            return tex;
        }
        ENDCG
    }
}
}
