Shader "Unlit/NewUnlitShader 3"
{
    Properties
{
    _MaskTex ("Mask Texture", 2D) = "white" {}
    _Dissolve ("Dissolve", Range(0,1)) = 0
}

SubShader
{
    CGINCLUDE
    #pragma vertex vert
    #pragma fragment frag
    #include "UnityCG.cginc"

    struct appdata
    {
        float4 vertex : POSITION;
        float2 uv : TEXCOORD0;
    };

    struct v2f
    {
        float4 vertex : SV_POSITION;
        float2 uv : TEXCOORD0;
    };

    sampler2D _MaskTex;
    float4 _MaskTex_ST;
    float _Dissolve;

    v2f vert(appdata v)
    {
        v2f o;
        o.vertex = UnityObjectToClipPos(v.vertex);
        o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
        return o;
    }
    ENDCG

    Pass
    {
        Tags { "LightMode" = "UniversalForward" }

        Cull front

        CGPROGRAM

        fixed4 frag(v2f i) : SV_Target
        {
            fixed4 mask = tex2D(_MaskTex, i.uv);
            clip(mask.r - _Dissolve);

            return fixed4(0, 1, 1, 1);
        }
        ENDCG
    }

    Pass
    {
        CGPROGRAM

        fixed4 frag(v2f i) : SV_Target
        {
            fixed4 mask = tex2D(_MaskTex, i.uv);
            clip(mask.r - _Dissolve);

            return mask;
        }
        ENDCG
    }
}
}
