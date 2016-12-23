Shader "Custom/Surface01" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
        _Red ("Red", Color) = (1,0,0,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _logoTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Glossiness2 ("Smoothness2", Range(0,1)) = 1
		_Metallic ("Metallic", Range(0,1)) = 0.0
        _Metallic2 ("Metallic2", Range(0,1)) = 1.0
        _ScrollSpeedX ("Scroll speed X", Range(-1,1)) = 0.1
        _ScrollSpeedY ("Scroll speed Y", Range(-1,1)) = 0.1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
        sampler2D _logoTex;

		struct Input {
			float2 uv_MainTex;
            float2 uv_logoTex;
		};

		half _Glossiness;
        half _Glossiness2;
		half _Metallic;
        half _Metallic2;
		fixed4 _Color;
        fixed4 _Red;
        fixed _ScrollSpeedX;
        fixed _ScrollSpeedY;

		void surf (Input IN, inout SurfaceOutputStandard o) {
            fixed4 logoColor = tex2D(_logoTex, IN.uv_logoTex);
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex + float2(_Time.x * _ScrollSpeedX, _Time.x * _ScrollSpeedY)) * _Color;
            fixed4 red = tex2D (_MainTex, IN.uv_MainTex + float2(_Time.x * _ScrollSpeedX, _Time.x * _ScrollSpeedY)) * _Red;
            c.rgb = lerp(c.rgb, red.rgb, logoColor.a);
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = lerp(_Metallic, _Metallic2, logoColor.a);
			o.Smoothness = lerp(_Glossiness, _Glossiness2, logoColor.a);
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
