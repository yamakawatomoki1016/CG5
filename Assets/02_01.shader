Shader "Custom/02_01"
{
   Properties
{
    _MainTex ("Texture", 2D) = "white" {}
    _Color ("Main Color", Color) = (1,1,1,1)
}
SubShader
{
    Pass
    {
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag
        #pragma multi_compile_fog

        #include "UnityCG.cginc"
        #include "Lighting.cginc"

        struct appdata
        {
            float4 vertex : POSITION;
            float3 normal : NORMAL;
            float2 uv : TEXCOORD0;
        };

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float3 normal : NORMAL;
            float3 worldPosition : TEXCOORD1;
            float2 uv : TEXCOORD0;
        };

        sampler2D _MainTex;
        float4 _MainTex_ST;
        fixed4 _Color;

        v2f vert (appdata v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.uv;
            o.normal = UnityObjectToWorldNormal(v.normal);
            o.worldPosition = mul(unity_ObjectToWorld, v.vertex).xyz;
            return o;
        }

        fixed4 frag (v2f i) : SV_Target
        {
            // テクスチャ処理
            float2 tiling = _MainTex_ST.xy;
            float2 offset = _MainTex_ST.zw;
            fixed4 col = tex2D(_MainTex, i.uv * tiling + offset);

            float3 lightDir = normalize(_WorldSpaceLightPos0);
            
            float3 N = normalize(i.normal);
            float3 eyeDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPosition.xyz);

            // 反射処理
            fixed4 ambient = _Color * 0.3;
            float intensity = saturate(dot(N, lightDir));
            fixed4 diffuse = _Color * intensity * _LightColor0;

            float3 reflectDir = -lightDir + 2 * i.normal * dot(i.normal,lightDir);
            fixed4 specular = pow(saturate(dot(reflectDir, eyeDir)), 20) * _LightColor0;

            fixed4 phong = ambient + diffuse + specular;

            col *= phong;

            return col;
        }
        ENDCG
    }
}
}
