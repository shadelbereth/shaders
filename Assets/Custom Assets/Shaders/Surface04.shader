Shader "Custom/Surface04" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
        _SurfaceColor("Surface color", Color) = (1,1,1,1)
        _DeepColor("Deep color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
        _BumpTex("Normal map", 2D) = "bump" {}
        _BumpIntensity("Normal intensity", Range(0,2)) = 1
        _HorinzontalOffset("Horizontal offset", float) = 0
        _VerticalOffset("Vertical offset", float) = 0
        _AnimSpeed("Anim speed", float) = 0
        _AnimAmplitude("Anim amplitude", float) = 0
        _Glossiness("Glossiness", Range(0,1)) = 0.8
        _FresnelPower("Fresnel power", Range(0.01, 50)) = 2
        _RefractionIntensity("Refraction intensity", Range(-200,200)) = 10
        _ZScale("Z scale", float) = 1
        _minDistance("Tessellation min distance", Range(1,20)) = 5
        _maxDistance("Tessellation max distance", Range(20,200)) = 50
        _tessellation("Tessellation level", Range(1,32)) = 5
	}
	SubShader {
		Tags { "RenderType"="Opaque" "Queue"="Transparent" }
		LOD 200

        GrabPass {
            "_BackgroundTexture"
        }
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert tesselate:tessDistance

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 5.0
        #include "Tessellation.cginc"

		sampler2D _MainTex;
        sampler2D _BumpTex;
        sampler2D _BackgroundTexture;
        sampler2D_float _CameraDepthTexture;
        float4 _BackgroundTexture_TexelSize;

		struct Input {
			float2 uv_MainTex;
            float2 uv_BumpTex;
            float4 screenPos;
            float3 viewDir;
            float eyeDepth;
		};

        fixed4 _Color;
        fixed4 _SurfaceColor;
        fixed4 _DeepColor;
        float _HorinzontalOffset;
        float _VerticalOffset;
        float _AnimSpeed;
        float _AnimAmplitude;
        float _Glossiness;
        float _BumpIntensity;
        float _FresnelPower;
        float _RefractionIntensity;
        float _ZScale;
        float _minDistance;
        float _maxDistance;
        float _tessellation;

        float4 tessDistance(appdata_full v0, appdata_full v1, appdata_full v2) {
            return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, _minDistance, _maxDistance, _tessellation);
        }

        void vert (inout appdata_full v, out Input o) {
            float3 worldPosition = mul(unity_ObjectToWorld, v.vertex);
            float offset = sin(_Time.y * _AnimSpeed + worldPosition.x) * sin(_Time.y * _AnimSpeed + worldPosition.z) * _AnimAmplitude;
            v.vertex.xyz += v.normal * offset;
            UNITY_INITIALIZE_OUTPUT(Input, o);
            COMPUTE_EYEDEPTH(o.eyeDepth);
        }

        void surf (Input IN, inout SurfaceOutputStandard o) {
            // Albedo comes from a texture tinted by color
            float rawZ = SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(IN.screenPos));
            float sceneZ = LinearEyeDepth(rawZ);
            float deltaZ = saturate(sceneZ - IN.eyeDepth) * _ZScale;
            float3 normal = UnpackScaleNormal(tex2D (_BumpTex, IN.uv_BumpTex + float2(_HorinzontalOffset, _VerticalOffset) * _Time.y), _BumpIntensity);
            float3 normal2 = UnpackScaleNormal(tex2D (_BumpTex, IN.uv_BumpTex - float2(_HorinzontalOffset * 0.0806, _VerticalOffset * 0.0809) * _Time.y), _BumpIntensity);
            normal = normalize(normal + normal2);
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex + float2(_HorinzontalOffset, _VerticalOffset)) * _Color;
            float2 UVOffset = normal2.xy * _BackgroundTexture_TexelSize.xy * IN.screenPos.z * _RefractionIntensity * deltaZ;
            float2 UVcoord = (IN.screenPos.xy + UVOffset) / IN.screenPos.w;
            float3 refractedColor = tex2D(_BackgroundTexture, UVcoord);
            float fresnel = saturate(1.0f - dot(normal2, normalize(IN.viewDir.xyz)));
            fresnel = pow(fresnel, _FresnelPower);
            o.Albedo = c.rgb * fresnel;
            o.Smoothness = _Glossiness;
            o.Normal = normal;
            o.Emission = refractedColor * lerp(lerp(_SurfaceColor, _Color, saturate(deltaZ * 2)), lerp(_DeepColor, _Color, saturate(deltaZ * 2 - 1)), deltaZ) * (1 - fresnel);
        }
        ENDCG
	}
	FallBack "Diffuse"
}
