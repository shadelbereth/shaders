Shader "Custom/CameraDistortion"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_DistortionPower("Distortion power", Range(0,2)) = 1
		_Zoom("Zoom", Range(0.5, 1.5)) = 1
		_Aberration("Aberration", Range(-0.1, 0.1)) = 0.01
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
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _DistortionPower;
			float _Zoom;
			float _Aberration;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				float2 uvCoordUnit = i.uv * 2 - 1;
				float distance = length(uvCoordUnit);
				distance = lerp(sin(distance), distance, _DistortionPower);
				distance *= _Zoom;
				float2 distortionUV = normalized(uvCoordUnitv) * distance;
				fixed4 col = tex2D(_MainTex, (distortionUV + 1) / 2);
				return col;
			}
			ENDCG
		}
	}
}
