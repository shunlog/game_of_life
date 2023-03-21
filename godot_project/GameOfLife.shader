shader_type canvas_item;

// Controlled from GDscript
uniform bool mouse_pressed = false;
uniform vec2 mouse_position = vec2(0., 0.);
uniform bool random = false;
uniform float random_fill = .1;
uniform bool paused = false;
uniform bool clear = false;
uniform sampler2D bitmap;

uniform int survival_rules = 12; // bitwise
uniform int birth_rules = 8;
// zone 1 will have creeping ivy for now
uniform int survival_rules2 = 60; // bitwise
uniform int birth_rules2 = 8;

uniform vec4 color_alive0 = vec4(1.0, .0, .0, 1.);
uniform vec4 color_alive1 = vec4(.0, 1.0, .0, 1.);
uniform vec4 color_dead0 = vec4(.0, .0, .0, 1.);
uniform vec4 color_dead1 = vec4(.0, .0, .0, 1.);

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
    return (max(max(abs(cur.r - color_alive0.r),
                    abs(cur.g - color_alive0.g)),
                abs(cur.b - color_alive0.b)) < 0.01)
        || (max(max(abs(cur.r - color_alive1.r),
                    abs(cur.g - color_alive1.g)),
                abs(cur.b - color_alive1.b)) < 0.01);
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
        sr = survival_rules2;
        br = birth_rules2;
        color_alive = color_alive1;
        color_dead = color_dead1;
    } else {
        sr = survival_rules;
        br = birth_rules;
        color_alive = color_alive0;
        color_dead = color_dead0;
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
