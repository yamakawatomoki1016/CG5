Shader "Unlit/NewUnlitShader 4"
{
   Properties
 {
     _MaskTex ("Texture", 2D) = "black" {}
 }
 SubShader
 {
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

         sampler2D _MaskTex;
         float4 _MaskTex_ST;

         v2f vert (appdata v)
         {
             v2f o;
             o.vertex = UnityObjectToClipPos(v.vertex);
             o.uv = TRANSFORM_TEX(v.uv, _MaskTex);
             UNITY_TRANSFER_FOG(o,o.vertex);
             return o;
         }

         fixed4 frag (v2f i) : SV_Target
         {
             fixed4 specular = fixed4(pow(0.8, 8), pow(0.8, 8), pow(0.8, 8), 1);
             fixed4 maskColor = tex2D(_MaskTex, i.uv * _MaskTex_ST.xy);
             return maskColor.r * specular;
         }
         ENDCG
     }
 }
}
