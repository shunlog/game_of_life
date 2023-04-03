shader_type spatial;
uniform sampler2D tex;
varying vec2 tex_position;

void vertex() {
	tex_position = VERTEX.xz + VERTEX.xy / 2.0 + 0.5;
	float x = VERTEX.x;
	float y = VERTEX.y;
	float z = VERTEX.z;

	float dx = x * sqrt(1.0 - (y*y/2.0) - (z*z/2.0) + (y*y*z*z/3.0));
	float dy = y * sqrt(1.0 - (z*z/2.0) - (x*x/2.0) + (z*z*x*x/3.0));
	float dz = z * sqrt(1.0 - (x*x/2.0) - (y*y/2.0) + (x*x*y*y/3.0));
	VERTEX = vec3(dx, dy, dz);
}


void fragment() {
	ALBEDO = texture(tex, tex_position).xyz;
}
