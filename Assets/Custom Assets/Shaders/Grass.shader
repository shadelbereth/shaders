Shader "Custom/Grass" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		[NoScaleOffset] _BumpTex ("Normal texture", 2D) = "bump" {}
		_BumpScale ("Normal intensity", Range(0,2)) = 1
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_AlphaCuttOff("Alpha cutt off", Range(0,1)) = 0.5
		_WindTex("Wind normal map", 2D) = "bump" {}
		_WindIntensity("Wind intensity", Range(-0.2,0.2)) = 0.1
		_WindSpeed("Wind speed", Range(-1,1)) = 0.1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		Cull Off
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows addshadow vertex*:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _BumpTex;
		sampler2D _WindTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_WindTex;
			float4 color : COLOR;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		float _AlphaCuttOff;
		half _BumpScale;
		half _WindIntensity;
		half _WindSpeed;

		void vert (appdata_full v) {
			// float3 offset = UnpackNormal(tex2D(_WindTex, float4(v.)));
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color * IN.color;
			float normal = UnpackScaleNormal(tex2D(_BumpTex, IN.uv_MainTex), _BumpScale);
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			clip(c.a - _AlphaCuttOff);
			o.Alpha = c.a;
			o.Normal = normal;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
