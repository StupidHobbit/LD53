shader_type spatial;

const int MAX_OCTAVE = 8;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;


float cosineInterpolate(float a, float b, float x) {
	float ft = x * PI;
	float f = (1.0 - cos(ft)) * 0.5;
	
	return a*(1.0-f) + b*f;
}

float random (in vec2 _st) {
    return fract(sin(dot(_st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}

float seededRandom(float seed) {
    int x = int(seed);
    x = x << 13 ^ x;
    x = (x * (x * x * 15731 + 789221) + 1376312589);
    x = x & 0x7fffffff;
    return float(x)/1073741824.0;
}

float perlinNoise(float x_arg, float y_arg, float time_arg) {
    float sum = 0.0;
    for (int octave=0; octave<MAX_OCTAVE; ++octave) {
        float sf = pow(2.0, float(octave));
        float x = x_arg*sf;
    	float y = (y_arg*sf) + (1.5*time_arg*log2(sf));
    	float y_scale = 1.0*sf;
        
		float x_floor = floor(x);
		float y_floor = floor(y);
		float fraction_x = x - x_floor;
		float fraction_y = y - y_floor;
        
        float t1 = random( vec2(x_floor	+	y_scale *  y_floor      ));
		float t2 = random( vec2(x_floor	+	y_scale * (y_floor+1.0) ));
        
        x_floor += 1.0;
        float t3 = random( vec2(x_floor	+	y_scale *  y_floor      ));
		float t4 = random( vec2(x_floor	+	y_scale * (y_floor+1.0) ));
        
		float i1 = cosineInterpolate(t1, t2, fraction_y);
		float i2 = cosineInterpolate(t3, t4, fraction_y);
        
        sum += cosineInterpolate(i1, i2, fraction_x)/sf;
    }
    return 2.0*sum;
}



void fragment() {
    vec2 uv = FRAGCOORD.xy / VIEWPORT_SIZE.xy;
    
    float dx = 0.5 - uv.x;
    float dy = 0.5 - uv.y;
    dy *= VIEWPORT_SIZE.y / VIEWPORT_SIZE.x;
    
    float c = perlinNoise(dx, dy, TIME);
    c -= 0.4;
    c *= cos(dx*PI);
    c *= 2. - 2. * ((uv.y/VIEWPORT_SIZE.y)*256.0);
    
    float red = c*0.045;
    float green =  c*(0.95);
   
    vec3 heat = vec3(red,green,0.133);
    ALBEDO = heat + texture(SCREEN_TEXTURE, uv).xyz;
}
