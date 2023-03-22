shader_type canvas_item;

// Controlled from GDscript
uniform bool mouse_pressed = false;
uniform vec2 mouse_position = vec2(0., 0.);
uniform bool random = false;
uniform float random_fill = .1;
uniform bool paused = false;
uniform bool clear = false;
uniform sampler2D bitmap;

uniform int rule0s = 12;
uniform int rule0b = 8;
uniform int rule1s = 60;
uniform int rule1b = 8;

uniform vec4 color0a = vec4(1.0, .0, .0, 1.);
uniform vec4 color1a = vec4(.0, 1.0, .0, 1.);
uniform vec4 color0d = vec4(.0, .0, .0, 1.);
uniform vec4 color1d = vec4(.0, .0, .0, 1.);

highp float rand(vec2 co)
{
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt= dot(co.xy ,vec2(a,b));
    highp float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
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

bool alive(vec4 cur){
    return (max(max(abs(cur.r - color0a.r),
                    abs(cur.g - color0a.g)),
                abs(cur.b - color0a.b)) < 0.01)
        || (max(max(abs(cur.r - color1a.r),
                    abs(cur.g - color1a.g)),
                abs(cur.b - color1a.b)) < 0.01);
}

int neighbors(vec2 uv, sampler2D tex, vec2 sz){
    int cnt = 0;

    for (int dx = -1; dx <= 1; dx++){
        for (int dy = -1; dy <= 1; dy++){
            if(dx == 0 && dy == 0) continue;
            vec2 nv = uv;
            nv.x += float(dx) * sz.x;
            nv.y += float(dy) * sz.y;
            vec4 cur = texture(tex, nv);
            if (alive(cur)){
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
    COLOR = texture(TEXTURE, SCREEN_UV);
    bool alive = alive(texture(TEXTURE, SCREEN_UV));
    int nc = neighbors(SCREEN_UV, TEXTURE, SCREEN_PIXEL_SIZE);
    
    if (!paused){
        int ns = next_state(alive, nc, sr, br);
        if ((ns == 0) || (ns == 1)){
            COLOR = color_alive;
        } else {
            COLOR = color_dead;
        }
    }
    
    if (random){
        float r = rand(mouse_position * SCREEN_UV);
        COLOR = r < random_fill ? color_alive : color_dead;
    }
    
    if(clear){
        COLOR = color_dead;
    }

    if (mouse_pressed && length(distance_to_mouse) <= 5.) {
        float r = rand(abs(distance_to_mouse) * SCREEN_UV);
        COLOR = r < .5 ? color_alive : color_dead;
    }
}
