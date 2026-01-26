Shader "Unlit/08"
{
    Properties
{
    _NormalTex ("Normal Map", 2D) = "bump" {}
    _Color ("Color", Color) = (1,1,1,1)
}

SubShader
{
    Pass
    {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        #include "UnityCG.cginc"
        #include "Lighting.cginc"

        struct appdata
        {
            float4 vertex  : POSITION;
            float3 normal  : NORMAL;
            float4 tangent : TANGENT;
            float2 uv      : TEXCOORD0;
        };

        struct v2f
        {
            float4 pos      : SV_POSITION;
            float2 uv       : TEXCOORD0;
            float3 normal   : TEXCOORD1;
            float3 tangent  : TEXCOORD2;
            float3 binormal : TEXCOORD3;
        };

        sampler2D _NormalTex;
        float4 _NormalTex_ST;
        fixed4 _Color;

        v2f vert (appdata v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = TRANSFORM_TEX(v.uv, _NormalTex);

            o.normal = normalize(v.normal);
            o.tangent = normalize(v.tangent.xyz);
            o.binormal = normalize(cross(o.normal, o.tangent) * v.tangent.w * unity_WorldTransformParams.w);

            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            float3 nMap = tex2D(_NormalTex, i.uv).xyz * 2 - 1;
            nMap = normalize(nMap);

            float3 T = normalize(i.tangent);
            float3 B = normalize(i.binormal);
            float3 N = normalize(i.normal);

            float3 localNormal = normalize(T * nMap.x + B * nMap.y + N * nMap.z);

            float3 worldNormal = UnityObjectToWorldNormal(localNormal);

            float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

            float diff = saturate(dot(worldNormal, lightDir));

            fixed3 color = _LightColor0.rgb * diff * _Color.rgb;

            return fixed4(color, 1.0);
        }
        ENDCG
    }
}
}
