Shader "Unlit/03_Specular_BlackBase"
{
    Properties
    {
        _LightDir("Light Direction", Vector) = (0, 1, -1, 0)
        _LightColor("Light Color", Color) = (1, 1, 1, 1)
        _SpecPower("Specular Power", Range(1, 100)) = 30
        _BaseColor("Base Color", Color) = (0, 0, 0, 1)
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
                float3 worldNormal : TEXCOORD1;
            };

            float4 _LightDir;
            float4 _LightColor;
            float4 _BaseColor;
            float _SpecPower;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 N = normalize(i.worldNormal);
                float3 L = normalize(_LightDir.xyz);
                float3 V = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
                float3 R = reflect(-L, N);
                float spec = pow(saturate(dot(R, V)), _SpecPower);
                fixed4 specular = spec * _LightColor;
                fixed4 baseColor = _BaseColor;

                return baseColor + specular;
            }
            ENDCG
        }
    }
}
