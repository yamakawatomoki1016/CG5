Shader "Unlit/02_ADS"
{
    Properties
    {
        _BaseColor ("Base Color", Color) = (1, 0, 0, 1)  
        _AmbientColor ("Ambient Color", Color) = (0.2, 0.2, 0.2, 1) 
        _LightColor0 ("Light Color", Color) = (1, 1, 1, 1) 
        _Shininess ("Shininess", Range(1, 100)) = 50  
        _LightIntensity ("Light Intensity", Range(0, 5)) = 1.5 
        _SpecIntensity ("Specular Intensity", Range(0, 5)) = 2.0 
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }
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

            fixed4 _BaseColor;
            fixed4 _AmbientColor;
            fixed4 _LightColor0;
            float _Shininess;
            float _LightIntensity;
            float _SpecIntensity;

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.normal = mul((float3x3)unity_ObjectToWorld, v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
            float3 N = normalize(i.normal);
            float3 L = normalize(_WorldSpaceLightPos0.xyz);
            float3 V = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
            float3 R = reflect(-L, N);

            // ä¬ã´åı
            float3 ambient = _AmbientColor.rgb;

            // ägéUåı
            float diff = max(dot(N, L), 0.0);
            float3 diffuse = diff * _LightColor0.rgb * _LightIntensity;

            // ãæñ îΩéÀ
            float spec = pow(max(dot(R, V), 0.0), _Shininess);
            float3 specular = spec * _LightColor0.rgb * _SpecIntensity;

            // ADSçáê¨
            float3 finalColor = _BaseColor.rgb * (ambient + diffuse) + specular;

            return float4(finalColor, 1.0);
            }

            ENDCG
        }
    }
}
