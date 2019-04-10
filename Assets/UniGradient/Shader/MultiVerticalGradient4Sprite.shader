// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "UniGradient/MultiVerticalGradient4Sprite"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _ColorCount ("Number of Colors", float) = 2
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
		}

		Cull Off
		Lighting Off
		ZWrite Off
		
		Pass
		{
			// 开启透明通过融合模式
			Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0
			#pragma multi_compile _ PIXELSNAP_ON
			#pragma multi_compile _ ETC1_EXTERNAL_ALPHA
			#include "UnityCG.cginc"
			
			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				UNITY_VERTEX_OUTPUT_STEREO
			};
			
            float _ColorCount;
            fixed4 _Colors[5];
            float _Positions[5];

			v2f vert(appdata_t IN)
			{
				v2f OUT;
				UNITY_SETUP_INSTANCE_ID(IN);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				return OUT;
			}

            fixed4 sampleGradientColor(fixed4 colors [5], float positions [5], int count, float t) 
            {
                for (int p = 0; p < count; p++) {

                    if (t <= positions [p]) {

                        if (p == 0) {

                            return colors [0];

                        } else {

                            return lerp(colors [p - 1], colors [p], (t - positions [p - 1]) / (positions [p] - positions [p - 1]));
                        }

                    } else if (p == count - 1) {

                        return colors [p];
                    }
                }

                return (0,0,0,0);
            }


			fixed4 frag(v2f IN) : SV_Target
			{
                return sampleGradientColor(_Colors, _Positions, _ColorCount, IN.texcoord.y);
			}
		ENDCG
		}
	}
}
