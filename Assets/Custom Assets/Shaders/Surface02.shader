Shader "Custom/Surface02" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _MaskTex ("Mask", 2D) = "white" {}
        _HorinzontalOffset("Horizontal offset", float) = 0
        _VerticalOffset("Vertical offset", float) = 0
        _IntensityBoost("Intensity boost", Range(0, 10)) = 1
        _AnimSpeed("Anim speed", float) = 0
        _AnimAmplitude("Anim amplitude", float) = 0
        _GhostPower("Ghost power", float) = 1
	}
	SubShader {
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
		LOD 200

        Cull Front
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
        sampler2D _MaskTex;

		struct Input {
			float2 uv_MainTex;
            float2 uv_MaskTex;
            float3 viewDir;
		};

        fixed4 _Color;
        float _HorinzontalOffset;
        float _VerticalOffset;
        float _IntensityBoost;
        float _AnimSpeed;
        float _AnimAmplitude;
        float _GhostPower;

        void surf (Input IN, inout SurfaceOutputStandard o) {
            // Albedo comes from a texture tinted by color
            float fresnel = 1 - saturate(dot(o.Normal, normalize(IN.viewDir.xyz)));
            fresnel = pow(fresnel, _GhostPower);
            float mask = tex2D(_MaskTex, IN.uv_MaskTex).g;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + float2(_HorinzontalOffset, _VerticalOffset)) * _Color;
            o.Emission = c.rgb * _IntensityBoost * (1 - fresnel);
            o.Alpha = c.a * mask * (1 - fresnel);
        }

        void vert (inout appdata_full v) {
            float3 worldPosition = mul(unity_ObjectToWorld, v.vertex);
            float offset = sin(_Time.y * _AnimSpeed + worldPosition.x + worldPosition.z) * _AnimAmplitude;
            v.vertex.xyz += v.normal * offset;
        }
        ENDCG

        Cull Back
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha
        
        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha:blend vertex:vert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _MaskTex;

        struct Input {
            float2 uv_MainTex;
            float2 uv_MaskTex;
            float3 viewDir;
        };

        fixed4 _Color;
        float _HorinzontalOffset;
        float _VerticalOffset;
        float _IntensityBoost;
        float _AnimSpeed;
        float _AnimAmplitude;
        float _GhostPower;

        void surf (Input IN, inout SurfaceOutputStandard o) {
            // Albedo comes from a texture tinted by color
            float fresnel = 1 - saturate(dot(o.Normal, normalize(IN.viewDir.xyz)));
            fresnel = pow(fresnel, _GhostPower);
            float mask = tex2D(_MaskTex, IN.uv_MaskTex).g;
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + float2(_HorinzontalOffset, _VerticalOffset)) * _Color;
            o.Emission = c.rgb * _IntensityBoost * (1 - fresnel);
            o.Alpha = c.a * mask * (1 - fresnel);
        }

        void vert (inout appdata_full v) {
            float3 worldPosition = mul(unity_ObjectToWorld, v.vertex);
            float offset = sin(_Time.y * _AnimSpeed + worldPosition.x + worldPosition.z) * _AnimAmplitude;
            v.vertex.xyz += v.normal * offset;
        }
        ENDCG
	}
	FallBack "Diffuse"
}
