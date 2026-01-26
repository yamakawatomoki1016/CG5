Shader "Custom/02_03"
{
    Properties
{
    _Color("Color", Color) = (1,0,0,1)
    _RimPower("Rim Power", Range(0.1, 8)) = 2.0
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
            float3 normal : NORMAL;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float3 worldPos : TEXCOORD0;
            float3 normal : TEXCOORD1;
        };

        fixed4 _Color;
        float _RimPower;

        v2f vert(appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.normal = UnityObjectToWorldNormal(v.normal);
            o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
            return o;
        }

        fixed4 frag(v2f i) : SV_Target
        {
            float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
            float rim = pow(1.0 - saturate(dot(i.normal, viewDir)), _RimPower);
            fixed3 color = _Color.rgb * 0.3 + rim * _Color.rgb;
            return fixed4(color, 1);
        }
        ENDCG
    }
}
}
