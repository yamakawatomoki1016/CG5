Shader "Unlit/09"
{
   Properties
{
    _MainTex ("Texture", 2D) = "white" {}
    _SubTex ("Sub Texture", 2D) = "black" {}
    _MainParallax ("MainParallax Scale", Range(0, 1)) = 0.05
    _SubParallax  ("SubParallax Scale",  Range(0, 1)) = 0.05
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

        #include "UnityCG.cginc"

        struct appdata
        {
            float4 vertex : POSITION;
            float2 uv : TEXCOORD0;
            float3 normal : NORMAL;
            float4 tangent : TANGENT;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float2 uv : TEXCOORD0;
            float3 viewDirTS : TEXCOORD1;
        };

        sampler2D _MainTex;
        sampler2D _SubTex;

        float4 _MainTex_ST;
        float4 _SubTex_ST;

        float _MainParallax;
        float _SubParallax;

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;

            float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            float3 viewDirWS = _WorldSpaceCameraPos.xyz - worldPos;

            float3 t = normalize(mul((float3x3)unity_ObjectToWorld, v.tangent.xyz));
            float3 n = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
            float3 b = cross(n, t) * v.tangent.w;

            float3x3 matTBN = float3x3(t, b, n);
            o.viewDirTS = mul(matTBN, viewDirWS);

            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            float2 mainOffset = i.viewDirTS.xy * _MainParallax;
            float2 subOffset  = i.viewDirTS.xy * _SubParallax;

            float2 mainUV = i.uv * _MainTex_ST.xy + _MainTex_ST.zw + mainOffset;
            float2 subUV  = i.uv * _SubTex_ST.xy  + _SubTex_ST.zw  + subOffset;

            fixed4 mainColor = tex2D(_MainTex, mainUV);
            fixed4 subColor  = tex2D(_SubTex, subUV);

            return lerp(mainColor, subColor, subColor.a);
        }
        ENDCG
    }
}
}
