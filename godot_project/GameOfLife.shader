shader_type canvas_item;

// Controlled from GDscript
uniform bool mouse_pressed = false;
uniform vec2 mouse_position = vec2(0., 0.);
uniform int pen_type = 1;
uniform int pen_size = 1;
uniform float pen_randomness = .5;

uniform bool random = false;
uniform float random_fill = .1;
uniform bool paused = false;
uniform bool clear = false;
uniform sampler2D bitmap;

uniform int rule0s = 12;
uniform int rule0b = 8;
uniform int rule1s = 60;
uniform int rule1b = 8;

// zone 1 colors
uniform vec4 color0a = vec4(1.0, .0, .0, 1.);
uniform vec4 color1a = vec4(.0, 1.0, .0, 1.);
// zone 2 colors
uniform vec4 color0d = vec4(.0, .0, .0, 1.);
uniform vec4 color1d = vec4(.0, .0, .0, 1.);
// infected cells color
uniform vec4 color2 = vec4(.99, .0, .5, 1.);

// infection spread probability
uniform float isp = .5;


highp float rand(vec2 co)
{
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt= dot(co.xy ,vec2(a,b));
    highp float sn= mod(dt,3.14);
    return fract(sin(sn) * c * TIME);
}

/**
 * Given the current cells state,
 * the count of alive neighbors,
 * and the survival and birth rules,
 * return the next state
 */
int next_state(bool alive, int nc, int sr, int br) {
    int bit = 1;
    bool survives = false;
    bool is_born = false;

    for (int i = 0; i <= 8; i++) {
        survives = survives || ((nc == i) && ((sr & bit) != 0));
        is_born = is_born || ((nc == i) && ((br & bit) != 0));
        bit = bit << 1;
    }

    if (alive && survives){
        return 0;
    }

    if (!alive && is_born) {
        return 1;
    }

    return 2;
}

bool alive(vec4 col){
    return (max(max(abs(col.r - color0a.r),
                    abs(col.g - color0a.g)),
                abs(col.b - color0a.b)) < 0.01)
        || (max(max(abs(col.r - color1a.r),
                    abs(col.g - color1a.g)),
                abs(col.b - color1a.b)) < 0.01)
		|| (max(max(abs(col.r - color2.r),
                    abs(col.g - color2.g)),
                abs(col.b - color2.b)) < 0.01);
}

bool infected(vec4 col){
	return (max(max(abs(col.r - color2.r),
                    abs(col.g - color2.g)),
                abs(col.b - color2.b)) < 0.01);
}

bool infected_neighbors(vec2 uv, vec2 sz, sampler2D tex){
	bool inf = false;
	for (int dx = -1; dx <= 1; dx++){
        for (int dy = -1; dy <= 1; dy++){
            if(dx == 0 && dy == 0) continue;
            vec2 nv = uv;
            nv.x += float(dx) * sz.x;
            nv.y += float(dy) * sz.y;
            if (infected(texture(tex, nv))){
                inf = inf || (rand(uv) < isp);
            }
        }
    }
	return inf;
}

int neighbors(vec2 uv, sampler2D tex, vec2 sz){
    int cnt = 0;

    for (int dx = -1; dx <= 1; dx++){
        for (int dy = -1; dy <= 1; dy++){
            if(dx == 0 && dy == 0) continue;
            vec2 nv = uv;
            nv.x += float(dx) * sz.x;
            nv.y += float(dy) * sz.y;
            vec4 col = texture(tex, nv);
            if (alive(col)){
                cnt += 1;
            }
        }
    }

    return cnt;
}

void fragment() {
    int sr, br;
    vec4 color_alive, color_dead;

    if (texture(bitmap, SCREEN_UV).rgb == vec3(.0, .0, .0)){
        sr = rule1s;
        br = rule1b;
        color_alive = color1a;
        color_dead = color1d;
    } else {
        sr = rule0s;
        br = rule0b;
        color_alive = color0a;
        color_dead = color0d;
    }

    vec2 distance_to_mouse = (SCREEN_UV / SCREEN_PIXEL_SIZE) - mouse_position;
	vec4 col = texture(TEXTURE, SCREEN_UV);
    COLOR = col;
	
    bool alive = alive(col);
    int nc = neighbors(SCREEN_UV, TEXTURE, SCREEN_PIXEL_SIZE);
    
    if (!paused){
        int ns = next_state(alive, nc, sr, br);
        if ((ns == 0) || (ns == 1)){
			if (infected(col) || infected_neighbors(SCREEN_UV, SCREEN_PIXEL_SIZE, TEXTURE)){
            	COLOR = color2;
			} else {
            	COLOR = color_alive;
			}
        } else {
            COLOR = color_dead;
        }
    }
    
    if (random){
        float r = rand(SCREEN_UV);
        COLOR = r < random_fill ? color_alive : color_dead;
    }
    
    if(clear){
        COLOR = color_dead;
    }

    if (mouse_pressed && length(distance_to_mouse) <= float(pen_size) / 2.) {
		vec4 c;
		if (pen_type == 2){
			c = color2;
		} else if (pen_type == 1){
			c = color_alive;
		} else {
			c = color_dead;
		}
        float r = rand(SCREEN_UV);
		if (r < pen_randomness)
        	COLOR = c;
    }
}
