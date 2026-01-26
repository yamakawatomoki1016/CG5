Shader "Custom/02_02"
{
   Properties
{
    _Color("Color", Color) = (1,1,1,1)
    _DiffuseThreshold("DiffuseThreshold", Range(0, 1)) = 0
    _DiffuseThresholdWidth("DiffuseThresholdWidth", Range(0, 0.1)) = 0
    _SpecularThreshold("SpecularThreshold", Range(0, 1)) = 0
    _SpecularThresholdWidth("SpecularThresholdWidth", Range(0, 0.1)) = 0
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
            float4 vertex : POSITION;
            float3 normal : NORMAL;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float3 normal : NORMAL;
            float3 worldPosition : TEXCOORD1;
        };

        fixed4 _Color;
        float _DiffuseThreshold;
        float _DiffuseThresholdWidth;
        float _SpecularThreshold;
        float _SpecularThresholdWidth;

        v2f vert(appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.normal = UnityObjectToWorldNormal(v.normal);
            o.worldPosition = mul(unity_ObjectToWorld, v.vertex);
            return o;
        }

        fixed4 frag(v2f i) : SV_Target
        {
            fixed4 ambient = _Color * 0.1;

            float intensity = saturate(dot(normalize(i.normal), _WorldSpaceLightPos0));
            intensity = smoothstep(_DiffuseThreshold, _DiffuseThreshold + _DiffuseThresholdWidth, intensity);
            fixed4 diffuse = _Color * intensity * _LightColor0;

            float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition);
            float3 lightDir = normalize(_WorldSpaceLightPos0);
            i.normal = normalize(i.normal);
            float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal, lightDir);
            float reflection = pow(saturate(dot(reflectDir, eyeDir)), 20);
            reflection = smoothstep(_SpecularThreshold, _SpecularThreshold + _SpecularThresholdWidth, reflection);
            fixed4 specular = _LightColor0 * reflection;

            return ambient + diffuse + specular;
        }
        ENDCG
    }
}
}
