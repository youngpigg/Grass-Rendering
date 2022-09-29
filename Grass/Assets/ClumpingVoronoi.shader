Shader "Hidden/ClumpingVoronoi"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

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



            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

            float2 N22(float2 p){
            
                float3 a = frac(p.xyx*float3(123.34,234.34,345.65));
                a += dot(a, a+34.45);
                return frac(float2(a.x*a.y,a.y*a.z));
            
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //fixed4 col = tex2D(_MainTex, i.uv);
                // just invert the colors
                //col.rgb = 1 - col.rgb;

                //fixed4 col = fixed4(i.uv, 0 , 1);

                //float2 rand = N22(i.uv);

                float pointsMask = 0;
                //float2 x;

                float radius = 0.01;
                float falloff = 0.01;

                float minDist = 1000;

                float id;

                for (int j =0; j < 20; j++){
                    float2 jj = float2(j,j);
                    float2 p =  N22(jj);
                    //point = N22(p);
                    
                    float d = distance(p, i.uv);

                    //float s = smoothstep(radius+ falloff,radius,d);

                    //pointsMask += s;

                    if (d<minDist){
                    
                        minDist = d;
                        id = j;
                    }

                }

                id = id/20;

                float3 col = float3(id.xxx);

                //fixed4 col = fixed4(rand,0,1);

                return fixed4(col,1);
            }
            ENDCG
        }
    }
}
