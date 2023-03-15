shader_type canvas_item;

// Controlled from GDscript
uniform bool mouse_pressed = false;
uniform vec2 mouse_position = vec2(0., 0.);
uniform bool random = false;
uniform float random_fill = .1;
uniform bool paused = false;
uniform bool clear = false;

uniform int survival_rules = 12; // bitwise
uniform int birth_rules = 8;
// zone 1 will have creeping ivy for now
uniform int survival_rules2 = 60; // bitwise
uniform int birth_rules2 = 8;

/**
 * procedural white noise
 */
highp float rand(vec2 co)
{
    highp float a = 12.9898;
    highp float b = 78.233;
    highp float c = 43758.5453;
    highp float dt= dot(co.xy ,vec2(a,b));
    highp float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}

bool isAlive(vec4 cc) {
    return max(cc.r, max(cc.g, cc.b)) > 0. ? true : false;
}

/**
 * Given the current cells color
 * and the count of alive neighbors, return the next color
 */
vec4 getColor(vec4 cc, int count, float time, int sr, int br) {
    int bit = 1;
    bool survives = false;
    bool isBorn = false;
    for (int i = 0; i <= 8; i++) {
        survives = survives || ((count == i) && ((sr & bit) != 0));
        isBorn = isBorn || ((count == i) && ((br & bit) != 0));
        bit = bit << 1;
    }

    if (isAlive(cc) && survives){
        return cc;
    }
    else if (!isAlive(cc) && isBorn) {
        return vec4(sin(time), cos(time), 1.0, 1.0);
    }

    return vec4(0.0, 0.0, 0.0, 1.0);
}

// For all other cases the cells are dead

/**
 * Returns the surrounding living cell count of a given UV
 */
int neighborsCount(in sampler2D tex, vec2 uv, vec2 s) {
    float not_current;
    float neighbours = 0.;
  
    for (float x = -1.; x < 2.; x++) {
        for (float y = -1.; y < 2.; y++) {
            // We don't want to add our current square
            // this will equal zero only when we have x=0 & y=0
            if(min(1., abs(x) + abs(y)) == 0.) continue;
            // Add any neighbours x value (we could also use y or z)
            vec2 nv = uv + vec2(x, y) * s;
            if (isAlive(texture(tex, nv)))
                neighbours += 1.;
        }
    }

    return int(neighbours);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 sz = SCREEN_PIXEL_SIZE;

    // How many alive cells do we have around the current cell?
    int count = neighborsCount(TEXTURE, uv, sz);

    // How far away from the mouse is the current position
    vec2 distance_to_mouse = (uv / sz) - mouse_position; 
    vec2 curr = uv/sz;

    COLOR = texture(TEXTURE, uv);
    
    int sr, br;
    if (!paused){
        if ( length( curr - vec2(200., 200.)) < 75.0) {
            sr = survival_rules2;
            br = birth_rules2;
        } else {
            sr = survival_rules;
            br = birth_rules;
        }
        COLOR = getColor(texture(TEXTURE, uv), count, 1.0, sr, br);
    }
    
    if (random){
        float col = rand(mouse_position * uv);
        if (col < random_fill) col = 1.0;
        else col = 0.;

        COLOR = vec4(col, col, col, 1.0);
    }
    
    if(clear){
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    }

    // Mouse input drawing
    if (mouse_pressed && length(distance_to_mouse) <= 5.) {
        // Apply some random spread to the mouse circle
        float col = rand(abs(distance_to_mouse) * uv);
        // Turn on pixels if value is > .5
        col = smoothstep(0.5, 0.51, col);
        COLOR = vec4(col, col, col, 1.0);
    }
}
