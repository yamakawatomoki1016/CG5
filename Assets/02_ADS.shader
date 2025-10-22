Shader "Unlit/02_ADS"
{
    Properties
    {
        _BaseColor("Base Color", Color) = (1, 0, 0, 1)         // �ԐF
        _LightDir("Light Direction", Vector) = (0, 1, -1, 0)    // ���̌���
        _LightColor("Light Color", Color) = (1, 1, 1, 1)        // ���̐F�i���j
        _AmbientColor("Ambient Color", Color) = (0.1, 0.1, 0.1, 1) // �����i�Â߁j
        _SpecColor("Specular Color", Color) = (1, 1, 1, 1)      // �n�C���C�g�̐F
        _SpecPower("Specular Power", Range(1, 100)) = 30        // �n�C���C�g�̉s��
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
                float4 pos : SV_POSITION;
                float3 worldPos : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
            };

            float4 _BaseColor;
            float4 _LightDir;
            float4 _LightColor;
            float4 _AmbientColor;
            float4 _SpecColor;
            float _SpecPower;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 N = normalize(i.worldNormal);
                float3 L = normalize(_LightDir.xyz);
                float3 V = normalize(_WorldSpaceCameraPos.xyz - i.worldPos);
                float3 R = reflect(-L, N);

                // �����iambient�j
                float3 ambient = _AmbientColor.rgb;

                // �g�U���ˁidiffuse�j
                float diff = max(dot(N, L), 0.0);
                float3 diffuse = diff * _LightColor.rgb;

                // ���ʔ��ˁispecular�j
                float spec = pow(saturate(dot(R, V)), _SpecPower);
                float3 specular = spec * _SpecColor.rgb * 4;

                // ADS����
                float3 ads = ambient + diffuse + specular;
                float3 finalColor = _BaseColor.rgb * ads * 1.5;

                return float4(finalColor, 1.0);
            }
            ENDCG
        }
    }
}
