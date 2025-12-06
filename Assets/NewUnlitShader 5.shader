Shader "Unlit/NewUnlitShader 5"
{
    Properties
{
    _MainTex ("Texture", 2D) = "white" {}
    _SubTex ("SubTexture", 2D) = "white" {}
    _MaskTex ("MaskTexture", 2D) = "black" {}
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
        sampler2D _SubTex;
        sampler2D _MaskTex;
        float4 _MainTex_ST;

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _MainTex);
            UNITY_TRANSFER_FOG(o,o.vertex);
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            fixed4 main = tex2D(_MainTex, i.uv);
            fixed4 sub = tex2D(_SubTex, i.uv);
            fixed4 mask = tex2D(_MaskTex, i.uv);
            fixed4 col = lerp(sub, main, mask.r);
            return col;
        }
        ENDCG
    }
}
}
